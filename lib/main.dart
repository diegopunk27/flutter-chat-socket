import 'package:flutter/material.dart';

import 'package:proyecto_chat/routes/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: 'login',
      routes: appRoutes,
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('ChatApp'),
        ),
        body: Center(
          child: Container(
            child: Text('Hello World'),
          ),
        ),
      ),
    );
  }
}
