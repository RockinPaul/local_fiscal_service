class FnRecordType {
  const FnRecordType(this.code) : super();

  final int code;

  static const FnRecordType REGISTRATION_REPORT = FnRecordType(1);
  static const FnRecordType REGISTRATION_CHANGE_REPORT = FnRecordType(11);
  static const FnRecordType OPEN_SHIFT_REPORT = FnRecordType(2);
  static const FnRecordType CURRENT_STATE_REPORT = FnRecordType(21);
  static const FnRecordType TICKET = FnRecordType(3);
  static const FnRecordType CORRECTION_TICKET = FnRecordType(31);
  static const FnRecordType ACC_FORM = FnRecordType(4);
  static const FnRecordType CORRECTION_ACC_FORM = FnRecordType(41);
  static const FnRecordType CLOSE_SHIFT_REPORT = FnRecordType(5);
  static const FnRecordType CLOSE_FN_REPORT = FnRecordType(6);
  static const FnRecordType OPERATOR_ACK = FnRecordType(7);

  static List<FnRecordType> values = [
    REGISTRATION_REPORT,
    REGISTRATION_CHANGE_REPORT,
    OPEN_SHIFT_REPORT,
    CURRENT_STATE_REPORT,
    TICKET,
    CORRECTION_TICKET,
    ACC_FORM,
    CORRECTION_ACC_FORM,
    CLOSE_SHIFT_REPORT,
    CLOSE_FN_REPORT,
    OPERATOR_ACK,
  ];

  static FnRecordType byCode(int code) {
    return values.firstWhere((element) => element.code == code);
  }
}

// REGISTRATION_REPORT(1),
// REGISTRATION_CHANGE_REPORT(11),
// OPEN_SHIFT_REPORT(2),
// CURRENT_STATE_REPORT(21),
// TICKET(3),
// CORRECTION_TICKET(31),
// ACC_FORM(4),
// CORRECTION_ACC_FORM(41),
// CLOSE_SHIFT_REPORT(5),
// CLOSE_FN_REPORT(6),
// OPERATOR_ACK(7);
