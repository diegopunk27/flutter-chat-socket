import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:proyecto_chat/services/auth_service.dart';
import 'package:proyecto_chat/global/environment.dart';
import 'package:proyecto_chat/models/mensajes_response.dart';
import 'package:proyecto_chat/models/usuario.dart';

class ChatService with ChangeNotifier {
  Usuario usuarioPara;

  Future<List<Mensaje>> obtenerChat(String usuarioParaId) async {
    try {
      final response = await http.get(
        "${Environment.apiUrl}/mensajes/$usuarioParaId",
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken(),
        },
      );

      if (response.statusCode == 200) {
        final mensajesResp = mensajesResponseFromJson(response.body);
        return mensajesResp.mensajes;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
