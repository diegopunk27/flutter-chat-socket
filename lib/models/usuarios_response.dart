// To parse this JSON data, do
//
//     final usuariosResponse = usuariosResponseFromJson(jsonString);

import 'dart:convert';

import 'package:proyecto_chat/models/usuario.dart';

UsuariosResponse usuariosResponseFromJson(String str) =>
    UsuariosResponse.fromJson(json.decode(str));

String usuariosResponseToJson(UsuariosResponse data) =>
    json.encode(data.toJson());

class UsuariosResponse {
  UsuariosResponse({
    this.ok,
    this.usuarios,
  });

  bool ok;
  List<Usuario> usuarios;

  UsuariosResponse.fromJson(Map<String, dynamic> json)
      : ok = json["ok"],
        usuarios = List<Usuario>.from(
          json["usuarios"].map((x) => Usuario.fromJson(x)),
        );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "usuarios": List<dynamic>.from(usuarios.map((x) => x.toJson())),
      };
}
