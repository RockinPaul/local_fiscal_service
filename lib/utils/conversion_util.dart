import 'dart:typed_data';
import 'package:characters/characters.dart';
import 'dart:convert';
import 'package:local_fiscal_service/utils/int_extension.dart';
import 'package:local_fiscal_service/kkt/tag.dart';

class ConversionUtil {

  static int leToUInt16(Uint8List bytes, {int offset = 0}) {
    return (bytes[offset + 1] & 0xFF) << 8 | (bytes[offset] & 0xFF);
  }

  static Uint8List uint16ToLe(Uint8List bytes, {int value, int offset = 0}) {
    if (value != null) {
      bytes[offset] = value & 0xFF;
      bytes[offset + 1] = (value >> 8) & 0xFF;
    } else {
      bytes[offset] = 0xFF;
      bytes[offset + 1] = 0xFF;
    }
    return bytes;
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
}
