import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketManager {
  final String _url;
  late WebSocketChannel _channel;
  bool _isOpen = false;

  WebSocketManager(this._url) {
    _channel = WebSocketChannel.connect(Uri.parse(_url));
    _isOpen = true;
  }

  Stream get stream => _channel.stream;

  // Thêm một getter cho _url
  String get url => _url;

  void close() {
    _channel.sink.close();
    _isOpen = false;
  }

  //configure for websocket api
  void sendRequest(String requestId, String method, Map<String, dynamic> params) async {

    final request = {
      'id': requestId,
      'method': method,
      'params': params,
    };
    _channel.sink.add(jsonEncode(request)); // Convert Map to JSON String
  }

  void listenForResponses(Function(dynamic) callback) {
    _channel.stream.listen((dynamic message) {
      callback(message);
    });
  }
  //configure for websocket api

}