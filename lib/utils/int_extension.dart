import 'dart:typed_data';

extension IntExtension on int {
  int tripleShift(int count) {
    return (this >> count) & ~(-1 << (64 - count));
  }

  Uint8List toByteArray() =>
      Uint8List(4)..buffer.asByteData().setInt32(0, this, Endian.little);
}