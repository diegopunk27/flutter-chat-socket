import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  final String ruta;
  final String upText;
  final String downText;
  Labels({
    @required this.ruta,
    @required this.upText,
    @required this.downText,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            upText,
            style: TextStyle(
                color: Colors.black, fontSize: 15, fontWeight: FontWeight.w200),
          ),
          GestureDetector(
            child: Text(
              downText,
              style: TextStyle(
                  color: Colors.blue[600],
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, ruta);
            },
          ),
        ],
      ),
    );
  }
}
