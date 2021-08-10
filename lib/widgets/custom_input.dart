import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final IconData icon;
  final String text;
  final TextInputType inputType;
  final TextEditingController textEditingController;
  final bool isPassword;
  CustomInput({
    @required this.icon,
    @required this.text,
    @required this.textEditingController,
    this.inputType = TextInputType.text,
    this.isPassword = false,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 5, 20, 5),
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
              offset: Offset(0, 5), color: Colors.grey[100], blurRadius: 5),
        ],
      ),
      child: TextField(
        controller: textEditingController,
        autocorrect: false,
        keyboardType: inputType,
        obscureText: isPassword,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          focusedBorder: InputBorder.none,
          border: InputBorder.none,
          hintText: text,
        ),
      ),
    );
  }
}
