import 'dart:typed_data';

class CRC16CCITT {
  // ignore: non_constant_identifier_names
  static int POLYNOMIAL = 0x1021;
  static int crc = 0xFFFF;

  reset() {
    crc = 0xFFFF;
  }

  update(int b) {
    for (int i = 0; i < 8; i++) {
      bool bit = ((b >> (7 - i) & 1) == 1);
      bool c15 = ((crc >> 15 & 1) == 1);
      crc <<= 1;
      if (c15 ^ bit) crc ^= POLYNOMIAL;
    }
  }

  int get value => crc & 0xFFFF;

  int calc(Uint8List bytes) {
    for (var b in bytes) {
      update(b);
    }
    return value;
  }
}