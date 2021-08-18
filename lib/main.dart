import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:proyecto_chat/routes/routes.dart';
import 'package:proyecto_chat/services/auth_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(
          create: (_) => AuthService(),
        )
      ],
      child: MaterialApp(
        initialRoute: 'loading',
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
      ),
    );
  }
}
