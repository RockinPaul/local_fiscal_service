import 'dart:typed_data';

extension Conversion on Uint8List {
  int toInt() {
    ByteData bytes = ByteData.view(buffer);
    int toReturn = bytes.getUint16(0, Endian.little);
    return toReturn;
  }
}