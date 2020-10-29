import 'dart:typed_data';

import 'package:local_fiscal_service/utils/conversion_util.dart';

class MessageHeader {
  static const int HEADER_SIGNATURE_OFFSET = 0;
  static const int APPCODE_OFFSET = 4;
  static const int PROTOCOL_VERSION_OFFSET = 6;
  static const int FN_NUMBER_OFFSET = 8;
  static const int BODY_SIZE_OFFSET = 24;
  static const int FLAGS_OFFSET = 26;
  static const int CRC_OFFSET = 28;

  static const int FN_NUMBER_SIZE = 16;
  static const int MESSAGE_HEADER_SIZE = 30;

  // ignore: non_constant_identifier_names
  static Uint8List HEADER_SIGNATURE = Uint8List.fromList([0x2A, 0x08, 0x41, 0x0A]);
  // ignore: non_constant_identifier_names
  static Uint8List APPLICATION_CODE =  Uint8List.fromList([0x81, 0xA2]);
  // ignore: non_constant_identifier_names
  static Uint8List PROTOCOL_VERSION =  Uint8List.fromList([0x01, 0x10]);

  Uint8List _headerSignature;
  Uint8List _appCode;
  Uint8List _protocolVersion;
  String _fnNumber;
  int _bodySize;
  MessageHeaderFlags _flags;
  int _crc;
}