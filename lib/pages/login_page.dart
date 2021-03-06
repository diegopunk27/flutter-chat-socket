import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:proyecto_chat/helpers/alert_dialog.dart';

import 'package:proyecto_chat/services/auth_service.dart';
import 'package:proyecto_chat/services/socket-service.dart';
import 'package:proyecto_chat/widgets/blue_boton.dart';
import 'package:proyecto_chat/widgets/custom_input.dart';
import 'package:proyecto_chat/widgets/labels.dart';
import 'package:proyecto_chat/widgets/logo.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2F2),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          padding: EdgeInsets.only(top: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              LogoChat(
                titulo: 'Messenger',
              ),
              _FormLogin(),
              Labels(
                ruta: 'register',
                upText: '¿Todavía no tienes una cuenta?',
                downText: 'Crea una ahora',
              ),
              Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Text("Términos y condiciones"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormLogin extends StatefulWidget {
  @override
  _FormLoginState createState() => _FormLoginState();
}

class _FormLoginState extends State<_FormLogin> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final socket = Provider.of<SocketService>(context, listen: false);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget>[
          CustomInput(
            icon: Icons.email,
            text: 'Email',
            inputType: TextInputType.emailAddress,
            textEditingController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            text: 'Contraseña',
            inputType: TextInputType.visiblePassword,
            textEditingController: passCtrl,
            isPassword: true,
          ),
          BlueBoton(
            text: "Ingrese",
            /* Si autenticando es true, el boton queda oscuro (en null), sino se habilita el boton.
               Así se evita el doble post
             */
            onPress: auth.autenticando
                ? null
                : () async {
                    // Quita el focus de donde esté y ocultará el teclado si está desplegado
                    FocusScope.of(context).unfocus();
                    final bool loginOk = await auth.login(
                      emailCtrl.text.trim(),
                      passCtrl.text.trim(),
                    );
                    if (loginOk) {
                      //iniciar socket
                      socket.connect();
                      Navigator.of(context).pushReplacementNamed("usuarios");
                    } else {
                      //Mostrar alerta
                      mostrarDialogo(
                        context,
                        "Login incorrecto",
                        "Revise las credenciales",
                      );
                    }
                  },
          ),
        ],
      ),
    );
  }
}
