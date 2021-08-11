import 'package:flutter/material.dart';

class ChatMessage extends StatefulWidget {
  final String texto;
  final String uid;
  final AnimationController animationController;
  ChatMessage({
    @required this.texto,
    @required this.uid,
    @required this.animationController,
  });
  @override
  _ChatMessageState createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: widget.animationController,
      axis: Axis.vertical,
      child: FadeTransition(
        opacity: widget.animationController,
        child: Container(
          child: widget.uid == '123' ? _myMessage() : _notMyMessage(),
        ),
      ),
    );
  }

  Widget _myMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.only(
          bottom: 5,
          right: 10,
          left: 50,
        ),
        child: Text(
          widget.texto,
          style: TextStyle(color: Colors.white),
        ),
        decoration: BoxDecoration(
          color: Colors.blue[400],
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _notMyMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.only(
          bottom: 5,
          left: 10,
          right: 50,
        ),
        child: Text(
          widget.texto,
          style: TextStyle(color: Colors.black),
        ),
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
