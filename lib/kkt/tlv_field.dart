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
import 'package:local_fiscal_service/utils/double_extension.dart';
import 'package:local_fiscal_service/utils/uint8list_extension.dart';
import 'package:local_fiscal_service/utils/int_extension.dart';

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
        break;
      case FieldType.UNIXTIME:
        return getUnixTime();
      case FieldType.UINT16:
        return getUint16(Field.DATA_OFFSET);
      case FieldType.UINT32:
        return getUint32();
      case FieldType.VLN:
        return getVLN();
      case FieldType.FVLN:
        return getFVLN();
      case FieldType.STLV:
      default:
        return buffer;
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
    if (tag.type != FieldType.BYTEARRAY) {
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
    Uint8List rawData = value.toByteArray();
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

  int getVLN() {
    Uint8List result = Uint8List(length + 1);
    //Adding zero in front to ensure positive value
    result[0] = 0x00;
    List.copyRange(result, 1, buffer, 0, length);
    result.swap(1, result.length);
    return result.toInt();
  }

  static TLVField makeFVLN(Tag tag, double value) {
    if(tag.type != FieldType.FVLN) {
      throw Exception("Tag must be of FVLN type.");
    }
    Uint8List rawData = ((value * 10).toInt()).toByteArray();
    int index = 0;
    //skip all non-significant bytes
    while (index < rawData.length && rawData[index] == 0x00) {
      index++;
    }
    Uint8List data = Uint8List(rawData.length - index + 1);
    //Setting decimal point position to first byte
    data[0] = value.scale();
    List.copyRange(data, index, rawData, 1, rawData.length - index);
    data.swap(1, data.length);
    TLVField result = new TLVField(tag: tag, length: data.length);
    result.setData(data);
    return result;
  }

  double getFVLN() {
    Uint8List result = Uint8List(length);
    //Adding zero in front to ensure positive value
    result[0] = 0x00;
    List.copyRange(result, 1, buffer, Field.DATA_OFFSET + 1, length - 1);
    int unscaledValue = result.swap(1, result.length).toInt();
    return unscaledValue.toDouble();
  }

  static TLVField makeString(Tag tag, String value) {
    if(tag.type != FieldType.STRING) {
      throw Exception("Tag must be of STRING type.");
    }
    Uint8List data = Uint8List.fromList(utf8.encode(value));
    TLVField result = new TLVField(tag: tag, length: data.length);
    result.setData(data);

    return result;
  }

  String getString() {
    return String.fromCharCodes(buffer, Field.DATA_OFFSET, length);
  }

  static TLVField makeUnixTime(Tag tag, DateTime value) {
    if(tag.type != FieldType.UNIXTIME) {
      throw Exception("Tag must be of UNIXTIME type.");
    }
    TLVField result = new TLVField(tag: tag, length: 4);
    result.setUnixTime(value);
    return result;
  }

  DateTime getUnixTime() {
    return DateTime.fromMillisecondsSinceEpoch(getUint32()*1000);
  }

  void setUnixTime(DateTime value) {
    setUint32(((value.millisecondsSinceEpoch)/1000).round());
  }

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

  void setUint32(int value) {
    buffer[Field.DATA_OFFSET] = value;
    buffer[Field.DATA_OFFSET + 1] = value >> 8;
    buffer[Field.DATA_OFFSET + 2] = value >> 16;
    buffer[Field.DATA_OFFSET + 3] = value >> 24;
  }

  int getUint32() {
    return (buffer[Field.DATA_OFFSET] & 0xFF)
        + ((buffer[Field.DATA_OFFSET+1] & 0xFF) << 8)
        + ((buffer[Field.DATA_OFFSET+2] & 0xFF) << 16)
        + ((buffer[Field.DATA_OFFSET+3] & 0xFF) << 24);
  }

  static Field makeFromBuffer(Uint8List buffer, {int offset = 0, int length}) {
    if (length != null) {
      List.copyRange(buffer, 0, buffer, offset, offset + length);
    }
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
      return TLVField.makeFromBuffer(buffer, offset: offset);
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
