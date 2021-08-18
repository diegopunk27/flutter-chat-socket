import 'dart:convert';

import 'package:proyecto_chat/models/usuario.dart';

/* FROM quicktype */

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  bool ok;
  Usuario usuario;
  String jwt;

  LoginResponse({
    this.ok,
    this.usuario,
    this.jwt,
  });

  LoginResponse.fromJson(Map<String, dynamic> json)
      : ok = json["ok"],
        usuario = Usuario.fromJson(json["usuario"]),
        jwt = json["jwt"];

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "usuario": usuario.toJson(),
        "jwt": jwt,
      };
}
