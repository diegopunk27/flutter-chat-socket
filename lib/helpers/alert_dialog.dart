import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

mostrarDialogo(BuildContext context, String titulo, String subtitulo) {
  if (Platform.isAndroid) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(subtitulo),
          actions: <Widget>[
            MaterialButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Ok"),
              elevation: 5,
              color: Colors.blue,
            ),
          ],
        );
      },
    );
  }

  if (Platform.isIOS) {
    return showCupertinoDialog(
      context: context,
      builder: (_) {
        return CupertinoAlertDialog(
          title: Text(titulo),
          content: Text(subtitulo),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
