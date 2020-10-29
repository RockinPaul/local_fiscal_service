import 'dart:io';
import 'package:local_fiscal_service/kkt/fn_record.dart';
import 'package:local_fiscal_service/utils/CRC16CCITT.dart';
import 'package:local_fiscal_service/network/data_container.dart';

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
    } catch(e) {
      print('Network manager exception: $e');
    }
    _socket = null;
  }

  FnRecord send(FnRecord outRecord) {
  DataContainer container = new DataContainer();
  container.setDocumentType(outRecord.type);
  container.setBody(outRecord.serialize());
  container.finish();

  MessageHeader header = new MessageHeader();
  header.setFnNumber(outRecord.getFnNumber());
  header.setBodySize(container.getSize());
  byte[] headerData = header.serialize();
  byte[] bodyData = container.serialize();
  CRC16CCITT crc = new CRC16CCITT();
  for(int i=0; i<headerData.length; i++){
  if(i == MessageHeader.getSize()-2 || i == MessageHeader.getSize()-1) {
  continue; //skip crc field
  }
  crc.update(headerData[i]);
  }
  for(int i=0; i<bodyData.length; i++){
  crc.update(bodyData[i]);
  }
  header.setCrc(crc.getValue());

  Message response = send(new Message(header, container));
  return FnRecord.construct(response.getContainer().getBody());
}

  private Message send(Message outMsg) throws IOException {
  Message result;
  try {
  connect();
  result = doSend(outMsg);
  } catch (IOException e) {
  reconnect();
  result = doSend(outMsg);
  }
  return result;
  }

  private void reconnect() throws IOException {
  socket = SocketFactory.getDefault().createSocket(remoteIp, remotePort);
  socket.setSoTimeout(soTimeout);
  }

  private Message doSend(Message outMsg) throws IOException {
  OutputStream output = socket.getOutputStream();
  byte[] outputBuffer = outMsg.serialize();
  output.write(outputBuffer);

  InputStream input = socket.getInputStream();
  byte[] headerBuf = new byte[MessageHeader.getSize()];
  if(input.read(headerBuf) == -1)
  throw new java.net.SocketException("Unable to read message header from socket");
  MessageHeader header = new MessageHeader(headerBuf);
  byte[] containerBuf = new byte[header.getBodySize()];
  if(input.read(containerBuf) == -1)
  throw new java.net.SocketException("Unable to read message body from socket");
  return new Message(header, new DataContainer(containerBuf));
  }
}