import 'dart:typed_data';
import 'package:convert/convert.dart';

extension Conversion on String {
  Uint8List toBytes() {
    return Uint8List.fromList(this.codeUnits);
  }
}