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
  static const Tag TICKET_ELECTRONIC_SUM = Tag(1081, FieldType.VLN);
  static const Tag USER_ATTRIBUTE = Tag(
    1084,
    FieldType.STLV,
    length: 320,
  );
  static const Tag USER_ATTRIBUTE_NAME = Tag(
    1085,
    FieldType.STRING,
    length: 64,
  );
  static const Tag USER_ATTRIBUTE_VALUE = Tag(
    1086,
    FieldType.STRING,
    length: 256,
  );
  static const Tag UNCONFIRMED_FDS_AMOUNT = Tag(1097, FieldType.UINT32);
  static const Tag FIRST_UNCONFIRMED_FD_TIMESTAMP = Tag(
    1098,
    FieldType.UNIXTIME,
  );
  static const Tag REREGISTRATION_REASON_CODE = Tag(1101, FieldType.BYTE);
  static const Tag INTERNET_ONLY_KKT = Tag(1108, FieldType.BYTE);
  static const Tag SERVICES_MARK = Tag(1109, FieldType.BYTE);
  static const Tag AS_BSO_MARK = Tag(1110, FieldType.BYTE);
  static const Tag SHIFT_FDS_AMOUNT = Tag(1111, FieldType.UINT32);
  static const Tag FIRST_UNCONFIRMED_FD_NUMBER = Tag(1116, FieldType.UINT32);
  static const Tag TICKET_SENDER_EMAIL = Tag(
    1117,
    FieldType.STRING,
    length: 64,
  );
  static const Tag SHIFT_TICKETS_AMOUNT = Tag(1118, FieldType.UINT32);
  static const Tag LOTTERY_MARK = Tag(1126, FieldType.BYTE);
  static const Tag OPERATION_INCOME_COUNTERS = Tag(
    1129,
    FieldType.STLV,
    length: 116,
  );
  static const Tag OPERATION_INCOME_RETURN_COUNTERS = Tag(
    1130,
    FieldType.STLV,
    length: 116,
  );
  static const Tag OPERATION_EXPENDITURE_COUNTERS = Tag(
    1131,
    FieldType.STLV,
    length: 116,
  );
  static const Tag OPERATION_EXPENDITURE_RETURN_COUNTERS = Tag(
    1132,
    FieldType.STLV,
    length: 116,
  );
  static const Tag CORRECTION_TICKETS_COUNTERS = Tag(
    1133,
    FieldType.STLV,
    length: 216,
  );
  static const Tag TOTAL_TICKETS_AMOUNT = Tag(1134, FieldType.UINT32);
  static const Tag OPERATION_TICKETS_AMOUNT = Tag(1135, FieldType.UINT32);
  static const Tag OPERATION_CASH_SUM = Tag(1136, FieldType.VLN);
  static const Tag OPERATION_ELECTRONIC_SUM = Tag(1138, FieldType.VLN);
  static const Tag CORRECTION_TICKETS_AMOUNT = Tag(1144, FieldType.UINT32);
  static const Tag CORRECTION_INCOME_COUNTERS = Tag(
    1145,
    FieldType.STLV,
    length: 144,
  );
  static const Tag CORRECTION_EXPENDITURE_COUNTERS = Tag(
    1146,
    FieldType.STLV,
    length: 144,
  );
  static const Tag CORRECTION_SELF_AMOUNT = Tag(1148, FieldType.UINT32);
  static const Tag CORRECTION_FORCED_AMOUNT = Tag(1149, FieldType.UINT32);
  static const Tag FN_SUMMARY_COUNTERS = Tag(
    1157,
    FieldType.STLV,
    length: 708,
  );
  static const Tag UNCONFIRMED_SUMMARY_COUNTERS = Tag(
    1158,
    FieldType.STLV,
    length: 708,
  );
  static const GOOD_NOMENCLATURE_CODE = Tag(
    1162,
    FieldType.BYTEARRAY,
    length: 32,
  );
  static const SUPPLIER_PHONE = Tag(
    1171,
    FieldType.STRING,
    length: 19,
  );
  static const CORRECTION_TYPE = Tag(
    1173,
    FieldType.BYTE,
  );
  static const CORRECTION_REASON = Tag(
    1174,
    FieldType.STLV,
    length: 292,
  );
  static const CORRECTION_REASON_DESCRIPTION = Tag(
    1177,
    FieldType.STRING,
    length: 256,
  );
  static const CORRECTION_REASON_DATE = Tag(1178, FieldType.UNIXTIME);
  static const CORRECTION_REASON_NUMBER = Tag(
    1179,
    FieldType.STRING,
    length: 32,
  );
  static const PURCHASE_PLACE = Tag(1187, FieldType.STRING, length: 256);
  static const KKT_VERSION = Tag(1188, FieldType.STRING, length: 8);
  static const KKT_DATA_FORMAT_VERSION = Tag(1189, FieldType.BYTE);
  static const FN_DATA_FORMAT_VERSION = Tag(1190, FieldType.BYTE);
  static const GOOD_ATTRIBUTE = Tag(1191, FieldType.STRING, length: 64);
  static const TICKET_ATTRIBUTE = Tag(1192, FieldType.STRING, length: 16);
  static const GAMBLE_MARK = Tag(1193, FieldType.BYTE);
  static const SHIFT_SUMMARY_COUNTERS = Tag(1194, FieldType.STLV, length: 708);
  static const QR_CODE = Tag(1196, FieldType.STRING);
  static const GOOD_MEASURE = Tag(1197, FieldType.STRING, length: 16);
  static const OPERATION_TOTAL_SUM = Tag(1201, FieldType.VLN);
  static const CASHIER_INN = Tag(
    1203,
    FieldType.STRING,
    length: 12,
    fixedLength: false,
  );
  static const REREGISTRATION_REASON_CODES = Tag(
    1205,
    FieldType.BITMASK,
    length: 4,
    fixedLength: true,
  );
  static const OPERATOR_MESSAGE = Tag(
    1206,
    FieldType.BYTE,
    length: 1,
    fixedLength: true,
  );
  static const EXCISE_MARK = Tag(1207, FieldType.BYTE);
  static const TICKET_SITE = Tag(1208, FieldType.STRING, length: 256);
  static const DATA_FORMAT_VERSION = Tag(1209, FieldType.BYTE);
  static const OPERATOR_MESSAGE_TEXT = Tag(1210, FieldType.STRING, length: 256);
  static const GOOD_TYPE = Tag(1212, FieldType.BYTE);
  static const KEYS_DAYS_LEFT = Tag(1213, FieldType.UINT16);
  static const PAYMENT_TYPE = Tag(1214, FieldType.BYTE);
  static const TICKET_PREPAYMENT_SUM = Tag(1215, FieldType.VLN);
  static const TICKET_POSTPAYMENT_SUM = Tag(1216, FieldType.VLN);
  static const TICKET_BARTER_SUM = Tag(1217, FieldType.VLN);
  static const OPERATION_PREPAYMENT_SUM = Tag(1218, FieldType.VLN);
  static const OPERATION_POSTPAYMENT_SUM = Tag(1219, FieldType.VLN);
  static const OPERATION_BARTER_SUM = Tag(1220, FieldType.VLN);
  static const AUTOMATIC_PRINTER_MARK = Tag(1221, FieldType.BYTE);
  static const GOOD_AGENT_TYPE = Tag(
    1222,
    FieldType.BITMASK,
    length: 1,
    fixedLength: true,
  );
  static const AGENT_DATA = Tag(1223, FieldType.STLV, length: 512);
  static const SUPPLIER_DATA = Tag(1224, FieldType.STLV, length: 512);
  static const SUPPLIER_NAME = Tag(1225, FieldType.STRING, length: 256);
  static const SUPPLIER_INN = Tag(
    1226,
    FieldType.STRING,
    length: 12,
    fixedLength: false,
  );
  static const CUSTOMER = Tag(1227, FieldType.STRING, length: 256);
  static const CUSTOMER_INN = Tag(
    1228,
    FieldType.STRING,
    length: 12,
    fixedLength: false,
  );
  static const EXCISE = Tag(1229, FieldType.VLN);
  static const COUNTRY_CODE = Tag(
    1230,
    FieldType.STRING,
    length: 3,
    fixedLength: false,
  );
  static const CUSTOMS_DECLARATION_NUMBER = Tag(
    1231,
    FieldType.STRING,
    length: 32,
  );
  static const CORRECTION_INCOME_RETURN_COUNTERS = Tag(
    1232,
    FieldType.STLV,
    length: 144,
  );
  static const CORRECTION_EXPENDITURE_RETURN_COUNTERS = Tag(
    1233,
    FieldType.STLV,
    length: 144,
  );
}
