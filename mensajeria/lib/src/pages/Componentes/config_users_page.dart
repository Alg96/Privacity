import 'package:flutter/material.dart';

import 'package:mensajeria/src/pages/Componentes/menu_com_page.dart';
import 'package:mensajeria/src/pages/Componentes/menu_users_page.dart';

class ConfigUsers extends StatefulWidget {
  final nombre;
  ConfigUsers(this.nombre);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<ConfigUsers> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: AppBarTheme(
        color: Color.fromARGB(255, 49, 84, 74),
      )),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                    child: Text(
                      'Usuarios',
                      //textScaleFactor: 0.9,
                    ),
                    icon: Icon(Icons.person)),
                Tab(
                    child: Text(
                      'Comunicadores',
                      //textScaleFactor: 0.8,
                    ),
                    icon: Icon(Icons.person)),
              ],
            ),
            title: Text("Usuarios"),
          ),
          body: TabBarView(
            children: [
              MenuUsersPage(widget.nombre),
              MenuComPage(widget.nombre),
            ],
          ),
        ),
      ),
    );
  }
}
