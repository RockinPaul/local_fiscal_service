import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:charset_converter/charset_converter.dart';
import 'package:local_fiscal_service/kkt/field.dart';
import 'package:local_fiscal_service/kkt/field_type.dart';
import 'package:local_fiscal_service/kkt/tag.dart';
import 'package:local_fiscal_service/kkt/stlv_field.dart';
import 'package:local_fiscal_service/utils/conversion_util.dart';
import 'package:local_fiscal_service/utils/list_extension.dart';

class TLVField extends Field {
  // final String charset = CharsetConverter.;

  TLVField({Tag tag, int length, Uint8List data})
      : super(tag: tag, length: length, data: data) {
    setData(data);
  }

  setData(Uint8List value) {
    List.copyRange(buffer, 0, value, Field.DATA_OFFSET, value.length);
  }

  Object getValue() {
    switch(tag.type) {
      case FieldType.BYTE:
        return getByte();
      case FieldType.STRING:
        return getString();
      case FieldType.BYTEARRAY:
        return getByteArray();
      case FieldType.BITMASK:
        if (tag.length == 1) {
          return getBitMask()[0];
        } else {
          return getBitMask();
        }
      case FieldType.UNIXTIME:
        return getUnixTime();
      case FieldType.UINT16:
        return getUint16();
      case FieldType.UINT32:
        return getUint32();
      case FieldType.VLN:
        return getVLN();
      case FieldType.FVLN:
        return getFVLN();
      case FieldType.STLV:
      default:
        return getBuffer();
    }
  }

  static TLVField makeByte(Tag tag, int value) {
    if(tag.type != FieldType.BYTE) {
      throw new Exception('Tag must be of BYTE type.');
    }
    TLVField result = TLVField(tag: tag, length: tag.length);
    result.setByte(value);
    return result;
  }

  int getByte() {
    return buffer[Field.DATA_OFFSET];
  }

  void setByte(int value) {
    buffer[Field.DATA_OFFSET] = value;
  }

  int getUInt32() {
    return (buffer[Field.DATA_OFFSET] & 0xFF)
        + ((buffer[Field.DATA_OFFSET+1] & 0xFF) << 8)
        + ((buffer[Field.DATA_OFFSET+2] & 0xFF) << 16)
        + ((buffer[Field.DATA_OFFSET+3] & 0xFF) << 24);
  }

  static TLVField makeBitMask(Tag tag, Uint8List value) {
    if(tag.type != FieldType.BITMASK) {
      throw new Exception("Tag must be of BITMASK type.");
    }
    return new TLVField(tag: tag, data: value, length: value.length);
  }

  Uint8List getBitMask() {
    return getByteArray();
  }

  static TLVField makeByteArray(Tag tag, Uint8List value) {
    if(tag.type != FieldType.BYTEARRAY) {
      throw Exception("Tag must be of BYTEARRAY type.");
    }
    return TLVField(tag: tag, data: value, length: value.length);
  }

  Uint8List getByteArray() {
    Uint8List bytes = Uint8List(Field.DATA_OFFSET + length);
    List.copyRange(bytes, 0, buffer, Field.DATA_OFFSET, Field.DATA_OFFSET + length);
    return bytes;
  }

  static TLVField makeVLN(Tag tag, int value) {
    if(tag.type != FieldType.VLN) {
      throw new Exception("Tag must be of VLN type.");
    }
    Uint8List rawData = toByteArray(value);
    int index = 0;
    //skip all non-significant bytes
    while(index < rawData.length && rawData[index] == 0x00) {
      index++;
    }
    Uint8List data = Uint8List(rawData.length);
    List.copyRange(data, 0, rawData, index, rawData.length);
    data.swap(0, data.length);
    TLVField result = new TLVField(tag: tag, length: data.length);
    result.setData(data);
    return result;
  }

  static Uint8List toByteArray(int value) =>
      Uint8List(4)..buffer.asByteData().setInt32(0, value, Endian.little);
  // setTag(Tag tag) {
  //   setUint16(tag.code, Field.TAG_OFFSET);
  // }
  //
  // setLength(int length) {
  //   setUint16(length, Field.LENGTH_OFFSET);
  // }
  //
  // Tag getTag() {
  //   return Tag.getByCode(getUint16(Field.TAG_OFFSET));
  // }
  //
  // int getLength() {
  //   return getUint16(Field.LENGTH_OFFSET);
  // }
  //
  // int getSize() {
  //   return getLength() + Field.HEADER_SIZE;
  // }

  static TLVField makeUInt16(Tag tag, int value) {
    if(tag.type != FieldType.UINT16) {
      throw new Exception("Tag must be of UINT16 type.");
    } else if (value < 0) {
      throw new Exception("Value must not be negative.");
    }
    TLVField result = new TLVField(tag: tag, length: tag.length);
    result.setUint16(value, 0);
    return result;
  }

  setUint16(int value, int offset) {
    Uint8List values = Uint8List.fromList([value, value >> 8]);
    buffer[offset] = values[0];
    buffer[offset + 1] = values[1];
  }

  int getUint16(int offset) {
    return ((buffer[offset + 1] & 0xFF) << 8) + (buffer[offset] & 0xFF);
  }

  static Field makeFromBuffer(Uint8List buffer, int offset) {
    if (buffer == null || buffer.length + offset < Field.HEADER_SIZE) {
      return null;
    }
    Field field = new Field();
    List.copyRange(field.buffer, 0, buffer, offset, offset+ Field.HEADER_SIZE);
    if(field.tag == null) {
      throw new Exception(field.getUint16(0));
    }
    if (equals(FieldType.STLV, field.tag.type)) {
      return STLVField.makeFromBuffer(buffer, offset: offset, length: field.size);
    } else {
      return TLVField.makeFromBuffer(buffer, offset);
    }
  }

  static bool equals(Object o, Object a) {
    if (o == a)
      return true;
    if (o == null || o.runtimeType != a.runtimeType)
      return false;

    Field field = o;
    Field toCompare = a;
    return field.buffer == toCompare.buffer;
  }

  @override
  String toString() {
    Tag t = tag;
    String result = '$t (${t.code})[$length]: ';
    if(t.type == FieldType.BITMASK || t.type == FieldType.BYTEARRAY) {
      return result + "0x" + ConversionUtil.bytesToHex(buffer, offset: Field.DATA_OFFSET);
    } else {
      return result + getValue();
    }
  }

  Object get value {
    return buffer;
  }
}
