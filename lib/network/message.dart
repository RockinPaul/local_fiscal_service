import 'dart:typed_data';

import 'package:local_fiscal_service/network/message_header.dart';
import 'package:local_fiscal_service/network/data_container.dart';

class Message {
  MessageHeader _header;
  DataContainer _container;

  Message({Uint8List data, MessageHeader header, DataContainer container}) {
    if (data != null && data.isNotEmpty) {
      _header = MessageHeader(data: data);
      _container = DataContainer(data: data, offset: MessageHeader.size);
    } else if (header != null && container != null) {
      _header = header;
      _container = container;
    } else {
      _header = MessageHeader();
      _container = DataContainer();
    }
  }

  Uint8List serialize() {
    Uint8List result = Uint8List(MessageHeader.size + container.size);
    header.serialize(result: result, offset: 0);
    container.serialize(data: result, offset: MessageHeader.size);
    return result;
  }

  MessageHeader get header => _header;

  DataContainer get container => _container;
}
