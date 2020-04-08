import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:mensajeria/http/app_config.dart';
import 'package:mensajeria/src/widgets/session.dart';

class ChatChannelUser extends StatefulWidget {
  final name, rute, chatid, activo, propietario;

  ChatChannelUser(
      this.name, this.rute, this.chatid, this.propietario, this.activo,
      {Key key})
      : super(key: key);

  @override
  State createState() => new ChatChannelUserState();
}

class ChatChannelUserState extends State<ChatChannelUser> {
  final TextEditingController mensajeController = new TextEditingController();
  final _session = Session();

  //FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  List data = [];
  String canal;

  void getData() async {
    String correo = await _session.get();

    final response = await http.post('${AppConfig.apiHost}/getDataMensajes.php',
        body: {"canal": widget.name,"correo" : correo});
    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
      });
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.name),
          // actions: <Widget>[
          //   IconButton(
          //     icon: Icon(Icons.refresh),
          //     onPressed: () {
          //       setState(() {
          //         getData();
          //       });
          //     },
          //     tooltip: 'Recargar',
          //   ),
          //   IconButton(
          //     icon: Icon(Icons.cancel),
          //     onPressed: () {
          //       _mostrarAlertDejar(context);
          //     },
          //     tooltip: 'No recibir notificaciones',
          //   ),
          //   IconButton(
          //     icon: Icon(Icons.add_comment),
          //     onPressed: () {
          //       _mostrarAlertUnirse(context);
          //     },
          //     tooltip: 'Recibir notificaciones',
          //   ),
          // ],
        ),
        body: Column(
          children: <Widget>[
            new Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) => Container(
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        margin: const EdgeInsets.only(right: 8.0, left: 8.0),
                        child: CircleAvatar(
                          child: Image.asset('assets/images/chat.png'),
                        ),
                      ),
                      new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text(widget.name,
                              style: Theme.of(context).textTheme.subhead),
                          new Container(
                              margin: const EdgeInsets.only(top: 5.0),
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    data[index]['Mensaje'],
                                    textScaleFactor: 1.1,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5.0),
                                  ),
                                  Text(
                                    data[index]['Fecha'],
                                    textScaleFactor: 0.8,
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            new Divider(
              height: 1.0,
            ),
            new Container(
              alignment: AlignmentDirectional.bottomEnd,
              decoration: new BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
            ),
          ],
        ));
  }

  // void _mostrarAlertUnirse(BuildContext context) {
  //   showDialog(
  //       context: context,
  //       barrierDismissible: true,
  //       builder: (context) {
  //         return AlertDialog(
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(20.0)),
  //           title: Text('Canal'),
  //           content: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: <Widget>[
  //               Text('¿Desea recibir notificaciones?'),
  //               FlutterLogo(size: 100.0)
  //             ],
  //           ),
  //           actions: <Widget>[
  //             FlatButton(
  //               child: Text('No'),
  //               onPressed: () => Navigator.of(context).pop(),
  //             ),
  //             FlatButton(
  //               child: Text('Si'),
  //               onPressed: () {
  //                 _firebaseMessaging.subscribeToTopic("${widget.name}");
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //           ],
  //         );
  //       });
  // }

  // void _mostrarAlertDejar(BuildContext context) {
  //   showDialog(
  //       context: context,
  //       barrierDismissible: true,
  //       builder: (context) {
  //         return AlertDialog(
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(20.0)),
  //           title: Text('Canal'),
  //           content: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: <Widget>[
  //               Text('¿Desea dejar de recibir notificaciones?'),
  //               FlutterLogo(size: 100.0)
  //             ],
  //           ),
  //           actions: <Widget>[
  //             FlatButton(
  //               child: Text('No'),
  //               onPressed: () => Navigator.of(context).pop(),
  //             ),
  //             FlatButton(
  //               child: Text('Si'),
  //               onPressed: () {
  //                 _firebaseMessaging.unsubscribeFromTopic("${widget.name}");
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //           ],
  //         );
  //       });
  // }
}
