import 'package:flutter/material.dart';

import 'com_add_page.dart';
import 'com_delete_page.dart';


class MenuComPage extends StatefulWidget {
  final nombre;

  MenuComPage(this.nombre);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<MenuComPage>  with SingleTickerProviderStateMixin{
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  int _selectedPage = 0;

  List _pageOptions = [];

  @override
  void initState() {
    super.initState();
    _pageOptions = [
      ComDelete(widget.nombre),
      ComAdd(widget.nombre),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: this._scaffoldkey,
        body: _pageOptions[_selectedPage],
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Mis\nComunicadores',textAlign: TextAlign.center),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_add),
              title: Text('Otros\nComunicadores',textAlign: TextAlign.center),
            ),
          ],
          currentIndex: _selectedPage,
          selectedItemColor: Color.fromARGB(255, 49, 84, 74),
          onTap: (int index) {
            setState(() {
              _selectedPage = index;
            });
          },
        ));
  }
}
