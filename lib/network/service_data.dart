import 'dart:typed_data';

class ServiceData {
  static const int _SERVICE_DATA_SIZE = 1;
  bool _dataEncrypted;


  ServiceData({Uint8List data, int offset}) {
    if (data.length - offset < _SERVICE_DATA_SIZE) {
      throw Exception('Invalid buffer length for service data.');
    }
    _dataEncrypted = (data[offset] & 0x01) != 0;
  }

  bool isDataEncrypted() => _dataEncrypted;

  setDataEncrypted(bool dataEncrypted) {
    _dataEncrypted = dataEncrypted;
  }

  static int getSize() => _SERVICE_DATA_SIZE;

  serialize(Uint8List data, int offset) {
    if (data.length-offset < _SERVICE_DATA_SIZE) {
      throw Exception('Invalid buffer length for service data.');
    }
    if (_dataEncrypted) {
      data[offset] |= 0x01;
    }
  }
}