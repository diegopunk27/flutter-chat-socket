import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:proyecto_chat/models/mensajes_response.dart';
import 'package:proyecto_chat/services/auth_service.dart';
import 'package:proyecto_chat/services/chat_service.dart';
import 'package:proyecto_chat/services/socket-service.dart';
import 'package:proyecto_chat/widgets/chat_messages.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  TextEditingController textController = new TextEditingController();
  FocusNode focusNode = new FocusNode();
  bool isWriting = false;
  List<ChatMessage> mensajes = [];

  ChatService chatService;
  SocketService socketService;
  AuthService authService;

  @override
  void initState() {
    super.initState();
    /* Los providers deben tener el listen en false en el initState xq no es necesario actualizar estados,
      y generará un error, salvo que el provider se encuentre en un callback
     */
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);
    //Escuchar los mensjes del socket
    socketService.socket.on('mensaje-personal', _escucharMensaje);
    //Carga el historiald e mensajes
    _cargarHistorial(chatService.usuarioPara.uid);
  }

  //Funcion para cargar el historial de mensajes
  _cargarHistorial(String usuarioID) async {
    List<Mensaje> mensasjesChat = await chatService.obtenerChat(usuarioID);
    final historial = mensasjesChat.map(
      (m) => new ChatMessage(
        texto: m.mensaje,
        uid: m.de,
        animationController: AnimationController(
          vsync: this,
          duration: (Duration(milliseconds: 0)),
        )..forward(),
      ),
    );

    setState(() {
      mensajes.insertAll(0, historial);
    });
  }

  //Funcion que recibe el payload y los carga en la lista de mensajes
  void _escucharMensaje(dynamic payload) {
    print("Mensaje recbido $payload");

    ChatMessage message = new ChatMessage(
      texto: payload["mensaje"],
      uid: payload["de"],
      animationController: AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: 500,
        ),
      ),
    );

    setState(() {
      mensajes.insert(0, message);
    });

    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: <Widget>[
            CircleAvatar(
              child: Text(
                chatService.usuarioPara.nombre.substring(0, 2),
                style: TextStyle(fontSize: 12),
              ),
              backgroundColor: Colors.blue[100],
              maxRadius: 15,
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              chatService.usuarioPara.nombre,
              style: TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: mensajes.length,
                itemBuilder: (context, index) => mensajes[index],
                reverse: true,
              ),
            ),
            Divider(
              height: 3,
            ),
            Container(
              color: Colors.white,
              child: _inputMsg(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputMsg() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: textController,
                focusNode: focusNode,
                onChanged: (value) {
                  setState(() {
                    if (value.trim() != "") {
                      isWriting = true;
                    } else {
                      isWriting = false;
                    }
                  });
                },
                onSubmitted: (value) => _handleMsg(),
                decoration: InputDecoration.collapsed(
                    hintText: "Escriba un mensaje..."),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: Platform.isIOS
                  ? CupertinoButton(
                      child: Text("Enviar"), onPressed: _handleMsg)
                  : IconButton(
                      /* Hacer tranparente los efectos al tocar el icono */
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      icon: Icon(
                        Icons.send,
                        color: isWriting ? Colors.blue[400] : Colors.grey[600],
                      ),
                      onPressed: _handleMsg,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleMsg() {
    String msg = textController.text;
    if (msg != "") {
      final newMsg = new ChatMessage(
        texto: msg,
        uid: authService.usuario.uid,
        animationController: AnimationController(
            vsync: this,
            duration: Duration(
              milliseconds: 500,
            )),
      );
      textController.clear();
      focusNode.requestFocus();
      setState(() {
        //mensajes.add(newMsg); O INSERTA AL PRINCIPO, POR ESO USAR EL INSERT EN POSICION 0
        mensajes.insert(0, newMsg);
        newMsg.animationController.forward(); //Dispara el proceso de animación
        isWriting = false;
      });

      socketService.socket.emit("mensaje-personal", {
        "de": authService.usuario.uid,
        "para": chatService.usuarioPara.uid,
        "mensaje": msg,
      });
    }
  }

  @override
  void dispose() {
    // TODO: off de socket
    for (ChatMessage mensaje in mensajes) {
      //Recorre cada mensaje cargado en la lista, y limpia su controlador
      //De esta manera cuando se cierre el chat, se libera la memoria utilizada
      mensaje.animationController.dispose();
    }

    //Destruye la conexion con el socket cuando sale
    socketService.socket.off('mensaje-personal');
    super.dispose();
  }
}
