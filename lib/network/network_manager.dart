import 'dart:io';
import 'dart:typed_data';
import 'package:local_fiscal_service/kkt/fn_record.dart';
import 'package:local_fiscal_service/utils/CRC16CCITT.dart';
import 'package:local_fiscal_service/network/data_container.dart';
import 'package:local_fiscal_service/network/message_header.dart';
import 'package:local_fiscal_service/network/message.dart';

class NetworkManager {
  Socket _socket;
  String _remoteIp;
  int _remotePort;
  int _soTimeout;

  // Socket state
  bool _socketIsClosed = true;

  NetworkManager(String ip, int port, int timeout) {
    _remoteIp = ip;
    _remotePort = port;
    _soTimeout = timeout;
  }

  connect({String ip, int port}) {
    if (ip != null && port != null) {
      _remoteIp = ip;
      _remotePort = port;
    }
    if (_socket != null || _socketIsClosed) {
      // reconnect();
    }
  }

  disconnect() {
    try {
      if (_socket != null && !_socketIsClosed) {
        _socket.close();
      }
    } catch (e) {
      print('Network manager exception: $e');
    }
    _socket = null;
  }

  FnRecord sendRecord(FnRecord outRecord) {
    DataContainer container = new DataContainer();
    container.setDocumentType(outRecord.type);
    container.setBody(outRecord.serialize());
    container.finish();

    MessageHeader header = new MessageHeader();
    header.setFnNumber(outRecord.fnNumber);
    header.setBodySize(container.size);
    Uint8List headerData = header.serialize();
    Uint8List bodyData = container.serialize();
    CRC16CCITT crc = new CRC16CCITT();
    for (int i = 0; i < headerData.length; i++) {
      if (i == MessageHeader.size - 2 || i == MessageHeader.size - 1) {
        continue; //skip crc field
      }
      crc.update(headerData[i]);
    }
    for (int i = 0; i < bodyData.length; i++) {
      crc.update(bodyData[i]);
    }
    header.setCrc(crc.value);

    Message response = sendMessage(Message(
      header: header,
      container: container,
    ));
    return FnRecord.construct(response.container.body);
  }

  Message sendMessage(Message outMsg) {
    Message result;
    try {
      connect();
      result = doSend(outMsg);
    } catch (e) {
      reconnect();
      result = doSend(outMsg);
    }
    return result;
  }

  reconnect() {
    // socket = SocketFactory.getDefault().createSocket(remoteIp, remotePort);
    // socket.setSoTimeout(soTimeout);
  }

  Message doSend(Message outMsg) {
    // OutputStream output = socket.getOutputStream();
    Uint8List outputBuffer = outMsg.serialize();
    // output.write(outputBuffer);

    // InputStream input = socket.getInputStream();
    Uint8List headerBuf = Uint8List(MessageHeader.size);
    // if (input.read(headerBuf) == -1)
    // throw Exception('Unable to read message header from socket);
    MessageHeader header = new MessageHeader(data: headerBuf);
    Uint8List containerBuf = Uint8List(header.bodySize);
    // if (input.read(containerBuf) == -1)
    //   throw Exception('Unable to read message body from socket');
    return Message(
        header: header, container: DataContainer(data: containerBuf));
  }
}
