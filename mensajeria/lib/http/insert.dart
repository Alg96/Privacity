import 'package:http/http.dart' as http;

import 'app_config.dart';

void insertChannel(String nombre, String descripcion, String enlace,
    String idchannel, String email) async {
  var url = "${AppConfig.apiHost}/insert_channel.php";
  var response = await http.post(url, body: {
    "nombre": nombre,
    "descripcion": descripcion,
    "enlace": enlace,
    "id_channel": idchannel,
    "email": email
  });
  if (response.statusCode == 200) {
  } else {}
}

void insertGroup(String nombre, String descripcion, String email) async {
  var url = "${AppConfig.apiHost}/insert_group.php";
  var response = await http.post(url,
      body: {"nombre": nombre, "descripcion": descripcion, "email": email});
  if (response.statusCode == 200) {
    print("privado Insertado");
  } else {}
}
