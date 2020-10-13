class Tuple {
  final int maxLength;
  final bool fixedLength;

  const Tuple({this.maxLength = 0, this.fixedLength = false});
}

class FieldType {
  const FieldType(this.value) : super();

  final Tuple value;

  static const FieldType BYTE = FieldType(Tuple(maxLength: 1, fixedLength: true));
  static const FieldType UINT16 = FieldType(Tuple(maxLength: 2, fixedLength: true));
  static const FieldType UINT32 = FieldType(Tuple(maxLength: 4, fixedLength: true));
  static const FieldType BITMASK = FieldType(Tuple());
  static const FieldType VLN = FieldType(Tuple(maxLength: 6, fixedLength: false));
  static const FieldType FVLN = FieldType(Tuple(maxLength: 8, fixedLength: false));
  static const FieldType UNIXTIME = FieldType(Tuple(maxLength: 4, fixedLength: true));
  static const FieldType STRING = FieldType(Tuple());
  static const FieldType BYTEARRAY = FieldType(Tuple());
  static const FieldType STLV = FieldType(Tuple());

  int getMaxLength() {
    return value.maxLength;
  }

  bool isFixedLength() {
    return value.fixedLength;
  }
}

// BYTE(1, true),
// UINT16(2, true),
// UINT32(4, true),
// BITMASK,
// VLN(6, false),
// FVLN(8, false),
// UNIXTIME(4, true),
// STRING,
// BYTEARRAY,
// STLV;