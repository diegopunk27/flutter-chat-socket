import 'package:http/http.dart' as http;

import 'package:proyecto_chat/global/environment.dart';
import 'package:proyecto_chat/models/usuario.dart';
import 'package:proyecto_chat/models/usuarios_response.dart';
import 'package:proyecto_chat/services/auth_service.dart';

class UsuariosService {
  Future<List<Usuario>> getUsuarios() async {
    try {
      String token = await AuthService.getToken();
      final resp = await http.get("${Environment.apiUrl}/usuarios", headers: {
        "Content-Type": "application/json",
        "x-token": token,
      });

      final listUsuarios = usuariosResponseFromJson(resp.body).usuarios;
      return listUsuarios;
    } catch (e) {
      return [];
    }
  }
}
