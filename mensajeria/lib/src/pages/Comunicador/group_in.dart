import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

import 'package:mensajeria/entities/group.dart';
import 'package:mensajeria/http/app_config.dart';
import 'package:mensajeria/src/widgets/session.dart';
import 'package:mensajeria/src/pages/ChatScreen/chatscreen_group.dart';

class GroupIn extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<GroupIn> {
  final _session = Session();

  List<Group> _notes = List<Group>();
  List<Group> _notesForDisplay = List<Group>();

  Future<List<Group>> fetchNotes() async {
    String correo = await _session.get();

    var response = await http
        .post("${AppConfig.apiHost}/getGroupIn.php", body: {"email": correo});

    var notes = List<Group>();

    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson) {
        notes.add(Group.fromJson(noteJson));
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
              var noteTitle = note.nombre.toLowerCase();
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
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatGroup(
                          _notesForDisplay[index].nombre,
                          _notesForDisplay[index].descripcion,
                          "1",
                          _notesForDisplay[index].propietario)));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                Text(
                  _notesForDisplay[index].nombre,
                  style: TextStyle(
                      fontSize: 22,
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
