import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:mensajeria/http/app_config.dart';
import 'package:mensajeria/entities/comunicador.dart';
import 'package:mensajeria/src/pages/Componentes/register_com.dart';

class Comunicadores extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Comunicadores> {
  List<Comunicador> _notes = List<Comunicador>();
  List<Comunicador> _notes2 = List<Comunicador>();
  List<Comunicador> _notesForDisplay = List<Comunicador>();

  int contador,contador2;

  Future<List<Comunicador>> fetchNotes() async {
    var url = '${AppConfig.apiHost}/getComunicador.php';

    var response = await http.get(url);

    var notes = List<Comunicador>();

    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson) {
        notes.add(Comunicador.fromJson(noteJson));
      }
    }
    return notes;
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => RegisterCom()));
        },
        tooltip: "Crear Comunicador",
        backgroundColor: Color.fromARGB(255, 6, 68, 48),
        child: Icon(
          Icons.add,
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
        height: 100,
        child: Card(
          child: InkWell(
            onTap: () {},
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
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
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
