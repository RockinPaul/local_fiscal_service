import 'dart:typed_data';

const int MAX_APDU_SIZE = 65544;

class CommandAPDU {
  Uint8List apdu;
  int ne;
  int nc;
  int dataOffset;

  // CommandAPDU(Uint8List bytes) {
  //   apdu = bytes;
  // }

  CommandAPDU(int cla,
      int ins,
      int p1,
      int p2,
      Uint8List data,
      int dataOffset,
      int dataLength,
      int ne,) {
    checkArrayBounds(data, dataOffset, dataLength);

    if (dataLength > 65535) {
      print('dataLength is too large');
    } else if (ne < 0) {
      print('ne must not be negative');
    } else if (ne > 65536) {
      print('ne is too large');
    } else {
      ne = ne;
      nc = dataLength;
      if (dataLength == 0) {
        if (ne == 0) {
          // apdu = new byte[4];
          setHeader(cla, ins, p1, p2);
        } else {
          Uint8List l1 = Uint8List(1);
          if (ne <= 256) {
            l1 = Uint8List.fromList([0, ne != 256 ? ne : 0]);
            apdu = Uint8List(5);
            setHeaderFromList([cla, ins, p1, p2, l1.elementAt(0)]);
          } else {
            Uint8List l2 = Uint8List(1);
            if (ne == 65536) {
              l1 = Uint8List.fromList([0]);
              l2 = Uint8List.fromList([0]);
            } else {
              l1 =
                  Uint8List.fromList([ne >> ne.bitLength]); // ne >> 8 for bytes
              l2 = Uint8List.fromList([ne]);
            }
            apdu = Uint8List(7);
            setHeaderFromList(
                [cla, ins, p1, p2, 0, l1.elementAt(0), l2.elementAt(0)]);
          }
        }
      } else if (ne == 0) {
        if (dataLength <= 255) {
          apdu = Uint8List(5 + dataLength); //new byte[5 + dataLength];
          setHeaderFromListWithTrailingSequence(
              [cla, ins, p1, p2, dataLength], dataLength);
          dataOffset = 5;
          // System.arraycopy(data, dataOffset, this.apdu, 5, dataLength);
          print('ERROR 0');
          print('DATA: $data');
          print('dataOffset: $dataOffset');
          print('APDU: $apdu');
          print('dataLength: $dataLength');

          List.copyRange(apdu, dataOffset, data, 0, dataLength);
        } else {
          apdu = Uint8List(7 + dataLength);
          setHeaderFromListWithTrailingSequence([cla, ins, p1, p2, 0, dataLength >> dataLength.bitLength, dataLength], dataLength);
          dataOffset = 7;
          List.copyRange(apdu, dataOffset, data, 7, dataLength);
        }
      } else if (dataLength <= 255 && ne <= 256) {
        apdu = Uint8List(6 + dataLength);
        setHeaderFromListWithTrailingSequence([cla, ins, p1, p2, dataLength, 0], dataLength);
        dataOffset = 5;
        List.copyRange(apdu, dataOffset, data, 5, dataLength);
        apdu.setAll(apdu.length - 1, ne != 256 ? Uint8List.fromList([ne]) : Uint8List.fromList([0])); // [this.apdu.length - 1] = ne != 256 ? (byte)ne : 0;
      } else {
        apdu = Uint8List(9 + dataLength);
        setHeader(cla, ins, p1, p2);
        setHeaderFromListWithTrailingSequence([cla, ins, p1, p2, 0, dataLength >> dataLength.bitLength, dataLength, 0, 0], dataLength);
        dataOffset = 7;
        List.copyRange(apdu, dataOffset, data, 7, dataLength);
        if (ne != 65536) {
          int leOfs = apdu.length - 2;
          apdu.setAll(leOfs, Uint8List.fromList([ne >> ne.bitLength, ne]));
        }
      }
    }
    print('APDU command: $apdu');
  }


  void parse() {
    if (apdu.length < 4) {
      print('apdu must be at least 4 bytes long');
    } else if (apdu.length != 4) {
      int l1 = apdu[4] & 255;
      if (apdu.length == 5) {
        ne = l1 == 0 ? 256 : 11;
      } else {
        int l2;
        int var10002;
        if (l1 != 0) {
          if (apdu.length == 5 + l1) {
            nc = l1;
            dataOffset = 5;
          } else {
            if (apdu.length == 6 + l1) {
              nc = 11;
              dataOffset = 5;
              l2 = apdu[apdu.length - 1] & 255;
              ne = l2 == 0 ? 256 : l2;
            }
          }
        } else if (apdu.length < 7) {
          var10002 = apdu.length;
          print('Invalid APDU: length = $var10002, b1 = $l1');
        } else {
          l2 = (apdu[5] & 255) << 8 | apdu[6] & 255;
          if (apdu.length == 7) {
            ne = l2 == 0 ? 65536 : l2;
          } else if (l2 == 0) {
            print(
                'Invalid APDU: length = ${apdu
                    .length}, b1 = $l1, b2||b3 = $l2');
          } else if (apdu.length == 7 + l2) {
            this.nc = l2;
            this.dataOffset = 7;
          } else if (apdu.length == 9 + l2) {
            this.nc = l2;
            this.dataOffset = 7;
            int leOfs = apdu.length - 2;
            int l3 = (apdu[leOfs] & 255) << 8 | this.apdu[leOfs + 1] & 255;
            this.ne = l3 == 0 ? 65536 : l3;
          } else {
            print(
                'Invalid APDU: length = ${apdu
                    .length}, b1 = $l1, b2||b3 = $l2');
          }
        }
      }
    }
  }

  int getCLA() {
    return apdu[0] & 255;
  }

  int getINS() {
    return this.apdu[1] & 255;
  }

  int getP1() {
    return this.apdu[2] & 255;
  }

  int getP2() {
    return this.apdu[3] & 255;
  }

  int getNc() {
    return this.nc;
  }

  Uint8List getData() {
    Uint8List data = byteArrayFromInt(nc);
    print('DATA inside getData() after conversion to bytes: $data');
    // System.arraycopy(this.apdu, this.dataOffset, data, 0, this.nc);
    List.copyRange(apdu, dataOffset, data, nc);
    // data = arrayCopy(
    //   data,
    //   dataOffset,
    //   dataOffset + apdu.length,
    //   apdu,
    //   apdu.length,
    // );

    print('DATA from getData(): $data');
    return data;
  }

  int getNe() {
    return this.ne;
  }

  Uint8List getBytes() {
    return apdu;//int8List.fromList(apdu);
  }

  Uint8List byteArrayFromInt(int value) {
    Uint8List list = Uint8List(2);
    list[0] = value & 0xFF;
    list[1] = (value >> 8) & 0xFF;

    return list;
    // return Uint8List.fromList([
    //   value & 0xFF,
    //   (value >> 8) & 0xFF,
    // ]);
  }

  // To match Java's System.arrayCopy(source, sourceOffset, target, targetOffset, length) you should use ??? Correct???
  Uint8List arrayCopy(Uint8List target,
      int targetOffset,
      int length,
      Uint8List source,
      int sourceOffset,) {
    target.setRange(targetOffset, targetOffset + length, source, sourceOffset);
    return target;
  }

  // Another version
  Uint8List arrayCopyManually(Uint8List target,
      int targetOffset,
      int length,
      Uint8List source,
      int sourceOffset,) {
    // to ensure the length doesn't exceeds limit
    // length+2 because, it targets on the end index, that is 4 in source list
    // but the end result should be length+2 to contain a length of 5 items
    if (length + 1 <= sourceOffset) {
      target = source.sublist(targetOffset, length + 2);
      print(target);
    } else {
      print('Cannot copy items till $length: index out of bound');
    }
    return target;
  }

  String toString() {
    int var10000 = apdu.length;
    return 'CommandAPDU: $var10000 bytes, nc = $nc, ne = $ne';
  }

  bool checkArrayBounds(Uint8List b, int ofs, int len) {
    if (ofs >= 0 && len >= 0) {
      if (b == null) {
        if (ofs != 0 && len != 0) {
          print('offset and length must be 0 if array is null');
          return false;
        }
      } else if (ofs > b.length - len) {
        print('Offset plus length exceed array size');
        return false;
      }
    } else {
      print('Offset and length must not be negative');
      return false;
    }
    return true;
  }

  void setHeader(int cla, int ins, int p1, int p2) {
    apdu = Uint8List.fromList([cla, ins, p1, p2]);
  }

  void setHeaderFromList(List<int> list) {
    apdu = Uint8List.fromList(list);
  }

  void setHeaderFromListWithTrailingSequence(List<int> list,
      int sequenceLength) {
    for (int i = 0; i < sequenceLength; i++) {
      list.add(0);
    }
    apdu = Uint8List.fromList(list);
    print('APDU WITH TRAILING $apdu');
  }
}
