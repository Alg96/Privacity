import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

import '../http/app_config.dart';
import 'package:mensajeria/src/widgets/dialogs.dart';
import 'package:mensajeria/src/widgets/session.dart';

class AuthAPI {
  final _session = Session();

  Future<bool> register(BuildContext context,
      {@required String email, @required String password}) async {
    final url = "${AppConfig.apiHost}/registro.php";
    final response =
        await http.post(url, body: {"email": email, "password": password});

    final parsed = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (parsed == '0') {
        Dialogs.alert(context,
            title: "Error", message: "Usuario ya registrado");
      }

      if (parsed == '1') {
        await _session.set(email);
        return true;
      }
    }
    if (response.statusCode == 500) {
      Dialogs.alert(context, title: "Error", message: "Error en la red");
      return false;
    }
    return false;
  }

  Future login(BuildContext context,
      {@required String email, @required String password}) async {
    final url = "${AppConfig.apiHost}/login.php";

    final url2 = "${AppConfig.apiHost}/login_nivel.php";

    final response =
        await http.post(url, body: {"email": email, "password": password});

    final String parsed = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (parsed == '0') {
        Dialogs.alert(context,
            title: "Error al Loguearse",
            message: "\nUsuario y/o Contraseña incorrecta");
      }
      if (parsed == '1') {
        final response2 =
            await http.post(url2, body: {"email": email, "password": password});
        final String nivel = jsonDecode(response2.body);

        await _session.set(email);
        return nivel;
      }
      if (parsed == '2') {
        Dialogs.alert(context,
            title: "Error", message: "session iniciada en otro dispositivo");
      }
    }
    if (response.statusCode == 500) {
      Dialogs.alert(context, title: "Error", message: "Error en la red");
      return false;
    }
    return false;
  }

  Future<bool> out(BuildContext context, {@required String email}) async {
    final url = "${AppConfig.apiHost}/out.php";

    final response = await http.post(url, body: {"email": email});

    final String parsed = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (parsed == '1') {
        return true;
      }
    }
    if (response.statusCode == 500) {
      Dialogs.alert(context, title: "Error", message: "Error en la red");
      return false;
    }
    return false;
  }

  Future<bool> solicitud(BuildContext context,
      {@required String correo,
      @required String canal,
      @required String propietario}) async {
    final url = "${AppConfig.apiHost}/insert_Solicitud.php";
    final response = await http.post(url,
        body: {"correo": correo, "canal": canal, "correo2": propietario});

    final parsed = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (parsed == '0') {
        Dialogs.alert(context,
            title: "Error",
            message: "Ya ha mandado una solicitud a este canal");
      }

      if (parsed == '1') {
        return true;
      }
    }
    if (response.statusCode == 500) {
      Dialogs.alert(context, title: "Error", message: "Error en la red");
      return false;
    }
    return false;
  }

  Future<bool> password(BuildContext context,
      {@required String password, String correo}) async {
    final url = "${AppConfig.apiHost}/getPassword.php";
    final response = await http.post(url, body: {
      "correo": correo,
      "password": password,
    });

    final parsed = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (parsed == '0') {
        return true;
      }

      if (parsed == '1') {
        Dialogs.alert(context,
            title: "Error", message: "Contraseña Incorrecta");
      }
    }
    if (response.statusCode == 500) {
      Dialogs.alert(context, title: "Error", message: "Error en la red");
      return false;
    }
    return false;
  }

  Future<bool> registerChanel(BuildContext context,
      {@required String nombre,
      @required String descripcion,
      @required String enlace,
      @required String idchannel,
      @required String correo,
      @required String integrantes}) async {
    var client = http.Client();
    var url = '${AppConfig.apiHost}/insert_channel.php';

    var response = await client.post(url, body: {
      'nombre': nombre,
      'descripcion': descripcion, 
      'enlace': enlace,
      'id_channel': idchannel,
      'correo': correo,
      'integrantes': integrantes
    });

    if (response.statusCode == 200) {
      Toast.show("Canal registrado", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
          return true;
    } else if (response.statusCode == 201) {
      Dialogs.alert(context,
          title: "Error al crear el Canal",
          message: "Ya existe otro canal con\n el mismo nombre");
      return false;
    }
    return false;
  }

  Future<bool> registerGroup(BuildContext context,
      {@required String nombre,
      @required String descripcion,
      @required String correo,
      @required String integrantes}) async {
    var client = http.Client();
    var url = '${AppConfig.apiHost}/insert_group.php';

    var response = await client.post(url, body: {
      'nombre': nombre,
      'descripcion': descripcion, 
      'correo': correo,
      'integrantes': integrantes
    });

    if (response.statusCode == 200) {
      Toast.show("Grupo registrado", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
          return true;
    } else if (response.statusCode == 201) {
      Dialogs.alert(context,
          title: "Error al crear el Grupo",
          message: "Ya existe otro grupo con\n el mismo nombre");
      return false;
    }
    return false;
  }


}
