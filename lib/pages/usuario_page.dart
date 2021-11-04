import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_chat/services/chat_service.dart';
import 'package:proyecto_chat/services/socket-service.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:proyecto_chat/models/usuario.dart';
import 'package:proyecto_chat/services/auth_service.dart';
import 'package:proyecto_chat/services/usuarios_service.dart';

class UsuariosPage extends StatefulWidget {
  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final usuariosService = new UsuariosService();
  List<Usuario> usuarios = [];

  @override
  void initState() {
    obtenerUsuarios();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final socket = Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          auth.usuario.nombre,
          style: TextStyle(color: Colors.lightBlue),
        ),
        elevation: 1,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.exit_to_app,
            color: Colors.lightBlue,
          ),
          onPressed: () async {
            //Deconectar socket
            socket.disconnect();
            await auth.logOut();

            /* Otra manera de hace logout 
              AuthService.deleteToken();
              En este caso no se necesita usar provider, porque al ser deleteToken un metodo estatico
              no es necesario instanciar la clase  
            */
            Navigator.of(context).pushReplacementNamed('login');
          },
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            child: socket.serverStatus == ServerStatus.Online
                ? Icon(
                    Icons.check_circle,
                    color: Colors.blue,
                  )
                : Icon(
                    Icons.offline_bolt,
                    color: Colors.red,
                  ),
          ),
        ],
      ),
      body: SmartRefresher(
        child: usuarioListView(),
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: obtenerUsuarios,
        header: WaterDropHeader(
          //OPCION idleIcon: Icon(Icons.refresh),
          complete: Icon(
            Icons.check,
            color: Colors.blue[400],
          ),
          waterDropColor: Colors.blue[400],
          /*OPCION refresh: CircularProgressIndicator(
            backgroundColor: Colors.red,
            strokeWidth: 6,
          ),*/
        ),
      ),
    );
  }

  ListView usuarioListView() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      separatorBuilder: (context, index) => Divider(),
      itemCount: usuarios.length,
      itemBuilder: (context, index) {
        return UsuarioListTile(usuario: usuarios[index]);
      },
    );
  }

  obtenerUsuarios() async {
    usuarios = await usuariosService.getUsuarios();
    setState(() {});
    _refreshController.refreshCompleted();
  }
}

class UsuarioListTile extends StatelessWidget {
  final Usuario usuario;
  UsuarioListTile({
    @required this.usuario,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(usuario.nombre.substring(0, 2)),
        backgroundColor: Colors.blue[100],
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: usuario.online ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      title: Text(usuario.nombre),
      subtitle: Text(usuario.email),
      onTap: () {
        /*Instancia la clase ChatService y almacena el usuario al que se hace tap en la propiedad usuarioPara
          De esta manera se podra acceder a la informacion del usuario en la agina del chat.
          NOTA: Otra opción era mandar el usuario como parametro en el Navigator, y evitar crear un provider
        */
        final usuarioService = Provider.of<ChatService>(context, listen: false);
        usuarioService.usuarioPara = usuario;
        Navigator.of(context).pushNamed("chat");
      },
    );
  }
}
