import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:mensajeria/http/app_config.dart';

import 'package:mensajeria/entities/miembros.dart';
import 'package:mensajeria/src/widgets/session.dart';
import 'package:mensajeria/src/pages/Administrador/admin_page.dart';
import 'package:mensajeria/src/pages/Comunicador/comunicador_page.dart';

class ComAdd extends StatefulWidget {
  final name;

  ComAdd(this.name);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<ComAdd> {
  final _session = Session();

  String canal, correo, parsed;

  List data = [];

  List<Miembro> _notes = List<Miembro>();
  List<Miembro> _notesForDisplay = List<Miembro>();

  Future<List<Miembro>> fetchNotes() async {
    canal = widget.name;

    var url = '${AppConfig.apiHost}/getComNot.php';

    var response = await http.post(url, body: {"canal": canal});

    var notes = List<Miembro>();

    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson) {
        notes.add(Miembro.fromJson(noteJson));
      }
    }
    return notes;
  }

  void getNivel() async {
    String correo = await _session.get();
    final response =
        await http.post('${AppConfig.apiHost}/login_storage.php', body: {
      "email": correo,
    });
    parsed = jsonDecode(response.body);
  }

  void _addCanal(canalP, usuarioP) async {
    var url = "${AppConfig.apiHost}/addCanal.php";

    http.post(url, body: {"canal": canalP, "usuario": usuarioP});
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
    getNivel();
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (context, index) {
          return index == 0 ? _searchBar() : _listItem(index - 1);
        },
        itemCount: _notesForDisplay.length + 1,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (parsed == '0') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (BuildContext context) => AdminPage()),
            );
          }
          if (parsed == '1') {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => ComunicadorPage()),
            );
          }
        },
        tooltip: "Crear Grupo",
        backgroundColor: Color.fromARGB(255, 6, 68, 48),
        child: Icon(
          Icons.arrow_back,
          color: Color.fromARGB(255, 255, 255, 255),
          size: 25.0,
        ),
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
              var noteTitle = note.usuario.toLowerCase();
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
                  "Usuario: " + _notesForDisplay[index].usuario,
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
                      _addCanal(canal, _notesForDisplay[index].usuario);
                      fetchNotes().then((value) {
                        setState(() {
                          _notes.clear();
                          _notesForDisplay.clear();
                          _notes.addAll(value);
                          _notesForDisplay = _notes;
                        });
                      });
                    },
                    child: Text("Agregar al Canal",
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
