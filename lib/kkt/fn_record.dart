import 'dart:typed_data';

import 'package:local_fiscal_service/kkt/field.dart';
import 'package:local_fiscal_service/kkt/field_type.dart';
import 'package:local_fiscal_service/kkt/fn_record_type.dart';
import 'package:local_fiscal_service/kkt/tag.dart';
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

  static Map<FnRecordType, Set<Tag>> mandatoryTags = Map<FnRecordType, Set<Tag>>();

  mandatoryTagsInit() {
    Set<Tag> set1 = Set.of([Tag.USER_INN,
      Tag.DATE_TIME,
      Tag.KKT_REGISTER_NUMBER,
      Tag.OFD_INN,
      Tag.FD_NUMBER,
      Tag.FN_SERIAL_NUMBER]);

    mandatoryTags.putIfAbsent(FnRecordType.REGISTRATION_REPORT, set1);
    mandatoryTags.putIfAbsent(FnRecordType.OPEN_SHIFT_REPORT, Set<Tag>.from([
      Tag.DATE_TIME,
      Tag.SHIFT_NUMBER,
      Tag.FD_NUMBER,
      Tag.FN_SERIAL_NUMBER]));
    mandatoryTags.putIfAbsent(FnRecordType.CURRENT_STATE_REPORT, Set<Tag>.from([
      Tag.DATE_TIME,
      Tag.UNCONFIRMED_FDS_AMOUNT,
      Tag.FIRST_UNCONFIRMED_FD_TIMESTAMP,
      Tag.FD_NUMBER,
      Tag.FN_SERIAL_NUMBER]));
    mandatoryTags.putIfAbsent(FnRecordType.TICKET, Set<Tag>.from([
      Tag.DATE_TIME,
      Tag.OPERATION_TYPE,
      Tag.TICKET_TOTAL_SUM,
      Tag.FD_NUMBER,
      Tag.FN_SERIAL_NUMBER]));
    mandatoryTags.putIfAbsent(FnRecordType.CLOSE_FN_REPORT, Set<Tag>.from([
      Tag.DATE_TIME,
      Tag.KKT_REGISTER_NUMBER,
      Tag.FD_NUMBER,
      Tag.FN_SERIAL_NUMBER]));
    mandatoryTags.putIfAbsent(FnRecordType.OPERATOR_ACK, Set<Tag>.from([
      Tag.OFD_INN,
      Tag.FN_SERIAL_NUMBER,
      Tag.FD_NUMBER,
      Tag.DATE_TIME]));

    mandatoryTags.putIfAbsent(FnRecordType.CORRECTION_TICKET, mandatoryTags[FnRecordType.TICKET]);
    mandatoryTags.putIfAbsent(FnRecordType.ACC_FORM, mandatoryTags[FnRecordType.TICKET]);
    mandatoryTags.putIfAbsent(FnRecordType.CORRECTION_ACC_FORM, mandatoryTags[FnRecordType.TICKET]);
    mandatoryTags.putIfAbsent(FnRecordType.REGISTRATION_CHANGE_REPORT, mandatoryTags[FnRecordType.REGISTRATION_REPORT]);
    mandatoryTags.putIfAbsent(FnRecordType.CLOSE_SHIFT_REPORT, mandatoryTags[FnRecordType.OPEN_SHIFT_REPORT]);
  }

  static bool isTagMandatory(FnRecordType docType, Tag tag) {
    return mandatoryTags[docType].contains(tag);
  }

  bool isTagMandatory(Tag tag) {
    return isTagMandatory(_type, tag);
  }

  bool isAllRequiredTagsSet(){
    Iterable<Tag> tags = mandatoryTags[_type].where((element) => getFieldByTag(tag) != null);
    return mandatoryTags[_type].length == tags.length;
  }

  static Set<Tag> getRequiredTagsForType(FnRecordType type){
    return mandatoryTags[type];
  }

  FnRecord.withType(FnRecordType type) {
    this._type = type;
  }
//
  FnRecord.withBuffer(Uint8List buffer) {
    this(buffer, true);
  }

  FnRecord(Uint8List buffer, bool includeSignature) {
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
            if(offset - HEADER_SIZE >= _length) {
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

// private FnRecord(byte[] buffer, boolean includeSignature) {
// int tailLen = (includeSignature ? SIGNATURE_SIZE : 0);
// if(buffer == null || buffer.length < HEADER_SIZE + tailLen) {
// throw new IllegalArgumentException("Incorrect buffer size");
// }
// this.type = FnRecordType.byCode(ConversionUtil.leToUInt16(buffer, TYPE_OFFSET));
// this.length = ConversionUtil.leToUInt16(buffer, LENGTH_OFFSET);
// int offset = FIELDS_OFFSET;
// if(buffer.length > HEADER_SIZE + tailLen) {
// try {
// Field field = Field.makeFromBuffer(buffer, offset);
// while(field != null) {
// addField(field);
// int fieldSize = field.getSize();
// offset += fieldSize;
// if(offset-HEADER_SIZE >= length) {
// break;
// }
// field = Field.makeFromBuffer(buffer, offset);
// }
// } catch (UnknownTagException e) {
// throw new IllegalArgumentException(e);
// }
// }
// if(offset-HEADER_SIZE != length) {
// throw new IllegalArgumentException("Incorrect input data format");
// }
// if(includeSignature) {
// System.arraycopy(buffer, offset, signature, 0, SIGNATURE_SIZE);
// }
// }
//
// public static FnRecord construct(byte[] buffer) {
// return new FnRecord(buffer, true);
// }
//
// public static FnRecord constructWithoutSignature(byte[] buffer) {
// return new FnRecord(buffer, false);
// }
//
// public FnRecordType getType() {
//   return type;
// }
//
// public int getLength() {
//   return length;
// }
//
// public byte[] getHeaderBuffer() {
//   byte[] result = new byte[HEADER_SIZE];
//   ConversionUtil.uint16ToLe(type.code, result, TYPE_OFFSET);
//   ConversionUtil.uint16ToLe(length, result, LENGTH_OFFSET);
//   return result;
// }
//
// public List<Field> getFields() {
//   return fields;
// }
//
// public <T extends Field> T getFieldByTag(Tag tag) {
//   return STLVField.getFieldByTag(tag, fields);
// }
//
// public List<Field> getFieldsByTag(Tag tag) {
//   List<Field> result = new ArrayList<>();
//   for(Field field : fields) {
//     if(field.getTag() == tag) {
//       result.add(field);
//     }
//   }
//   return result;
// }
//
// public byte[] getSignature() {
//   return signature;
// }
//
// public void setSignature(byte[] signature) {
// setSignature(signature, 0);
// }
//
// public void setSignature(byte[] data, int offset) {
// System.arraycopy(data, offset, this.signature, 0, SIGNATURE_SIZE);
// }
//
// public String getFnNumber() {
//   return fnNumber;
// }
//
// public Long getFdNumber() {
//   return fdNumber;
// }
//
// public byte[] getFiscalMark() {
//   return fiscalMark;
// }
//
// public synchronized FnRecord add(Field field) {
//   addField(field);
//   length += field.getSize();
//   return this;
// }
//
// public byte[] serialize() {
//   return doSerialize(true, true);
// }
//
// public byte[] serializeForSigning() {
//   return doSerialize(false, true);
// }
//
// public byte[] serializeForFiscalMark() {
//   return extractMandatoryFields().doSerialize(false, false);
// }
//
// private byte[] doSerialize(boolean includeSignature, boolean includeLength) {
//   int size = length + HEADER_SIZE;
//   if(!includeLength) {
//     size -= LENGTH_SIZE;
//   }
//   if(includeSignature) {
//     size += SIGNATURE_SIZE;
//   }
//   byte[] result = new byte[size];
//   int offset = FIELDS_OFFSET;
//   ConversionUtil.uint16ToLe(type.code, result, TYPE_OFFSET);
//   if(includeLength) {
//     ConversionUtil.uint16ToLe(length, result, LENGTH_OFFSET);
//   } else {
//     offset -= LENGTH_SIZE;
//   }
//   for(Field field : fields) {
//     System.arraycopy(field.getBuffer(), 0, result, offset, field.getSize());
//     offset += field.getSize();
//   }
//   if(includeSignature) {
//     System.arraycopy(signature, 0, result, offset, SIGNATURE_SIZE);
//   }
//   return result;
// }
//
// private List<byte[]> serializeFields(List<Field> fields) {
//   List<byte[]> result = new ArrayList<>();
//   for(Field field : fields) {
//     if(field instanceof STLVField) {
//       result.addAll(serializeFields(((STLVField)field).getFields()));
//     } else {
//       //TODO
// //                byte[] fieldBuf = new byte[field.getSize()];
// //                System.arraycopy(field.getBuffer(), 0, result, 0, field.getSize());
//     }
//   }
//   return result;
// }
//
// private void addField(Field field) {
//   if(field.getTag() == Tag.FN_SERIAL_NUMBER) {
//     fnNumber = ((TLVField)field).getString();
//   } else if(field.getTag() == Tag.FD_NUMBER) {
//     fdNumber = ((TLVField)field).getUInt32();
//   } else if(field.getTag() == Tag.DOCUMENT_FISCAL_MARK) {
//     fiscalMark = ((TLVField)field).getByteArray();
//   }
//   fields.add(field);
// }
//
// public List<byte[]> serializeFields() {
//   return serializeFields(fields);
// }
//
// public FnRecord extractMandatoryFields () {
//   FnRecord result = new FnRecord(type);
//   for(Field field : getFields()) {
//   if(isTagMandatory(type, field.getTag())) {
//   result.add(field);
//   }
//   }
//   Collections.sort(result.fields, Comparator.comparingInt(field -> field.getTag().getCode()));
//   return result;
// }
//
// public static List<Field> extractFields(byte[] buffer, final int offset, final int size) {
// List<Field> result = new ArrayList<Field>();
// int off = offset;
// try {
// Field field = Field.makeFromBuffer(buffer, off);
// while(field != null) {
// result.add(field);
// int fieldSize = field.getSize();
// off += fieldSize;
// if(off >= offset+size) {
// break;
// }
// field = Field.makeFromBuffer(buffer, off);
// }
// } catch (UnknownTagException e) {
// throw new IllegalArgumentException(e);
// }
// if(off != offset+size) {
// throw new IllegalArgumentException("Incorrect input data");
// }
// return result;
// }
//
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
//
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
// @Override
// public FnRecord clone() {
//   return FnRecord.construct(serialize());
// }
}
