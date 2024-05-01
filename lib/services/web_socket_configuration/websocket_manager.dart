import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketManager {
  final String _url;
  late WebSocketChannel _channel;
  bool _isOpen = false;

  WebSocketManager(this._url) {
    _openWebSocket();
  }

  void _openWebSocket() {
    _channel = WebSocketChannel.connect(Uri.parse(_url));
    _isOpen = true;
  }

  String get url => _url;

  Stream get stream => _channel.stream;


  void close() {
    _channel.sink.close();
    _isOpen = false;
  }

  void sendRequest(String requestId, String method, Map<String, dynamic> params) {
    if (!_isOpen) {
      _openWebSocket();
    }

    final request = {
      'id': requestId,
      'method': method,
      'params': params,
    };
    _channel.sink.add(jsonEncode(request)); // Convert Map to JSON String
  }

  void listenForResponses(Function(dynamic) callback) {
    if (_isOpen) {
      _channel.stream.listen((dynamic message) {
        callback(message);
      });
    }
  }
}
