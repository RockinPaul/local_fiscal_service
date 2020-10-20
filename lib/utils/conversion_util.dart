import 'dart:typed_data';
import 'package:characters/characters.dart';
import 'dart:convert';

class ConversionUtil {

  Characters hexArray = '0123456789ABCDEF'.characters;

  static String bytesToHex(Uint8List bytes, {int offset = 0}) {
    Uint8List hexChars = Uint8List((bytes.length - offset) * 2);
    for (int i = offset; i < bytes.length; i++) {
      int v = bytes[i] & 0xFF;
      // hexChars[(i - offset) * 2] = hexArray[v >>> 4];
    }
  }
}