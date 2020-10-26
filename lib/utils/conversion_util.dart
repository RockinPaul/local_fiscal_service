import 'dart:typed_data';
import 'package:characters/characters.dart';
import 'package:local_fiscal_service/utils/int_extension.dart';
import 'package:local_fiscal_service/kkt/tag.dart';

class ConversionUtil {

  static int leToUInt16(Uint8List bytes, {int offset = 0}) {
    // return (bytes[offset + 1] & 0xFF) << 8 | (bytes[offset] & 0xFF);
    ByteData byteData = ByteData.view(bytes.buffer);
    int short = byteData.getInt16(0, Endian.little);
    return short;
  }

  static Uint8List uint16ToLe(int value, {Uint8List bytes, int offset = 0}) {
    if (bytes != null && bytes.isNotEmpty) {
      bytes[offset] = value & 0xFF;
      bytes[offset + 1] = (value >> 8) & 0xFF;
      return bytes;
    } else {
      Uint8List result = Uint8List(2);
      result[0] = value & 0xFF;
      result[1] = (value >> 8) & 0xFF;
      return result;
    }
  }

  static int leToUInt32(Uint8List bytes, {int offset = 0}) {
    return (bytes[offset + 3] & 0xFF) << 24 |
    (bytes[offset + 2] & 0xFF) << 16 |
    (bytes[offset + 1] & 0xFF) << 8 |
    (bytes[offset] & 0xFF);
  }

  static Uint8List uint32ToLe(Uint8List bytes, {int value, int offset = 0}) {
    if (value != null) {
      bytes[offset] = value & 0xFF;
      bytes[offset + 1] = (value >> 8) & 0xFF;
      bytes[offset + 2] = (value >> 16) & 0xFF;
      bytes[offset + 3] = (value >> 24) & 0xFF;
    } else {
      bytes[offset] = 0xFF;
      bytes[offset + 1] = 0xFF;
      bytes[offset + 2] = 0xFF;
      bytes[offset + 3] = 0xFF;
    }
    return bytes;
  }

  static int toPrintableFiscalMark(Uint8List fiscalMark) {
    if (fiscalMark == null) {
      return null;
    }
    if (fiscalMark.length != Tag.DOCUMENT_FISCAL_MARK.length) {
      throw Exception("Incorrect fiscal mark size");
    }
    int result = 0;
    for (int i = 0; i < fiscalMark.length; i++) {
      result <<= 8;
      result |= (fiscalMark[i] & 0xFF);
    }
    return result;
  }

  static Uint8List fromPrintableFiscalMark(int fiscalMark) {
    Uint8List result = Uint8List(Tag.DOCUMENT_FISCAL_MARK.length);
    for (int i = result.length - 1; i >= 0; i--) {
      result[i] = fiscalMark & 0xFF;
      fiscalMark >>= 8;
    }
    return result;
  }

  static Uint8List invertByteArray(Uint8List b) {
    for (int i = 0; i < b.length; i++) {
      b[i] = ~b[i];
    }
    return b;
  }

  static Uint8List uint32ToBe(int value) {
    return Uint8List.fromList([
      ((value >> 24) & 0xFF),
      ((value >> 16) & 0xFF),
      ((value >> 8) & 0xFF),
      (value & 0xFF),
    ]);
  }

  static int beToUint32(Uint8List bytes) {
    return ((bytes[0] & 255) << 24 |
    (bytes[1] & 255) << 16 |
    (bytes[2] & 255) << 8 |
    bytes[3] & 255);
  }

  static Characters hexArray = '0123456789ABCDEF'.characters;

  static String bytesToHex(Uint8List bytes, {int offset = 0}) {
    List<String> hexChars = List<String>(((bytes.length - offset) * 2));
    for (int i = offset; i < bytes.length; i++) {
      int v = bytes[i] & 0xFF;
      hexChars[(i - offset) * 2] = hexArray.elementAt(v.tripleShift(4));
      hexChars[(i - offset) * 2 + 1] = hexArray.elementAt(v & 0x0F);
    }
    return hexChars.join();
  }

  // FROM Java BigInteger implementation
  // Uint8List toByteArray(int value) {
  //   int byteLen = (value.bitLength / 8 + 1).toInt();
  //   Uint8List byteArray = Uint8List(byteLen);
  //
  //   for (int i = byteLen - 1, bytesCopied = 4, nextInt = 0, intIndex = 0; i >= 0; i--) {
  //     if (bytesCopied == 4) {
  //       nextInt = getInt(intIndex++);
  //       bytesCopied = 1;
  //     } else {
  //       nextInt = nextInt >>>= 8;
  //   bytesCopied++;
  //   }
  //   byteArray[i] = (byte)nextInt;
  //   }
  //   return byteArray;
  // }

  // Returns the specified int of the little-endian two's complement
  // representation (int 0 is the least significant).  The int number can
  // be arbitrarily high (values are logically preceded by infinitely many
  // sign ints).

  // int getInt(int n) {
  //   if (n < 0)
  //     return 0;
  //   if (n >= mag.length)
  //     return signInt();
  //
  //   int magInt = mag[mag.length-n-1];
  //
  //   return (signum >= 0 ? magInt :
  //   (n <= firstNonzeroIntNum() ? -magInt : ~magInt));
  // }

  /* Returns an int of sign bits */
  // int signInt(int i) {
  //   return i < 0 ? -1 : 0;
  // }
}
