import 'package:local_fiscal_service/kkt/field_type.dart';

class Tag {
  final int code;
  final FieldType type;
  final int length;
  final bool fixedLength;
  static Map<int, Tag> codeMap = Map<int, Tag>();

  const Tag(this.code, this.type, {this.length, this.fixedLength});

  static const Tag FD_NAME = Tag(1000, FieldType.STRING);
  static const Tag AUTOMATIC_MODE = Tag(1001, FieldType.BYTE);
  static const Tag AUTONOMOUS_MODE = Tag(1002, FieldType.BYTE);
  static const Tag TICKET_TAX_SUMMARY = Tag(
    1003,
    FieldType.STLV,
    length: 114,
  );
  static const Tag TRANSFER_OPERATOR_ADDRESS = Tag(
    1005,
    FieldType.STRING,
    length: 256,
  );
  static const Tag VAT_SUMMARY = Tag(
    1006,
    FieldType.STLV,
    length: 15,
  );
  static const Tag ST_SUMMARY = Tag(
    1007,
    FieldType.STLV,
    length: 15,
  );
  static const Tag CUSTOMER_CONTACTS = Tag(
    1008,
    FieldType.STRING,
    length: 64,
  );
  static const Tag PURCHASE_ADDRESS = Tag(
    1009,
    FieldType.STRING,
    length: 256,
  );
  static const Tag VAT_RATE = Tag(1010, FieldType.BYTE);
  static const Tag VAT_SUM = Tag(1011, FieldType.VLN);
  static const Tag DATE_TIME = Tag(1012, FieldType.UNIXTIME);
  static const Tag KKT_NUMBER = Tag(1013, FieldType.STRING, length: 20);
  static const Tag ST_RATE = Tag(1014, FieldType.BYTE);
  static const Tag ST_SUM = Tag(1015, FieldType.VLN);
  static const Tag TRANSFER_OPERATOR_INN = Tag(
    1016,
    FieldType.STRING,
    length: 12,
    fixedLength: false,
  );
  static const Tag OFD_INN = Tag(
    1017,
    FieldType.STRING,
    length: 12,
    fixedLength: false,
  );
  static const Tag USER_INN = Tag(
    1018,
    FieldType.STRING,
    length: 12,
    fixedLength: false,
  );
  static const Tag TICKET_TOTAL_SUM = Tag(1020, FieldType.VLN);
  static const Tag CASHIER = Tag(1021, FieldType.STRING, length: 64);
  static const Tag OFD_RESPONSE_CODE = Tag(1022, FieldType.BYTE);
  static const Tag GOOD_QUANTITY = Tag(1023, FieldType.FVLN);
  static const Tag OPERATION_TAX_SUMMARY = Tag(
    1024,
    FieldType.STLV,
    length: 114,
  );
  static const Tag CORRECTION_TAX_SUMMARY = Tag(
    1025,
    FieldType.STLV,
    length: 114,
  );
  static const Tag TRANSFER_OPERATOR_NAME = Tag(
    1026,
    FieldType.STRING,
    length: 64,
  );
  static const Tag GOOD_NAME = Tag(1030, FieldType.STRING, length: 128);
  static const Tag TICKET_CASH_SUM = Tag(1031, FieldType.VLN);
  static const Tag TRANSACTION_MACHINE_NUMBER = Tag(
    1036,
    FieldType.STRING,
    length: 20,
  );
  static const Tag KKT_REGISTER_NUMBER = Tag(
    1037,
    FieldType.STRING,
    length: 16,
    fixedLength: true,
  );
}
