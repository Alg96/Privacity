import 'package:flutter/material.dart';
import 'package:mensajeria/src/pages/Componentes/user_add_page.dart';
import 'package:mensajeria/src/pages/Componentes/user_delete_page.dart';


class MenuUsersPage extends StatefulWidget {
  final nombre;

  MenuUsersPage(this.nombre);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<MenuUsersPage>  with SingleTickerProviderStateMixin{
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  int _selectedPage = 0;

  List _pageOptions = [];

  @override
  void initState() {
    super.initState();
    _pageOptions = [
      UserDelete(widget.nombre),
      UserAdd(widget.nombre),
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
              title: Text('Mis\nUsuarios',textAlign: TextAlign.center),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_add),
              title: Text('Otros\nUsuarios',textAlign: TextAlign.center,),
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
