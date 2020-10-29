import 'dart:ffi';
import 'dart:typed_data';

class MessageHeaderFlags {
  ClientFeature _clientFeature;
  ContentType _contentType;
  CRCMode _crcMode;
  int _priority;

  MessageHeaderFlags({Uint8List data}) {
    if (data == null) {
      _clientFeature = ClientFeature.NEED_ANSWER;
      _contentType = ContentType.CONTAINER;
      _crcMode = CRCMode.BY_HEADER_ONLY;
    } else {
      if ((data[0] & 0x20) != 0) {
        _clientFeature = ClientFeature.UNDEFINED_FEATURE;
      } else if ((data[0] & 0x10) != 0) {
        _clientFeature = ClientFeature.NEED_ANSWER;
      } else {
        _clientFeature = ClientFeature.NOT_NEED_ANSWER;
      }

      if ((data[0] & 0x04) != 0) {
        _contentType = ContentType.CONTAINER;
      } else {
        _contentType = ContentType.NO_CONTAINER;
      }

      if ((data[0] & 0x01) != 0 && (data[0] & 0x02) != 0) {
        _crcMode = CRCMode.UNDEFINED_MODE;
      } else if((data[0] & 0x02) != 0) {
        _crcMode = CRCMode.BY_HEADER_AND_BODY;
      } else if((data[0] & 0x01) != 0) {
        _crcMode = CRCMode.BY_HEADER_ONLY;
      } else {
        _crcMode = CRCMode.NO_CRC;
      }
      _priority = (data[0] >> 6);
    }
  }

  Uint8List serialize() {
    int flags = 0;
    switch (_clientFeature) {
      case ClientFeature.UNDEFINED_FEATURE: flags |= 0x20; break;
      case ClientFeature.NEED_ANSWER: flags |= 0x10; break;
    }
    if (_contentType == ContentType.CONTAINER) {
      flags |= 0x04;
    }
    switch (_crcMode) {
      case CRCMode.UNDEFINED_MODE: flags |= 0x03; break;
      case CRCMode.BY_HEADER_AND_BODY: flags |= 0x02; break;
      case CRCMode.BY_HEADER_ONLY: flags |= 0x01; break;
      default: // NO_CRC case not handled by original Java implementation
        flags |= 0x03;
    }
    flags |= (_priority << 6);
    return Uint8List.fromList([flags, 0]);
  }

  int get priority => _priority;

  ClientFeature get clientFeature => _clientFeature;

  ContentType get contentType => _contentType;

  CRCMode get crcMode => _crcMode;

  setClientFeature(ClientFeature clientFeature) {
    _clientFeature = clientFeature;
  }

  setContentType(ContentType contentType) {
    _contentType = contentType;
  }

  setCrcMode(CRCMode crcMode) {
    _crcMode = crcMode;
  }

  setPriority(int priority) {
    _priority = priority;
  }
}

class ClientFeature {
  const ClientFeature(this.code) : super();

  final int code;

  static const ClientFeature NOT_NEED_ANSWER = ClientFeature(2);
  static const ClientFeature NEED_ANSWER = ClientFeature(1);
  static const ClientFeature UNDEFINED_FEATURE = ClientFeature(0);

  static List<ClientFeature> values = [
    NOT_NEED_ANSWER,
    NEED_ANSWER,
    UNDEFINED_FEATURE,
  ];

  static ClientFeature byCode(int code) {
    return values.firstWhere((element) => element.code == code);
  }
}

enum ContentType {
  NO_CONTAINER,
  CONTAINER,
}

enum CRCMode {
  NO_CRC,
  BY_HEADER_ONLY,
  BY_HEADER_AND_BODY,
  UNDEFINED_MODE,
}
