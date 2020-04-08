import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

import 'package:mensajeria/api/auth_api.dart';
import 'package:mensajeria/http/app_config.dart';
import 'package:mensajeria/src/widgets/session.dart';
import 'package:mensajeria/src/providers/push_notifications_provider.dart';

class ChatChannel extends StatefulWidget {
  final name, rute, chatid, activo, propietario;

  ChatChannel(this.name, this.rute, this.chatid, this.propietario, this.activo,
      {Key key})
      : super(key: key);

  @override
  ChatChannelState createState() => ChatChannelState();
}

class ChatChannelState extends State<ChatChannel> {
  final pushProvider = PushNotificationProvider();
  final _authAPI = AuthAPI();
  final _session = Session();
  final TextEditingController mensajetelegramController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String canal,validate;
  int count = 0;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  List data = [];
  ScrollController _scrollController = ScrollController();
  TextEditingController mensajeController = new TextEditingController();

  _addActivo() async {
    String correo = await _session.get();

    final isOk = await _authAPI.solicitud(context,
        correo: correo, canal: widget.name, propietario: widget.propietario);

    if (isOk) {
      Navigator.pop(context);
    }
  }

  Future _mensajeCanal(chatId, text) async {
    final response = await http.get(
        'https://api.telegram.org/bot873547369:AAGLWCoJ36c8YAuL_p63Bl2RMUBP5JYZeVU/sendMessage?chat_id=$chatId&text=$text');
    if (response.statusCode == 200) {
      json.decode(response.body);
    } else {}
  }

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

  void _addMensaje() {
    var url = "${AppConfig.apiHost}/addMensaje.php";

    http.post(url, body: {
      "mensaje": mensajeController.text,
      "canal": canal,
    });
  }

  @override
  void initState() {
    getData();
    Timer(
        Duration(milliseconds: 1000),
        () => _scrollController
            .jumpTo(_scrollController.position.maxScrollExtent));
    super.initState();
  }

  @override
  void dispose() {
    mensajetelegramController.dispose();
    super.dispose();
    _scrollController.dispose();
  }

  Widget _chatEnvironment() {
    return IconTheme(
      data: new IconThemeData(color: Colors.blue),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Form(
          key: _formKey,
          child: new Row(
            children: <Widget>[
              new Flexible(
                child: new TextFormField(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(100),
                    BlacklistingTextInputFormatter(
                      RegExp(
                        r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'
                      )),
                  ],
                  autovalidate: true,   
                  decoration: new InputDecoration.collapsed(
                      hintText: "Mandar mensaje a ${widget.name}"),
                  controller: mensajetelegramController,
                  validator: (String text){
                      if (text.isNotEmpty) {   
                        validate = mensajetelegramController.text;
                      }
                      if (text.isEmpty){
                        validate = mensajetelegramController.text;
                      }  
                      return null;     
                    },
                ),
              ),           
              validate == null || validate.isEmpty || validate.endsWith(' ') || validate.startsWith(' ') ?
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: new IconButton(
                      icon: new Icon(Icons.block,color: Colors.red),
                      iconSize: 30,
                      onPressed: () {
                        Toast.show("No puedes mandar mensajes vacíos\n o con espacios al inicio y al final.", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
                        // if(_formKey.currentState.validate()){                 
                        //   channel = widget.name;
                        //   _addMensaje();
                        //   mensajeController.clear();
                        //   Timer(
                        //       Duration(milliseconds: 1000),
                        //       () => _scrollController.jumpTo(
                        //           _scrollController.position.maxScrollExtent));  
                        // }                 
                      }),
                ) : Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: new IconButton(
                    icon: new Icon(Icons.send,color: Colors.green),
                    iconSize: 30,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        canal = widget.name;
                        mensajeController.text = mensajetelegramController.text;
                        _mensajeCanal(
                            widget.chatid, mensajetelegramController.text);
                        pushProvider.sendAndRetrieveMessage(
                            mensajeController.text, widget.name);
                        _addMensaje();
                        mensajetelegramController.clear();
                        Timer(
                            Duration(milliseconds: 1000),
                            () => _scrollController.jumpTo(
                                _scrollController.position.maxScrollExtent));
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    getData();
    if (count < data.length) {
      Timer(
          Duration(milliseconds: 1000),
          () => _scrollController
              .jumpTo(_scrollController.position.maxScrollExtent));
    }
    count = data.length;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.name),
        ),
        body: Column(
          children: <Widget>[
            new Expanded(
              child: widget.activo == "1"
                  ? ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) =>
                          Container(
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Container(
                              margin: const EdgeInsets.only(
                                  right: 8.0, left: 8.0, top: 5.0),
                              child: CircleAvatar(
                                child: Image.asset('assets/images/chat.png'),
                                maxRadius: 26.0,
                              ),
                            ),
                            new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Text(widget.name,
                                      style:
                                          Theme.of(context).textTheme.subhead),
                                  new Container(
                                      margin: const EdgeInsets.only(top: 5.0),
                                      child: new Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Linkify(
                                            onOpen: (link) async {
                                              if (await canLaunch(link.url)) {
                                                await launch(link.url);
                                              } else {
                                                throw 'Could not launch $link';
                                              }
                                            },
                                            text: data[index]['Mensaje'],
                                            textScaleFactor: 1.1,
                                            //style: TextStyle(color: Colors.yellow),
                                            linkStyle: TextStyle(
                                                color: Colors.blueAccent),
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
                                ]),
                          ],
                        ),
                      ),
                    )
                  : Center(
                      child: CupertinoButton(
                        color: Color.fromARGB(255, 185, 200, 195),
                        borderRadius: BorderRadius.circular(25),
                        onPressed: () {
                          _addActivo();
                          //Navigator.pop(context);
                        },
                        child: Text("Enviar Solicitud",
                            style: TextStyle(
                                color: Color.fromARGB(255, 82, 99, 74),
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
            ),
            new Divider(
              height: 1.0,
            ),
            widget.activo == "1"
                ? new Container(
                    alignment: AlignmentDirectional.bottomEnd,
                    decoration: new BoxDecoration(
                      color: Theme.of(context).cardColor,
                    ),
                    child: _chatEnvironment(),
                  )
                : Text("")
          ],
        ));
  }
}
