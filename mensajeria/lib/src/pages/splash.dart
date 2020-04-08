import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'Usuario/usuario_page.dart';
import 'package:mensajeria/http/app_config.dart';
import 'package:mensajeria/src/widgets/session.dart';
import 'package:mensajeria/src/pages/login_page.dart';
import 'package:mensajeria/src/pages/Administrador/admin_page.dart';
import 'package:mensajeria/src/pages/Comunicador/comunicador_page.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final _session = Session();

  final url = "${AppConfig.apiHost}/login_storage.php";

  @override
  initState() {
    //this.del();
    super.initState();
    this.check();
  }

  del() async {
    await _session.del();
  }

  check() async {
    final correo = await _session.get();

    if (correo != null) {
      final response = await http.post(url, body: {"email": correo});
      final String parsed = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (parsed == '0') {
          //Navigator.pushReplacementNamed(context, "Administrador");
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AdminPage()));
        }
        if (parsed == '1') {
          // Navigator.pushReplacementNamed(context, 'Comunicador');
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ComunicadorPage()));
        }
        if (parsed == '2') {
          //Navigator.pushReplacementNamed(context, 'Diputado')
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => UsuarioPage()));
        }if (parsed == null){     
          //Navigator.pushReplacementNamed(context, "Login");
          Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
        }
      }     
    } else {
      //Navigator.pushReplacementNamed(context, "Login");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CupertinoActivityIndicator(radius: 30),
      ),
    );
  }
}
