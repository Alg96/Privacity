import 'package:flutter/material.dart';
import 'package:mensajeria/src/pages/Comunicador/channel_in_page.dart';
import 'package:mensajeria/src/pages/Comunicador/channel_group_page.dart';

class MenuChannelPage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<MenuChannelPage> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  int _selectedPage = 0;
  final _pageOptions = [
    ChannelGroup("Channel"),
    ChannelIn()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: this._scaffoldkey,
        body: _pageOptions[_selectedPage],
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.supervisor_account),
              title: Text('Mis canales'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              title: Text('Otros canales'),
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
