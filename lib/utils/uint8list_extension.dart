import 'dart:typed_data';

extension Conversion on Uint8List {
  int toInt() {
    ByteData bytes = ByteData.view(buffer);
    int toReturn = bytes.getUint16(0, Endian.little);
    return toReturn;
  }

  Uint8List swap(int from, int to) {
    if (length == 1) {
      return this;
    }
    if (from < 0 || to < 0 || to > length || from >= to) {
      return null;
    }
    for (int i = from, j = to - 1; (i - from) < (to - from) / 2; i++, j--) {
      var tmp = this[i];
      this[i] = this[j];
      this[j] = tmp;
    }
    return this;
  }
}