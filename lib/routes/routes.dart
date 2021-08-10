import 'package:flutter/material.dart';

import 'package:proyecto_chat/pages/chat_pages.dart';
import 'package:proyecto_chat/pages/loading_page.dart';
import 'package:proyecto_chat/pages/login_page.dart';
import 'package:proyecto_chat/pages/register_page.dart';
import 'package:proyecto_chat/pages/usuario_page.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'usuarios': (_) => UsuariosPage(),
  'chat': (_) => ChatPage(),
  'login': (_) => LoginPage(),
  'register': (_) => RegisterPage(),
  'loading': (_) => LoadingPage(),
};
