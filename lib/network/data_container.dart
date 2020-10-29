import 'dart:typed_data';

import 'package:local_fiscal_service/kkt/fn_record.dart';
import 'package:local_fiscal_service/kkt/fn_record_type.dart';
import 'package:local_fiscal_service/utils/conversion_util.dart';
import 'package:local_fiscal_service/utils/CRC16CCITT.dart';
import 'package:local_fiscal_service/network/service_data.dart';
import 'package:local_fiscal_service/network/container_type.dart';

class DataContainer {
  static const int BODY_LENGTH_OFFSET = 0;
  static const int CRC_OFFSET = 2;
  static const int CONTAINER_TYPE_OFFSET = 4;
  static const int DOCUMENT_TYPE_OFFSET = 5;
  static const int CONTAINER_VERSION_OFFSET = 6;
  static const int SERVICE_DATA_OFFSET = 7;

  static const int MAX_BODY_SIZE = 0x7FFF;

  static const int VERSION = 0x01;

  int crc;
  ContainerType containerType;
  FnRecordType documentType;
  int containerVersion;
  ServiceData serviceData;
  Uint8List body;
}