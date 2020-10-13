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
  static const Tag SHIFT_NUMBER = Tag(1038, FieldType.UINT32);
  static const Tag FD_NUMBER = Tag(1040, FieldType.UINT32);
  static const Tag FN_SERIAL_NUMBER = Tag(
    1041,
    FieldType.STRING,
    length: 16,
    fixedLength: true,
  );
  static const Tag TICKET_NUMBER = Tag(1042, FieldType.UINT32);
  static const Tag GOOD_COST = Tag(1043, FieldType.VLN);
  static const Tag PAYING_AGENT_OPERATION = Tag(
    1044,
    FieldType.STRING,
    length: 24,
  );
  static const Tag OFD_NAME = Tag(
    1046,
    FieldType.STRING,
    length: 256,
  );
  static const Tag USER_NAME = Tag(
    1048,
    FieldType.STRING,
    length: 256,
  );
  static const Tag FN_EXPIRING = Tag(1050, FieldType.BYTE);
  static const Tag FN_NEED_CHANGE = Tag(1051, FieldType.BYTE);
  static const Tag FN_FULL = Tag(1052, FieldType.BYTE);
  static const Tag OFD_NOT_RESPONDING = Tag(1053, FieldType.BYTE);
  static const Tag OPERATION_TYPE = Tag(1054, FieldType.BYTE);
  static const Tag TAX_SYSTEM = Tag(
    1055,
    FieldType.BITMASK,
    length: 1,
    fixedLength: true,
  );
  static const Tag CIPHER_MARK = Tag(1056, FieldType.BYTE);
  static const Tag AGENT_MARK = Tag(
    1057,
    FieldType.BITMASK,
    length: 1,
    fixedLength: true,
  );
  static const Tag GOOD = Tag(1059, FieldType.STLV, length: 1024);
  static const Tag FNS_SITE_ADDRESS = Tag(1060, FieldType.STRING, length: 256);
  static const Tag TAX_SYSTEMS_AVAILABLE = Tag(1062, FieldType.BITMASK);
  static const Tag OPERATOR_MESSAGE_FOR_FN = Tag(
    1068,
    FieldType.STLV,
    length: 9,
  );
  static const Tag PAYING_AGENT_PHONE = Tag(
    1073,
    FieldType.STRING,
    length: 19,
  );
  static const Tag PAYMENT_OPERATOR_PHONE = Tag(
    1074,
    FieldType.STRING,
    length: 19,
  );
  static const Tag TRANSFER_OPERATOR_PHONE = Tag(
    1075,
    FieldType.STRING,
    length: 19,
  );
  static const Tag DOCUMENT_FISCAL_MARK = Tag(
    1077,
    FieldType.BYTEARRAY,
    length: 6,
    fixedLength: true,
  );
  static const Tag OPERATOR_FISCAL_MARK = Tag(
    1078,
    FieldType.BYTEARRAY,
    length: 16,
  );
  static const Tag GOOD_PRICE = Tag(1079, FieldType.VLN);
