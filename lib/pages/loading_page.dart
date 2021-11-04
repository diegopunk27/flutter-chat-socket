import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_chat/pages/usuario_page.dart';
import 'package:proyecto_chat/services/auth_service.dart';
import 'package:proyecto_chat/services/socket-service.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: loading(context),
        builder: (_, snapshot) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Future loading(BuildContext context) async {
    final auth = Provider.of<AuthService>(context, listen: false);
    final socket = Provider.of<SocketService>(context, listen: false);
    bool autenticado = await auth.isLoggedIn();
    if (autenticado) {
      // Inicializar socket
      socket.connect();

      /* Se utiliza el "pushReplacement(PageRouteBuilder" para poder configurar los efectos
        de despliegue de la pantalla
       */
      Navigator.of(context).pushReplacement(PageRouteBuilder(
        pageBuilder: (_, __, ___) => UsuariosPage(),
      ));
    } else {
      Navigator.of(context).pushReplacementNamed("login");
    }
  }
}
