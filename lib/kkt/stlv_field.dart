import 'dart:typed_data';

import 'package:local_fiscal_service/kkt/field.dart';
import 'package:local_fiscal_service/kkt/field_type.dart';
import 'package:local_fiscal_service/kkt/tag.dart';
import 'package:local_fiscal_service/kkt/vat_rate.dart';
import 'package:local_fiscal_service/kkt/st_rate.dart';
import 'package:local_fiscal_service/kkt/tlv_field.dart';

class STLVField extends Field {

  List<Field> fields;

  STLVField({Tag tag}) : super(tag: tag, length: tag.length) {
    fields = new List<Field>();
  }

  static STLVField make(Tag tag) {
    return STLVField(tag: tag);
  }

  static STLVField makeFromBuffer(Uint8List buffer, {int offset = 0, int length = 0}) {
    if (offset != null && length != null) {
      List.copyRange(buffer, 0, buffer, offset, offset + length);
      makeFromBuffer(buffer);
    }
    if (buffer == null || buffer.length < Field.HEADER_SIZE) {
      return null;
    }
    STLVField result = STLVField();
    result.setBuffer(buffer);
    if (result.buffer == null) {
      return null;
    }
    return result;
  }

  @override
  Uint8List get buffer {
    if (fields == null) {
      return buffer;
    }
    Uint8List result = new Uint8List(size);
    List.copyRange(result, 0, buffer, 0, 4);
    int offset = Field.DATA_OFFSET;
    for(Field field in fields) {
      int len = field.size;
      List.copyRange(field.buffer, 0, result, offset, len);
      offset += len;
    }
    return result;
  }

  STLVField add(Field field) {
    fields.add(field);
    setLength(length + field.length + Field.HEADER_SIZE);
    return this;
  }

  //Tax utility methods
  static STLVField makeWithVAT(VATRate rate, {int value = 0}) {
    return STLVField.make(Tag.VAT_SUMMARY)
        .add(TLVField.makeByte(Tag.VAT_RATE, rate.code))
        .add(TLVField.makeVLN(Tag.VAT_SUM, value));
  }

  static STLVField makeWithST(STRate rate, {int value = 0}) {
    return STLVField.make(Tag.VAT_SUMMARY)
        .add(TLVField.makeByte(Tag.VAT_RATE, rate.code))
        .add(TLVField.makeVLN(Tag.VAT_SUM, value));
  }

  List<Field> getFields() {
    if (fields != null) {
      return fields;
    } else {
      try {
        List<Field> result = List<Field>();
        int offset = Field.DATA_OFFSET;
        Field field;
        do {
          field = makeFromBuffer(buffer, offset: offset);
          result.add(field);
          offset = offset + field.size;
        } while (offset != buffer.length);
        return result;
      } catch (e) {
        throw Exception("Lazy deserialization exception : $e");
      }
    }
  }
//
//   /**
//    * Use {@link STLVField#getFields()} and {@link STLVField#getFieldByTag(Tag, List)}
//    **/
//   @Deprecated
//   public <T extends Field> T getFieldByTag(Tag tag) {
//     return getFieldByTag(tag, getFields());
//   }
//
//   public static <T extends Field> T getFieldByTag(Tag tag, List<Field> fields) {
//     for(Field field : fields) {
//       if(field.getTag() == tag) {
//         return (T)field;
//       }
//     }
//     return null;
//   }
//
//   @Override
//   public boolean equals(Object o) {
//     if(this == o)
//       return true;
//     if(o == null || getClass() != o.getClass())
//       return false;
//     return Objects.deepEquals(getBuffer(), ((STLVField) o).getBuffer());
//   }
//
//   @Override
//   public int hashCode() {
//     int result = super.hashCode();
//     result = 31 * result + Arrays.hashCode(getBuffer());
//     return result;
//   }
//
//   @Override
//   public String toString() {
//     StringBuffer sb = new StringBuffer();
//     Tag tag = getTag();
//     sb.append(tag).append("(").append(tag.getCode()).append(")[").append(getLength()).append("]: {\n");
//     for(Field field : getFields()) {
//     String fieldStr = field.toString();
//     if(field.getTag().getType() == FieldType.STLV) {
//     fieldStr = fieldStr.replace("\n", "\n  ");
//     }
//     sb.append("  ").append(fieldStr).append(",\n");
//     }
//     sb.append("}");
//     return sb.toString();
//   }
}