import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mensajeria/entities/group.dart';
import 'package:mensajeria/http/app_config.dart';
import 'package:mensajeria/entities/channel.dart';
import 'package:mensajeria/src/widgets/session.dart';
import 'package:mensajeria/src/pages/Componentes/register_channel_group.dart';
import 'package:mensajeria/src/pages/Componentes/config_users_page.dart';

class ChannelGroup extends StatefulWidget {
  final tipo;

  ChannelGroup(this.tipo);

  @override
  State createState() => _ChannelGroupState();
}

class _ChannelGroupState extends State<ChannelGroup> {
  String nombre;
  int contadorChannel,contadorChannel2,contadorGroup,contadorGroup2;

  final _session = Session();

  List<Channel> _notesChannel = List<Channel>();
  List<Channel> _notesChannel2 = List<Channel>();
  List<Channel> _notesForDisplayChannel = List<Channel>();

  List<Group> _notesGroup = List<Group>();
  List<Group> _notesGroup2 = List<Group>();
  List<Group> _notesForDisplayGroup = List<Group>();

  Future<List<Channel>> fetchNotesChannel() async {
    String correo = await _session.get();

    var url = '${AppConfig.apiHost}/query_channel.php';

    var response = await http.post(url, body: {"email": correo});

    var notes = List<Channel>();

    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson) {
        notes.add(Channel.fromJson(noteJson));
      }
    }
    return notes;
  }

  Future<List<Group>> fetchNotesGroup() async {
    String correo = await _session.get();

    var url = '${AppConfig.apiHost}/query_group.php';

    var response = await http.post(url, body: {"email": correo});

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
    try {
      fetchNotesChannel().then((value) {
        setState(() {
          _notesChannel.addAll(value);
          _notesForDisplayChannel = _notesChannel;
        });
      });
      fetchNotesGroup().then((value) {
        setState(() {
          _notesGroup.addAll(value);
          _notesForDisplayGroup = _notesGroup;
        });
      });
    } catch (Exception) {}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    try{
      if(widget.tipo == 'Group'){ 
        fetchNotesGroup().then((value) {
          setState(() {
            _notesGroup2.clear();
            _notesGroup2.addAll(value);
            contadorGroup2 = _notesGroup2.length;
          });
        });

        if(contadorGroup != contadorGroup2){
          fetchNotesGroup().then((value) {
            setState(() {
              _notesGroup.clear();
              _notesForDisplayGroup.clear();
              _notesGroup.addAll(value);
              _notesForDisplayGroup = _notesGroup;
              contadorGroup = _notesGroup.length;
            });
          });
        }
      }
      if(widget.tipo == 'Channel'){ 
        fetchNotesChannel().then((value) {
          setState(() {
            _notesChannel2.clear();
            _notesChannel2.addAll(value);
            contadorChannel2 = _notesChannel2.length;
          });
        });

        if(contadorChannel != contadorChannel2){
          fetchNotesChannel().then((value) {
            setState(() {
              _notesChannel.clear();
              _notesForDisplayChannel.clear();
              _notesChannel.addAll(value);
              _notesForDisplayChannel = _notesChannel;
              contadorChannel = _notesChannel.length;
            });
          });
        }
      }
    }catch (Exception) {}
   
    return Scaffold(
      body: widget.tipo == 'Channel'
          ? ListView.builder(
              itemCount: _notesForDisplayChannel.length + 1,
              itemBuilder: (context, index) {
                return index == 0 ? _searchBar() : _listItem(index - 1);
              },
            )
          : widget.tipo == 'Group'
              ? ListView.builder(
                  itemCount: _notesForDisplayGroup.length + 1,
                  itemBuilder: (context, index) {
                    return index == 0 ? _searchBar() : _listItem(index - 1);
                  },
                )
              : CircularProgressIndicator(
                  backgroundColor: Colors.blue,
                  strokeWidth: 10.0,
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.tipo == 'Channel'
              ? Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new RegisterCG("Channel"),
                  ),
                )
              : widget.tipo == 'Group'
                  ? Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => new RegisterCG("Group"),
                      ),
                    )
                  : CircularProgressIndicator(
                      backgroundColor: Colors.blue,
                      strokeWidth: 10.0,
                    );
        },
        tooltip: "Crear Canal",
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
        onTap: (){

        },
        onChanged: (text) {
          text = text.toLowerCase();
          setState(() {
            widget.tipo == 'Channel'
                ? _notesForDisplayChannel = _notesChannel.where((note) {
                    var noteTitle = note.nombre.toLowerCase();
                    return noteTitle.contains(text);
                  }).toList()
                : widget.tipo == 'Group'
                    ? _notesForDisplayGroup = _notesGroup.where((note) {
                        var noteTitle = note.nombre.toLowerCase();
                        return noteTitle.contains(text);
                      }).toList()
                    : CircularProgressIndicator(
                        backgroundColor: Colors.blue,
                        strokeWidth: 10.0,
                      );
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
              widget.tipo == 'Channel'
                  ? nombre = _notesForDisplayChannel[index].nombre
                  : widget.tipo == 'Group'
                      ? nombre = _notesForDisplayGroup[index].nombre
                      : nombre = "";

              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ConfigUsers(nombre)));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                widget.tipo == 'Channel'
                    ? Text(
                        _notesForDisplayChannel[index].nombre,
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )
                    : widget.tipo == 'Group'
                        ? Text(
                            _notesForDisplayGroup[index].nombre,
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )
                        : CircularProgressIndicator(
                            backgroundColor: Colors.blue,
                            strokeWidth: 10.0,
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
