import 'dart:typed_data';

import 'package:local_fiscal_service/exceptions/unknown_tag_exception.dart';
import 'package:local_fiscal_service/utils/conversion_util.dart';
import 'package:local_fiscal_service/kkt/tag.dart';
import 'package:local_fiscal_service/kkt/field_type.dart';

class Field {
  static const int _TAG_OFFSET = 0;
  static const int _LENGTH_OFFSET = 2;
  static const int _DATA_OFFSET = 4;
  static const int HEADER_SIZE = _DATA_OFFSET;

  Uint8List buffer;

  Field(Tag tag, int length) {
    if (length < 0 || tag.length > 0 && length > tag.length) {
      throw('Value\'s length must not be more than ${tag.length} bytes.');
    } else if (tag.isFixedLength && length != tag.length) {
      throw('Value\'s length must equal to ${tag.length} bytes.');
    }
    buffer = Uint8List(length + HEADER_SIZE);
    _setTag(tag);
    _setLength(length);
  }

  _setTag(Tag tag) {
    _setUint16(tag.code, _TAG_OFFSET);
  }

  _setLength(int length) {
    _setUint16(length, _LENGTH_OFFSET);
  }

  _setUint16(int value, int offset) {
    Uint8List values = Uint8List.fromList([value, value >> 8]);
    buffer[offset] = values[0];
    buffer[offset + 1] = values[1];
  }
}