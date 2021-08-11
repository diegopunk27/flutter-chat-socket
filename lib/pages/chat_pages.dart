import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: <Widget>[
            CircleAvatar(
              child: Text(
                "Di",
                style: TextStyle(fontSize: 12),
              ),
              backgroundColor: Colors.blue[100],
              maxRadius: 15,
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              "Diego Yanacon",
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
        uid: '123',
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

    super.dispose();
  }
}
