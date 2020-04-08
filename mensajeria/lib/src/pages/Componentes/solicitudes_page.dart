import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:mensajeria/http/app_config.dart';

import 'package:mensajeria/src/widgets/session.dart';
import 'package:mensajeria/entities/users_solicitud.dart';

class Solicitudes extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Solicitudes> {
  final _session = Session();

  List<Solicitud> _notes = List<Solicitud>();
  List<Solicitud> _notes2 = List<Solicitud>();
  List<Solicitud> _notesForDisplay = List<Solicitud>();

  int contador,contador2;

  Future<List<Solicitud>> fetchNotes() async {
    String correo = await _session.get();

    var url = '${AppConfig.apiHost}/solicitudes.php';

    var response = await http.post(url, body: {"correo": correo});

    var notes = List<Solicitud>();

    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson) {
        notes.add(Solicitud.fromJson(noteJson));
      }
    }
    return notes;
  }

  void _addActivo(correoUsuario, canal, correoComunicador) async {
    var url = "${AppConfig.apiHost}/updateActivo.php";
    
    http.post(url, body: {
      "correo": correoUsuario,
      "canal": canal,
      "correo2": correoComunicador
    });
  }

  @override
  void initState() {
    fetchNotes().then((value) {
      setState(() {
        _notes.addAll(value);
        _notesForDisplay = _notes;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

     try{
      fetchNotes().then((value) {
        setState(() {
          _notes2.clear();
          _notes2.addAll(value);
          contador2 = _notes2.length;
        });
      });

      if(contador != contador2){
        fetchNotes().then((value) {
          setState(() {
            _notes.clear();
            _notesForDisplay.clear();
            _notes.addAll(value);
            _notesForDisplay = _notes;
            contador = _notes.length;
          });
        });
      }
    }catch (Exception) {}


    return Scaffold(
      body: ListView.builder(
        itemBuilder: (context, index) {
          return index == 0 ? _searchBar() : _listItem(index - 1);
        },
        itemCount: _notesForDisplay.length + 1,
      ),
    );
  }

  _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
           border: OutlineInputBorder(),
          hintText: 'Buscar...',
          suffixIcon: Padding(
              padding: EdgeInsets.all(15),
              child: Icon(Icons.search),
          )
        ),
        onChanged: (text) {
          text = text.toLowerCase();
          setState(() {
            _notesForDisplay = _notes.where((note) {
              var noteTitle = note.correousuario.toLowerCase();
              return noteTitle.contains(text);
            }).toList();
          });
        },
      ),
    );
  }

  _listItem(index) {
    return Container(
        height: 150,
        child: Card(
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Usuario: " + _notesForDisplay[index].correousuario,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                  "Canal: " + _notesForDisplay[index].canal,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: CupertinoButton(
                    color: Color.fromARGB(255, 185, 200, 195),
                    borderRadius: BorderRadius.circular(25),
                    onPressed: () {
                      String correoUsuario =
                          _notesForDisplay[index].correousuario;
                      String canal = _notesForDisplay[index].canal;
                      String correoComunicador =
                          _notesForDisplay[index].correocomunicador;
                      _addActivo(correoUsuario, canal, correoComunicador);
                    },
                    child: Text("Aceptar Solicitud",
                        style: TextStyle(
                            color: Color.fromARGB(255, 82, 99, 74),
                            fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          color: Color.fromARGB(255, 58, 116, 105),
        ));
  }
}
