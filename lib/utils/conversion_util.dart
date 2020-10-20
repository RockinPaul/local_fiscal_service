import 'dart:typed_data';
import 'package:characters/characters.dart';
import 'dart:convert';
import 'package:local_fiscal_service/utils/int_extension.dart';
import 'package:local_fiscal_service/kkt/tag.dart';

class ConversionUtil {

  

  Uint8List fromPrintableFiscalMark(int fiscalMark) {
    Uint8List result = Uint8List(Tag.DOCUMENT_FISCAL_MARK.length);
    for(int i = result.length-1; i>=0; i--) {
      result[i] = fiscalMark & 0xFF;
      fiscalMark >>= 8;
    }
    return result;
  }

  static Uint8List invertByteArray(Uint8List b) {
    for(int i=0; i < b.length; i++){
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
