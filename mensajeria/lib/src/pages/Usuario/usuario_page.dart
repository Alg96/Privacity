import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:mensajeria/api/auth_api.dart';
import 'package:mensajeria/http/app_config.dart';
import 'package:mensajeria/src/widgets/session.dart';
import 'package:mensajeria/src/pages/login_page.dart';
import 'package:mensajeria/src/pages/Componentes/perfil_page.dart';
import 'package:mensajeria/src/pages/Componentes/channel_not_in.dart';
import 'package:mensajeria/src/pages/Usuario/channel_group_page.dart';

class UsuarioPage extends StatefulWidget {
  @override
  _UsuarioPageState createState() => new _UsuarioPageState();
}

class _UsuarioPageState extends State<UsuarioPage> {
  final _session = Session();
  String data, usuario = "";

  String correo;
  final _authAPI = AuthAPI();

  del() async {
    String email = await _session.get();
    await _authAPI.out(context, email: email);
    await _session.del();
    //Navigator.pushReplacementNamed(context, "Login");
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  void getUsuario() async {
    String correo = await _session.get();

    final response = await http
        .post('${AppConfig.apiHost}/getUsuario.php', body: {"correo": correo});
    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    getUsuario();
    usuario = data;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            appBarTheme: AppBarTheme(
          color: Color.fromARGB(255, 49, 84, 74),
        )),
        home: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              actions: <Widget>[
                PopupMenuButton(
                  icon: Icon(Icons.storage),
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                          value: 1,
                          child: ListTile(
                              leading: Icon(Icons.edit),
                              title: Text("Mi Perfil"))),
                      PopupMenuItem(
                          value: 2,
                          child: ListTile(
                              leading: Icon(Icons.exit_to_app),
                              title: Text("Cerrar Sesión")))
                    ];
                  },
                  onSelected: (value) {
                    value == 1
                        ? //Navigator.pushReplacementNamed(context, "User")
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PerfilPage("usuario")))
                        : value == 2 ? del() : print("Error");
                  },
                ),
              ],
              bottom: TabBar(
                tabs: [
                  Tab(
                      child: Text('Canales'),
                      icon: Image.asset(
                        "assets/images/canales.png",
                        width: 30,
                        height: 30,
                      )),
                  Tab(
                      child: Text('Grupos'),
                      icon: Image.asset(
                        "assets/images/grupos.png",
                        width: 30,
                        height: 30,
                      )),
                  Tab(child: Text('Otros\nCanales',textAlign: TextAlign.center,), icon: Icon(Icons.add)),
                ],
                indicatorColor: Color.fromARGB(255, 255, 255, 255),
              ),
              title: data == null ? Text("Cargando Usuario") : Text(usuario),
            ),
            body: TabBarView(
              children: [
                ChannelGroup("Channel"),
                ChannelGroup("Group"),
                ChannelNotIn()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() {
  return showCupertinoDialog(
    context: context,
    builder: (context) => new CupertinoAlertDialog(
      title: Text("¿Deseas salir de la Aplicación?"),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text("Si"),
          onPressed: ()=> exit(0),
        ),
        CupertinoDialogAction(
          child: Text("No"),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ],
    ),
  ) ??
    false;
  }

}
