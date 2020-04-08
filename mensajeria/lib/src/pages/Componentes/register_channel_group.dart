import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'confirm_page.dart';
import 'package:toast/toast.dart';
import 'package:mensajeria/http/app_config.dart';
import 'package:mensajeria/entities/usuarios.dart';


class RegisterCG extends StatefulWidget {
  final tipo;

  RegisterCG(this.tipo);

  @override
  _RegisterCGState createState() => _RegisterCGState();
}

class _RegisterCGState extends State<RegisterCG> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  List<Usuarios> _users = List<Usuarios>();
  List<Usuarios> _usersForDisplay = List<Usuarios>();
  List<String> seleccionados = List<String>();


  Future<List<Usuarios>> fetchNotes() async {
    String url = "${AppConfig.apiHost}/getUsuarios.php";

    var response = await http.get(url);

    var notes = List<Usuarios>();

    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson) {
        notes.add(Usuarios.fromJson(noteJson));
      }
    }
    return notes;
  }

  @override
  void initState() {
    fetchNotes().then((value) {
      setState(() {
        _users.addAll(value);
        _usersForDisplay = _users;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

      return Scaffold(
        key: this._scaffoldkey,
        appBar:
            AppBar(centerTitle: true, title: Text('Seleccion de integrantes')),
        body: Column(
          children: <Widget>[
            Expanded(
              child: _list(),
            ),                              
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.grey,
              child: getTextWidgets(seleccionados),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              if(seleccionados.length != 0){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ConfirmPage(seleccionados,widget.tipo)));
              } else {
                Toast.show("Selecciona al menos un integrante", context,
                    duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
              }
            },
            backgroundColor: Color.fromARGB(255, 6, 68, 48),
            child: Icon(
              Icons.navigate_next,
              color: Color.fromARGB(255, 255, 255, 255),)),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,   
    );
  }

  _list() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return index == 0 ? _searchBar() : _listItem(index - 1);
      },
      itemCount: _usersForDisplay.length + 1,
    );
  }

  _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextField(
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Buscar...',
            suffixIcon: Padding(
              padding: EdgeInsets.all(15),
              child: Icon(Icons.search),
            )),
        onChanged: (text) {
          text = text.toLowerCase();
          setState(() {
            _usersForDisplay = _users.where((note) {
              var noteTitle = note.usuario.toLowerCase();
              return noteTitle.contains(text);
            }).toList();
          });
        },
      ),
    );
  }

  int check(String data) {
    if (seleccionados.contains(data)) {
      return 1;
    } else {
      return 0;
    }
  }

  _listItem(index) {
    return Container(
        child: Card(
      child: InkWell(
        onTap: () {
          setState(() {
            if (check(_usersForDisplay[index].usuario) == 0) {
              seleccionados.add(_usersForDisplay[index].usuario);
            }
          });
        },
        child: Container(
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.card_membership),
                title: Text(_usersForDisplay[index].usuario)
                //subtitle: Text(_usersForDisplay[index].correo),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget getTextWidgets(List<String> strings) {
    List<Widget> list = new List<Widget>();
    for (var i = 0; i < strings.length; i++) {
      list.add(InkWell(
        onTap: () {
          setState(() {
            strings.removeAt(i);
          });
        },
        child: Chip(
            avatar: CircleAvatar(
              child: Icon(Icons.account_circle),
            ),
            label: Text(strings[i])),
      ));
    }
    return new Wrap(
        alignment: WrapAlignment.spaceEvenly,
        direction: Axis.horizontal,
        children: list);
  }

}

