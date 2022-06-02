import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus{
  Online,
  Offline,
  Connecting
}

class SocketService with ChangeNotifier{

  ServerStatus _serverStatus = ServerStatus.Connecting;

  SocketService(){

  }

void _initConfig(){
// Dart client
  IO.Socket socket = IO.io('http://10.0.2.2:3000',   {
      'transports':['websockets'],
      'autoConnect':true
    }
  );
  socket.onConnect((_) {
    print('connect');
  });
  socket.onDisconnect((_) => print('disconnect'));

}
}