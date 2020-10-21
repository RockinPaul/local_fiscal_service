class FieldTuple {
  final int maxLength;
  final bool fixedLength;

  const FieldTuple({this.maxLength = 0, this.fixedLength = false});
}

class FieldType {
  const FieldType(this.value) : super();

  final FieldTuple value;

  static const FieldType BYTE = FieldType(FieldTuple(maxLength: 1, fixedLength: true));
  static const FieldType UINT16 = FieldType(FieldTuple(maxLength: 2, fixedLength: true));
  static const FieldType UINT32 = FieldType(FieldTuple(maxLength: 4, fixedLength: true));
  static const FieldType BITMASK = FieldType(FieldTuple());
  static const FieldType VLN = FieldType(FieldTuple(maxLength: 6, fixedLength: false));
  static const FieldType FVLN = FieldType(FieldTuple(maxLength: 8, fixedLength: false));
  static const FieldType UNIXTIME = FieldType(FieldTuple(maxLength: 4, fixedLength: true));
  static const FieldType STRING = FieldType(FieldTuple());
  static const FieldType BYTEARRAY = FieldType(FieldTuple());
  static const FieldType STLV = FieldType(FieldTuple());

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