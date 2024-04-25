import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketManager {
  final String _url;
  late WebSocketChannel _channel;
  bool _isOpen = false;

  WebSocketManager(this._url) {
    if(_isOpen == false){
      _channel = WebSocketChannel.connect(Uri.parse(_url));
      _isOpen = true;
    }else{

    }
  }

  Stream get stream => _channel.stream;

  // Thêm một getter cho _url
  String get url => _url;

  void close() {
    _channel.sink.close();
    _isOpen = false;
  }

}