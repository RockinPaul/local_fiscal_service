import 'dart:io';
import 'package:local_fiscal_service/kkt/fn_record.dart';
import 'package:local_fiscal_service/utils/CRC16CCITT.dart';

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
}