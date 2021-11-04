import 'package:flutter/material.dart';
import 'package:proyecto_chat/global/environment.dart';
import 'package:proyecto_chat/services/auth_service.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting,
}

class SocketService with ChangeNotifier {
  //Atributos
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;

  //Getters
  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;

  void connect() async {
    //Obtenemos token por getter estatico
    final token = await AuthService.getToken();
    //print(token);

    _socket = IO.io(Environment.socketUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew':
          true, //Forzar al backend a que genere una nueva conexion,y no reintente utilizar la ultima
      'extraHeaders': {'x-token': token}, //Se envia token al backend
    });

    _socket.on('connect', (_) {
      this._serverStatus = ServerStatus.Online;
      _socket.emit('mensaje', {'contenido': 'Hola server desde dart'});
      notifyListeners();
    });

    _socket.on('disconnect', (_) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    /*_socket.on('nuevo-mensaje', (payload) {
      var nombre =
          payload.containsKey('nombre') ? payload['nombre'] : 'Anonimo';
      var mensaje =
          payload.containsKey('mensaje') ? payload['mensaje'] : 'Sin mensaje';
      print('Nuevo mensaje de $nombre : $mensaje');
    });*/
  }

  void disconnect() {
    _socket.disconnect();
  }
}
