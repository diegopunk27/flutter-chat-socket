import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_chat/helpers/alert_dialog.dart';
import 'package:proyecto_chat/services/auth_service.dart';
import 'package:proyecto_chat/widgets/blue_boton.dart';

import 'package:proyecto_chat/widgets/custom_input.dart';
import 'package:proyecto_chat/widgets/labels.dart';
import 'package:proyecto_chat/widgets/logo.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2F2),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(top: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              LogoChat(
                titulo: 'Registro',
              ),
              _FormLogin(),
              Labels(
                ruta: 'login',
                upText: '¿Ya tienes una cuenta?',
                downText: 'Ingresa desde aquí',
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
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget>[
          CustomInput(
            icon: Icons.perm_identity,
            text: 'Nombre',
            inputType: TextInputType.text,
            textEditingController: nameCtrl,
          ),
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
            text: "Registrar",
            onPress: auth.autenticando
                ? null
                : () async {
                    print(nameCtrl.text);
                    print(emailCtrl.text);
                    print(passCtrl.text);

                    dynamic registerOk = await auth.register(
                      nameCtrl.text.trim(),
                      emailCtrl.text.trim(),
                      passCtrl.text.trim(),
                    );

                    if (registerOk == true) {
                      //TODO: llamar a socket
                      Navigator.of(context).pushReplacementNamed("usuarios");
                    } else {
                      mostrarDialogo(context, "Error de registro", registerOk);
                    }
                  },
          ),
        ],
      ),
    );
  }
}
