import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:random_string/random_string.dart';

class ListViewWidget extends StatefulWidget {

  final String numerodiputado;

  ListViewWidget(this.numerodiputado,{Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ListViewWidgetState();
}

class _ListViewWidgetState extends State<ListViewWidget> {

  List data = [];

  TextEditingController numerodiputadoController;
  TextEditingController nombreController;
  TextEditingController apellidopController;
  TextEditingController apellidomController;
  TextEditingController correoController;
  TextEditingController telefonoController;

  String para,titulo,mensaje;

  void getData() async {
    final response = await http.get('http://alg96email.000webhostapp.com/getData.php?numero_diputado=${widget.numerodiputado}');

    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
      });
    }
  }

   void _email() {
    var url = ("http://alg96email.000webhostapp.com/email.php");

    http.post(url, body: {
      "para": correoController.text,
      "titulo": "Password Provisional",
      "mensaje": randomAlphaNumeric(15)
    });

  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ListView"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) => Center(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: numerodiputadoController = new TextEditingController(text:(data[index]['numero_diputado'])),
                    textAlign: TextAlign.center,
                  ),
                  TextField(
                    controller: nombreController = new TextEditingController(text:(data[index]['nombre'])),
                    textAlign: TextAlign.center,                  
                  ),
                  TextField(
                    controller: apellidopController = new TextEditingController(text:(data[index]['apellidop'])),
                    textAlign: TextAlign.center,                  
                  ),
                  TextField(
                    controller: apellidomController = new TextEditingController(text:(data[index]['apellidom'])),
                    textAlign: TextAlign.center, 
                  ),
                  TextField(
                    controller: correoController = new TextEditingController(text:(data[index]['correo'])),
                    textAlign: TextAlign.center, 
                  ),
                  TextField(
                    controller: telefonoController = new TextEditingController(text:(data[index]['telefono'])),
                    textAlign: TextAlign.center, 
                  ),
                ],
              ),
            ),
          ),
          RaisedButton(
            child: Text("Salir"),
            onPressed: (){
              Navigator.pushReplacementNamed(context,'/HomePage');
            },
          ),
          RaisedButton(
            child: Text("Registro"),
            onPressed: (){
              _email();
            },
          ),
        ],
      ),
    );
  }
}
