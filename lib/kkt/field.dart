import 'dart:typed_data';

import 'package:local_fiscal_service/exceptions/unknown_tag_exception.dart';
import 'package:local_fiscal_service/utils/conversion_util.dart';
import 'package:local_fiscal_service/kkt/tag.dart';
import 'package:local_fiscal_service/kkt/field_type.dart';
import 'package:local_fiscal_service/kkt/stlv_field.dart';
import 'package:local_fiscal_service/kkt/tlv_field.dart';
import 'package:local_fiscal_service/utils/conversion_util.dart';
import 'package:characters/characters.dart';

class Field {
  static const int TAG_OFFSET = 0;
  static const int LENGTH_OFFSET = 2;
  static const int DATA_OFFSET = 4;
  static const int HEADER_SIZE = DATA_OFFSET;

  Uint8List _buffer;

  Field({Tag tag, int length, Uint8List data}) {
    if (length < 0 || tag.length > 0 && length > tag.length) {
      throw ('Value\'s length must not be more than ${tag.length} bytes.');
    } else if (tag.isFixedLength && length != tag.length) {
      throw ('Value\'s length must equal to ${tag.length} bytes.');
    }
    _buffer = Uint8List(length + HEADER_SIZE);
    setTag(tag);
    setLength(length);
  }

  setTag(Tag tag) {
    setUint16(tag.code, TAG_OFFSET);
  }

  setLength(int length) {
    setUint16(length, LENGTH_OFFSET);
  }

  setBuffer(Uint8List buffer) {
    _buffer = buffer;
  }

  Tag get tag => Tag.getByCode(getUint16(TAG_OFFSET));

  int get length => getUint16(LENGTH_OFFSET);

  int get size => length + HEADER_SIZE;

  Uint8List get buffer => buffer;

  setUint16(int value, int offset) {
    Uint8List values = Uint8List.fromList([value, value >> 8]);
    _buffer[offset] = values[0];
    _buffer[offset + 1] = values[1];
  }

  int getUint16(int offset) {
    return ((_buffer[offset + 1] & 0xFF) << 8) + (_buffer[offset] & 0xFF);
  }

  assign(Field other) {
    List.copyRange(_buffer, 0, other.buffer, 0, other.buffer.length);
  }

  static Field makeFromBuffer(Uint8List buffer, {int offset = 0, int length = 0}) {
    if (buffer.length + offset < HEADER_SIZE) {
      return null;
    }
    Field field = Field();
    List.copyRange(buffer, 0, buffer, offset, offset + HEADER_SIZE);
    if (field.tag == null) {
      throw UnknownTagException(field.getUint16(0));
    }
    if (FieldType.STLV == field.tag.type) {
      return Field.makeFromBuffer(buffer, offset: offset, length: field.size);
    } else {
      return TLVField.makeFromBuffer(buffer, offset: offset, length: field.size);
    }
  }

  @override
  bool operator ==(Object other) => other is Field && other.buffer == buffer;

  @override
  int get hashCode => buffer.hashCode;

  @override
  String toString() {
    Tag tag = this.tag;
    String result = '$tag \"(${tag.code}\")[$length\]: ';
    if (tag.type == FieldType.BITMASK || tag.type == FieldType.BYTEARRAY) {
      return result +
          "0x" +
          ConversionUtil.bytesToHex(
            buffer,
            offset: DATA_OFFSET,
          );
    } else {
      return result + value;
    }
  }

  Object get value => _buffer;
}
