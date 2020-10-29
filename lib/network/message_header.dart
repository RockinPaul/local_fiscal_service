import 'dart:typed_data';

import 'package:local_fiscal_service/utils/conversion_util.dart';
import 'package:local_fiscal_service/utils/string_extension.dart';
import 'package:local_fiscal_service/network/message_header_flags.dart';

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

  MessageHeader(Uint8List data) {
    if (data == null) {
      List.copyRange(_headerSignature, 0, HEADER_SIGNATURE, 0, HEADER_SIGNATURE.length);
      List.copyRange(_appCode, 0, APPLICATION_CODE, 0, APPLICATION_CODE.length);
      List.copyRange(_protocolVersion, 0, PROTOCOL_VERSION, PROTOCOL_VERSION.length);
      _flags = MessageHeaderFlags();
    } else {
      if (data.length < MESSAGE_HEADER_SIZE) {
        throw Exception('Data buffer if too small');
      }
      List.copyRange(_headerSignature, 0, data, HEADER_SIGNATURE_OFFSET, APPCODE_OFFSET);
      if(HEADER_SIGNATURE != _headerSignature) {
        throw Exception('Invalid header signature');
      }
      List.copyRange(_appCode, 0, data, APPCODE_OFFSET, PROTOCOL_VERSION_OFFSET);
      if (APPLICATION_CODE != _appCode) {
        throw Exception('Invalid application code');
      }
      List.copyRange(_protocolVersion, 0, data, PROTOCOL_VERSION_OFFSET, FN_NUMBER_OFFSET);
      if(PROTOCOL_VERSION != _protocolVersion) {
        throw Exception('Invalid protocol version');
      }
      Uint8List fnNumberBytes = Uint8List(0);
      List.copyRange(fnNumberBytes, 0, data, FN_NUMBER_OFFSET, BODY_SIZE_OFFSET);
      _fnNumber = fnNumberBytes.toString();
      Uint8List bodySizeBytes = Uint8List(0);
      List.copyRange(bodySizeBytes, 0, data, BODY_SIZE_OFFSET, FLAGS_OFFSET);
      _bodySize = ConversionUtil.leToUInt16(bodySizeBytes);
      Uint8List flagsBytes = Uint8List(0);
      List.copyRange(flagsBytes, 0, data, FLAGS_OFFSET, CRC_OFFSET);
      setFlags(MessageHeaderFlags(data: flagsBytes));
      Uint8List crcBytes = Uint8List(0);
      List.copyRange(crcBytes, 0, data, CRC_OFFSET, MESSAGE_HEADER_SIZE);
      _crc = ConversionUtil.leToUInt16(crcBytes);
    }
  }

  Uint8List serialize({Uint8List result, int offset = 0}) {
    if (result == null || result.isEmpty) {
      result = Uint8List(MESSAGE_HEADER_SIZE);
    }
    int pos = offset;
    List.copyRange(result, 0, headerSignature, pos, headerSignature.length);
    pos += headerSignature.length;
    List.copyRange(result, 0, appCode, pos, appCode.length);
    pos += protocolVersion.length;
    List.copyRange(result, 0, protocolVersion, pos, protocolVersion.length);
    pos += protocolVersion.length;
    List.copyRange(result, 0, fnNumber.toBytes(), pos, fnNumber.length);
    pos += fnNumber.length;
    List.copyRange(result, 0, ConversionUtil.uint16ToLe(bodySize), pos, 2);
    pos += 2;
    List.copyRange(result, 0, flags.serialize(), pos, 2);
    pos += 2;
    List.copyRange(result, 0, ConversionUtil.uint16ToLe(crc), pos, 2);

    return result;
  }

  Uint8List get headerSignature => _headerSignature;

  Uint8List get appCode => _appCode;

  Uint8List get protocolVersion => _protocolVersion;

  String get fnNumber => _fnNumber;

  int get bodySize => _bodySize;

  MessageHeaderFlags get flags => _flags;

  int get crc => _crc;

  setFnNumber(String fnNumber) {
    if (_fnNumber.length > FN_NUMBER_SIZE) {
      throw Exception('Fiscal driver number size must be 16');
    } else if (_fnNumber.length < FN_NUMBER_SIZE) {
      _fnNumber = fnNumber + String.fromCharCode(16 - fnNumber.length).replaceAll('\0', ' ');
    }
    else {
      _fnNumber = fnNumber;
    }
  }

  setBodySize(int bodySize) {
    _bodySize = bodySize;
  }

  setFlags(MessageHeaderFlags flags) {
    if (flags.clientFeature == ClientFeature.UNDEFINED_FEATURE) {
      throw Exception('Invalid client feature flags');
    }
    if (flags.crcMode == CRCMode.UNDEFINED_MODE ||
        flags.crcMode == CRCMode.NO_CRC && crc != 0) {
      throw Exception('Invalid CRC mode');
    }
    _flags = flags;
  }

  setCrc(int crc) {
    _crc = crc;
  }

  static int get size => MESSAGE_HEADER_SIZE;

  int get messageSize => MESSAGE_HEADER_SIZE + bodySize;
}