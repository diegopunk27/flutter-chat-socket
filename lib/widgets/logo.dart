import 'package:flutter/material.dart';

class LogoChat extends StatelessWidget {
  final String titulo;

  const LogoChat({@required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 170,
        child: Column(
          children: <Widget>[
            Image(
              image: AssetImage(
                'assets/tag-logo.png',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              titulo,
              style: TextStyle(fontSize: 30),
            )
          ],
        ),
      ),
    );
  }
}
