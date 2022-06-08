import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus{
  Online,
  Offline,
  Connecting
}

class SocketService with ChangeNotifier{

  ServerStatus _serverStatus = ServerStatus.Connecting;

  get getServerStatus => _serverStatus;

  SocketService(){
    _initConfig();
  }

void _initConfig(){
// Dart client
  IO.Socket socket = IO.io('http://192.168.5.108:3000',   {
      'transports':['websocket'],
      'autoConnect':true
    }
  );
  socket.onConnect((_) {
    // ignore: avoid_print
    print('connect');
    _serverStatus=ServerStatus.Online;
    notifyListeners();
  });

  socket.onDisconnect((_){
    print('disconnect');
    _serverStatus=ServerStatus.Offline;
    notifyListeners();
    }
  );

  socket.on('nuevo-mensaje',(payload){
    print('nuevo-mensaje:');
    print('nombre: '+ payload['nombre']);
    print('mensaje: '+ payload['mensaje']);
    print(payload.containsKey('mensaje2')? payload['mensaje2']:'no hay');
    }
  );

}
}