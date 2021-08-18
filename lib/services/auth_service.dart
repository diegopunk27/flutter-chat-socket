import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:proyecto_chat/global/environment.dart';
import 'package:proyecto_chat/models/login_response.dart';
import 'package:proyecto_chat/models/usuario.dart';

class AuthService with ChangeNotifier {
  Usuario usuario;
  bool _autenticando = false;

  // Create storage
  final _storage = new FlutterSecureStorage();

  /* Getters staticos de token */
  static Future<String> getToken() async {
    final _storage = new FlutterSecureStorage();
    String token = await _storage.read(key: "token");
    return token;
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: "token");
  }

  /* Permite controlar que el proceso de post todavía no terminó, así se puede evitar el doble post */
  bool get autenticando => _autenticando;
  set autenticando(bool valor) {
    _autenticando = valor;
    notifyListeners();
  }

  /* Métodos de auth */
  Future<bool> login(String email, String password) async {
    bool salida;
    this.autenticando = true;

    final data = {
      "email": email,
      "password": password,
    };

    final response = await http.post(
      "${Environment.apiUrl}/login",
      body: jsonEncode(data),
      headers: {"Content-Type": "application/json"},
    );
    print(response.body);

    if (response.statusCode == 200) {
      final loginResponse = loginResponseFromJson(response.body);
      usuario = loginResponse.usuario;
      await _guardarToken(loginResponse.jwt);
      salida = true;
    } else {
      salida = false;
    }

    this.autenticando = false;
    return salida;
  }

  Future<dynamic> register(String nombre, String email, String password) async {
    dynamic salida;
    this.autenticando = true;

    final data = {
      "nombre": nombre,
      "email": email,
      "password": password,
    };

    final response = await http.post(
      "${Environment.apiUrl}/login/new",
      body: jsonEncode(data),
      headers: {"Content-Type": "application/json"},
    );

    print(response.body);

    if (response.statusCode == 200) {
      final loginResponse = loginResponseFromJson(response.body);
      usuario = loginResponse.usuario;
      await _guardarToken(loginResponse.jwt);
      salida = true;
    } else {
      //retorna el mensaje de error del backend
      salida = jsonDecode(response.body)["msg"];
    }

    this.autenticando = false;

    /* Si no hay error retorna true, en caso contrario retorna el mensaje de error */
    return salida;
  }

  Future<bool> isLoggedIn() async {
    bool salida;
    String token = await _storage.read(key: "token");

    final response = await http.get(
      "${Environment.apiUrl}/login/renew",
      headers: {
        "Content-Type": "application/json",
        "x-token": token,
      },
    );
    print(response.body);

    if (response.statusCode == 200) {
      final loginResponse = loginResponseFromJson(response.body);
      usuario = loginResponse.usuario;
      await _guardarToken(loginResponse.jwt);
      salida = true;
    } else {
      salida = false;
    }

    return salida;
  }

  Future _guardarToken(String token) async {
    //Almacenar token en el storage
    return await _storage.write(key: "token", value: token);
  }

  Future logOut() async {
    //Eliminar token del storage
    await _storage.delete(key: "token");
  }
}
