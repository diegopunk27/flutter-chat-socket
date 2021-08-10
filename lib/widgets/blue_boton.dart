import 'package:flutter/material.dart';

class BlueBoton extends StatelessWidget {
  final Function onPress;
  final String text;

  const BlueBoton({
    @required this.onPress,
    @required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      elevation: 3,
      shape: StadiumBorder(),
      color: Colors.blue,
      highlightElevation: 5,
      onPressed: onPress,
      child: Container(
        height: 55,
        width: double.infinity,
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
