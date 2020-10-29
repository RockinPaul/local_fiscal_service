import 'dart:ffi';
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

  int _crc;
  ContainerType _containerType;
  FnRecordType _documentType;
  int _containerVersion;
  ServiceData _serviceData;
  Uint8List _body;

  DataContainer({ContainerType type, Uint8List data, int offset = 0}) {
    if (type != null) {
      _containerType = type;
      _containerVersion = VERSION;
      _serviceData = ServiceData();
    } else {
      if (data.length - offset < headerSize) {
        throw Exception('Data buffer if too small');
      }
      int bodySize = ConversionUtil.leToUInt16(
        data,
        offset: offset + BODY_LENGTH_OFFSET,
      );
      if (bodySize != data.length - offset - headerSize) {
        throw Exception('Invalid message size');
      }
      _crc = ConversionUtil.leToUInt16(data, offset: offset + CRC_OFFSET);
      _containerType =
          ContainerType.byCode(data[offset + CONTAINER_TYPE_OFFSET]);
      _documentType = FnRecordType.byCode(data[offset + DOCUMENT_TYPE_OFFSET]);
      _containerVersion = data[offset + CONTAINER_VERSION_OFFSET];
      if (_containerVersion != VERSION) {
        throw Exception('Invalid container version.');
      }
      _serviceData = new ServiceData(
        data: data,
        offset: offset + SERVICE_DATA_OFFSET,
      );
      List.copyRange(
          _body,
          0,
          data,
          offset + SERVICE_DATA_OFFSET + _serviceData.size,
          offset + SERVICE_DATA_OFFSET + _serviceData.size + bodySize);
    }
  }

  int get bodySize => _body != null ? _body.length : 0;

  setBodySize(int bodySize) {
    _body = Uint8List(bodySize);
  }

  setCrc(int crc) {
    _crc = crc;
  }

  ContainerType get containerType => _containerType;

  setContainerType(ContainerType containerType) {
    _containerType = containerType;
  }

  FnRecordType get documentType => _documentType;

  setDocumentType(FnRecordType documentType) {
    _documentType = documentType;
  }

  Uint8List get containerVersion => this.containerVersion;

  setContainerVersion(int containerVersion) {
    _containerVersion = containerVersion;
  }

  ServiceData get serviceData => this.serviceData;

  setServiceData(ServiceData serviceData) {
    _serviceData = serviceData;
  }

  Uint8List get body => _body;

  setBody(Uint8List body) {
    _body = body;
  }

  static int get headerSize => SERVICE_DATA_OFFSET + ServiceData.getSize();

  int get size => headerSize + bodySize;

  Uint8List serialize({Uint8List data, int offset = 0}) {
    if (data == null || data.isEmpty) {
      data = Uint8List(size);
    }
    if (data.length - offset < size) {
      throw Exception('Insufficient buffer size.');
    }
    ConversionUtil.uint16ToLe(body.length, bytes: data, offset: offset + BODY_LENGTH_OFFSET,);
    ConversionUtil.uint16ToLe(crc, bytes: data, offset: offset+CRC_OFFSET,);
    data[offset + CONTAINER_TYPE_OFFSET] = containerType.code;
    data[offset + DOCUMENT_TYPE_OFFSET] = documentType.code;
    data[offset + CONTAINER_VERSION_OFFSET] = VERSION;
    serviceData.serialize(data, offset + SERVICE_DATA_OFFSET);
    List.copyRange(data, offset + headerSize, body, 0, body.length);
    return data;
  }

  void finish() {
    Uint8List data = serialize();
    CRC16CCITT crc = new CRC16CCITT();
    for(int i = 0; i < data.length; i++) {
      if (i == CRC_OFFSET || i == CRC_OFFSET + 1) {
        continue; //skip crc field
      }
      crc.update(data[i]);
    }
    this.crc = crc.getValue();
  }
}
