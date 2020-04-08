import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:mensajeria/http/app_config.dart';
import 'package:mensajeria/entities/channel.dart';
import 'package:mensajeria/src/widgets/session.dart';
import 'package:mensajeria/src/pages/ChatScreen/chatscreen_channel.dart';

class ChannelNotIn extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<ChannelNotIn> {
  final _session = Session();

  List<Channel> _notes = List<Channel>();
  List<Channel> _notesForDisplay = List<Channel>();

  Future<List<Channel>> fetchNotes() async {
    String correo = await _session.get();

    var url = '${AppConfig.apiHost}/getChaNoIn.php';

    var response = await http.post(url, body: {"email": correo});

    var notes = List<Channel>();

    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson) {
        notes.add(Channel.fromJson(noteJson));
        print(notes);
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
                      builder: (context) => ChatChannel(
                          _notesForDisplay[index].nombre,
                          _notesForDisplay[index].enlace,
                          _notesForDisplay[index].idchat,
                          _notesForDisplay[index].propietario,
                          "0")));
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
