import 'dart:io';

//192.168.0.1 IP LOCAL porque localhst y 10.0.2.2 no funcionan

class Environment {
  static String apiUrl = Platform.isAndroid
      ? "http://192.168.0.13:3000/api"
      : "localhost:3000/api";
  static String socketUrl =
      Platform.isAndroid ? "http://192.168.0.13:3000" : "localhost:3000";
}
