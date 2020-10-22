import 'dart:collection';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:local_fiscal_service/kkt/field.dart';
import 'package:local_fiscal_service/kkt/stlv_field.dart';
import 'package:local_fiscal_service/kkt/field_type.dart';
import 'package:local_fiscal_service/kkt/fn_record_type.dart';
import 'package:local_fiscal_service/kkt/tag.dart';
import 'package:local_fiscal_service/kkt/tlv_field.dart';
import 'package:local_fiscal_service/utils/conversion_util.dart';


class FnRecord {
  // ignore: non_constant_identifier_names
  static final int TYPE_OFFSET = 0;
  // ignore: non_constant_identifier_names
  static final int LENGTH_OFFSET = 2;
  // ignore: non_constant_identifier_names
  static final int FIELDS_OFFSET = 4;
  // ignore: non_constant_identifier_names
  static final int SIGNATURE_SIZE = 8;
  FnRecordType _type;
  int _length;
  List<Field> _fields = List<Field>();
  final Uint8List _signature = Uint8List(SIGNATURE_SIZE);
  String _fnNumber;
  int _fdNumber;
  Uint8List _fiscalMark;

  // ignore: non_constant_identifier_names
  static final int DATA_FORMAT_VERSION = 0x01; //default for Tag.DATA_FORMAT_VERSION
  // ignore: non_constant_identifier_names
  static final int HEADER_SIZE = FIELDS_OFFSET;
  // ignore: non_constant_identifier_names
  static final int LENGTH_SIZE = FIELDS_OFFSET - LENGTH_OFFSET;

  static Map<FnRecordType, LinkedHashSet<Tag>> mandatoryTags = Map<FnRecordType, LinkedHashSet<Tag>>();

  mandatoryTagsInit() {
    // var set1 = (LinkedHashSet<Tag> set) => LinkedHashSet<Tag>.from([Tag.USER_INN,
    //   Tag.DATE_TIME,
    //   Tag.KKT_REGISTER_NUMBER,
    //   Tag.OFD_INN,
    //   Tag.FD_NUMBER,
    //   Tag.FN_SERIAL_NUMBER]);
    mandatoryTags[FnRecordType.REGISTRATION_REPORT] = LinkedHashSet<Tag>.from([Tag.USER_INN,
      Tag.DATE_TIME,
      Tag.KKT_REGISTER_NUMBER,
      Tag.OFD_INN,
      Tag.FD_NUMBER,
      Tag.FN_SERIAL_NUMBER]);
    // mandatoryTags.update(FnRecordType.REGISTRATION_REPORT, set1);

    // var set2 = (LinkedHashSet<Tag> set) => LinkedHashSet<Tag>.from([Tag.DATE_TIME,
    //   Tag.SHIFT_NUMBER,
    //   Tag.FD_NUMBER,
    //   Tag.FN_SERIAL_NUMBER]);
    mandatoryTags[FnRecordType.OPEN_SHIFT_REPORT] = LinkedHashSet<Tag>.from([Tag.DATE_TIME,
      Tag.SHIFT_NUMBER,
      Tag.FD_NUMBER,
      Tag.FN_SERIAL_NUMBER]);
    // mandatoryTags.update(FnRecordType.OPEN_SHIFT_REPORT, set2);

    // var set3 = (LinkedHashSet<Tag> set) => LinkedHashSet<Tag>.from([
    //   Tag.DATE_TIME,
    //   Tag.UNCONFIRMED_FDS_AMOUNT,
    //   Tag.FIRST_UNCONFIRMED_FD_TIMESTAMP,
    //   Tag.FD_NUMBER,
    //   Tag.FN_SERIAL_NUMBER]);
    mandatoryTags[FnRecordType.CURRENT_STATE_REPORT] = LinkedHashSet<Tag>.from([
      Tag.DATE_TIME,
      Tag.UNCONFIRMED_FDS_AMOUNT,
      Tag.FIRST_UNCONFIRMED_FD_TIMESTAMP,
      Tag.FD_NUMBER,
      Tag.FN_SERIAL_NUMBER]);
    // mandatoryTags.update(FnRecordType.CURRENT_STATE_REPORT, set3);

    // var set4 = (LinkedHashSet<Tag> set) => LinkedHashSet<Tag>.from([
    //   Tag.DATE_TIME,
    //   Tag.OPERATION_TYPE,
    //   Tag.TICKET_TOTAL_SUM,
    //   Tag.FD_NUMBER,
    //   Tag.FN_SERIAL_NUMBER]);
    mandatoryTags[FnRecordType.TICKET] = LinkedHashSet<Tag>.from([
      Tag.DATE_TIME,
      Tag.OPERATION_TYPE,
      Tag.TICKET_TOTAL_SUM,
      Tag.FD_NUMBER,
      Tag.FN_SERIAL_NUMBER]);
    // mandatoryTags.update(FnRecordType.TICKET, set4);

    // var set5 = (LinkedHashSet<Tag> set) => LinkedHashSet<Tag>.from([
    //   Tag.DATE_TIME,
    //   Tag.KKT_REGISTER_NUMBER,
    //   Tag.FD_NUMBER,
    //   Tag.FN_SERIAL_NUMBER]);
    mandatoryTags[FnRecordType.CLOSE_FN_REPORT] = LinkedHashSet<Tag>.from([
      Tag.DATE_TIME,
      Tag.KKT_REGISTER_NUMBER,
      Tag.FD_NUMBER,
      Tag.FN_SERIAL_NUMBER]);
    // mandatoryTags.update(FnRecordType.CLOSE_FN_REPORT, set5);

    // var set6 = (LinkedHashSet<Tag> set) => LinkedHashSet<Tag>.from([
    //   Tag.OFD_INN,
    //   Tag.FN_SERIAL_NUMBER,
    //   Tag.FD_NUMBER,
    //   Tag.DATE_TIME]);
    mandatoryTags[FnRecordType.OPERATOR_ACK] = LinkedHashSet<Tag>.from([
      Tag.OFD_INN,
      Tag.FN_SERIAL_NUMBER,
      Tag.FD_NUMBER,
      Tag.DATE_TIME]);
    // mandatoryTags.update(FnRecordType.OPERATOR_ACK, set6);

    LinkedHashSet<Tag> ticketTags = mandatoryTags[FnRecordType.TICKET];
    // var set7 = (LinkedHashSet<Tag> set) => ticketTags;

    mandatoryTags[FnRecordType.CORRECTION_TICKET] = ticketTags;
    mandatoryTags[FnRecordType.ACC_FORM] = ticketTags;
    mandatoryTags[FnRecordType.CORRECTION_ACC_FORM] = ticketTags;

    LinkedHashSet<Tag> registrationReportTags = mandatoryTags[FnRecordType.REGISTRATION_REPORT];
    // var set8 = (LinkedHashSet<Tag> set) => registrationReportTags;

    mandatoryTags[FnRecordType.REGISTRATION_CHANGE_REPORT] = registrationReportTags;

    LinkedHashSet<Tag> openShiftReport = mandatoryTags[FnRecordType.OPEN_SHIFT_REPORT];
    // var set9 = (LinkedHashSet<Tag> set) => openShiftReport;

    mandatoryTags[FnRecordType.CLOSE_SHIFT_REPORT] = openShiftReport;
  }

  static bool isTagMandatory(Tag tag, FnRecordType docType) {
    return mandatoryTags[docType].contains(tag);
  }

  // bool isTagMandatory(Tag tag) {
  //   return isTagMandatory(_type, tag);
  // }

  bool isAllRequiredTagsSet(){
    Iterable<Tag> tags = mandatoryTags[_type].where((tag) => getFieldByTag(tag) != null);
    return mandatoryTags[_type].length == tags.length;
  }

  static Set<Tag> getRequiredTagsForType(FnRecordType type){
    return mandatoryTags[type];
  }

  FnRecord.withType(FnRecordType type) {
    mandatoryTagsInit();
    this._type = type;
  }
//
  FnRecord.withBuffer(Uint8List buffer) {
    FnRecord(buffer, true);
  }

  FnRecord(Uint8List buffer, bool includeSignature) {
    mandatoryTagsInit();

    int tailLen = (includeSignature ? SIGNATURE_SIZE : 0);
    if (buffer == null || buffer.length < HEADER_SIZE + tailLen) {
      throw Exception("Incorrect buffer size");
    }
    _type = FnRecordType.byCode(ConversionUtil.leToUInt16(buffer, offset: TYPE_OFFSET));
    _length = ConversionUtil.leToUInt16(buffer, offset: LENGTH_OFFSET);
    int offset = FIELDS_OFFSET;
    if (buffer.length > HEADER_SIZE + tailLen) {
      try {
        Field field = Field.makeFromBuffer(buffer, offset: offset);
          while (field != null) {
            addField(field);
            int fieldSize = field.size;
            offset += fieldSize;
            if (offset - HEADER_SIZE >= _length) {
              break;
            }
          field = Field.makeFromBuffer(buffer, offset: offset);
          }
      } catch (e) {
        throw new Exception(e);
      }
    }
    if (offset - HEADER_SIZE != _length) {
      throw new Exception("Incorrect input data format");
    }
    if (includeSignature) {
      List.copyRange(_signature, 0, buffer, 0, SIGNATURE_SIZE);
    }
  }


  static FnRecord construct(Uint8List buffer) {
    return FnRecord(buffer, true);
  }

  static FnRecord constructWithoutSignature(Uint8List buffer) {
    return new FnRecord(buffer, false);
  }

  FnRecordType get type => _type;

  int get length => _length;

  Uint8List getHeaderBuffer() {
    Uint8List result = Uint8List(HEADER_SIZE);
    ConversionUtil.uint16ToLe(result, value: type.code, offset: TYPE_OFFSET);
    ConversionUtil.uint16ToLe(result, value: _length , offset: LENGTH_OFFSET);
    return result;
  }

  List<Field> get fields => _fields;

  Field getFieldByTag(Tag tag) {
    return STLVField.getFieldByTag(tag, _fields);
  }

  List<Field> getFieldsByTag(Tag tag) {
   List<Field> result = List<Field>();
    for(Field field in fields) {
      if(field.tag == tag) {
        result.add(field);
      }
    }
    return result;
  }

  Uint8List getSignature() => _signature;

  void setSignature(Uint8List data, {int offset = 0}) {
    List.copyRange(_signature, 0, data, offset, SIGNATURE_SIZE);
  }

  String get fnNumber => _fnNumber;

  int get fdNumber => _fdNumber;

  Uint8List get fiscalMark => _fiscalMark;

  FnRecord add(Field field) {
    addField(field);
    _length += field.size;
    return this;
  }

  Uint8List serialize() {
    return doSerialize(true, true);
  }

  Uint8List serializeForSigning() {
    return doSerialize(false, true);
  }

  Uint8List serializeForFiscalMark() {
    return extractMandatoryFields().doSerialize(false, false);
  }

  Uint8List doSerialize(bool includeSignature, bool includeLength) {
    int size = length + HEADER_SIZE;
    if(!includeLength) {
      size -= LENGTH_SIZE;
    }
    if(includeSignature) {
      size += SIGNATURE_SIZE;
    }
    Uint8List result = Uint8List(size);
    int offset = FIELDS_OFFSET;
    ConversionUtil.uint16ToLe(result, value: type.code, offset: TYPE_OFFSET);
    if (includeLength) {
      ConversionUtil.uint16ToLe(result, value: length, offset: LENGTH_OFFSET);
    } else {
      offset -= LENGTH_SIZE;
    }
    for (Field field in fields) {
      List.copyRange(result, offset, field.buffer, 0, field.size);
      offset += field.size;
    }
    if (includeSignature) {
      List.copyRange(result, offset, _signature, 0, SIGNATURE_SIZE);
    }
    return result;
  }

  List<Uint8List> serializeFields({List<Field> fields}) {
    if (fields == null) {
      fields = _fields;
    }
    List<Uint8List> result = List<Uint8List>();
    for(Field field in fields) {
      if (field.runtimeType == STLVField) {
        STLVField stlvField = field;
        result.addAll(serializeFields(fields: stlvField.getFields()));
      } else {
        //TODO
  //                byte[] fieldBuf = new byte[field.getSize()];
  //                System.arraycopy(field.getBuffer(), 0, result, 0, field.getSize());
      }
    }
    return result;
  }

 void addField(Field field) {
    TLVField tlvField = field;
    if (field.tag == Tag.FN_SERIAL_NUMBER) {
      _fnNumber = tlvField.getString();
    } else if (field.tag == Tag.FD_NUMBER) {
      _fdNumber = tlvField.getUint32();
    } else if(field.tag == Tag.DOCUMENT_FISCAL_MARK) {
      _fiscalMark = tlvField.getByteArray();
    }
    _fields.add(field);
  }


  FnRecord extractMandatoryFields () {
    FnRecord result = new FnRecord.withType(type);
    for(Field field in fields) {
      if (isTagMandatory(field.tag, _type)) {
        result.add(field);
      }
    }
    result.fields.sort((a, b) => a.tag.code.compareTo(b.tag.code));
    return result;
  }

  static List<Field> extractFields(Uint8List buffer, final int offset, final int size) {
    List<Field> result = List<Field>();
    int off = offset;
    try {
      Field field = Field.makeFromBuffer(buffer, offset: off);
      while (field != null) {
        result.add(field);
        int fieldSize = field.size;
        off += fieldSize;
        if (off >= offset + size) {
          break;
        }
        field = Field.makeFromBuffer(buffer, offset: off);
      }
    } catch (e) {
    throw Exception(e);
    }
    if (off != offset + size) {
      throw Exception("Incorrect input data");
    }
    return result;
  }

// @Override
// public boolean equals(Object o) {
//   if(this == o)
//     return true;
//   if(o == null || getClass() != o.getClass())
//     return false;
//
//   FnRecord fnRecord = (FnRecord)o;
//
//   return Objects.equals(type, fnRecord.type) && length == fnRecord.length &&
//       Objects.equals(fields, fnRecord.fields) && Arrays.equals(signature, fnRecord.signature);
// }

// @Override
// public int hashCode() {
//   return Objects.hash(type, length, fields, signature);
// }
//
// @Override
// public String toString() {
//   StringBuffer sb = new StringBuffer();
//   sb.append("{\n").append("  type: ").append(type).append(",\n  length: ").append(length).append(",\n  fields: {\n");
//   for(Field field : fields) {
//     String fieldStr = field.toString();
//     if(field.getTag().getType() == FieldType.STLV) {
//       fieldStr = fieldStr.replace("\n", "\n    ");
//     }
//     sb.append("    ").append(fieldStr).append(",\n");
//   }
//   sb.append("  },\n}");
//   return sb.toString();
// }
//
  FnRecord clone() {
    return FnRecord.construct(serialize());
  }
}
