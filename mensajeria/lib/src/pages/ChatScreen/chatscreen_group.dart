import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

import 'package:mensajeria/http/app_config.dart';
import 'package:mensajeria/src/widgets/session.dart';

class ChatGroup extends StatefulWidget {
  final name, descripcion, activo, propietario;

  ChatGroup(this.name, this.descripcion, this.activo, this.propietario,
      {Key key})
      : super(key: key);

  @override
  State createState() => new ChatGroupState();
}

class ChatGroupState extends State<ChatGroup> {
  final _session = Session();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController mensajeController = new TextEditingController();
  
  ScrollController _scrollController = ScrollController();
  String correoId,channel,validate;
  List data = [];
  int count = 0;

  correo() async {
    String correo = await _session.get();
    correoId = correo;
  }

  void getData() async {
     String correo = await _session.get();

    final response = await http.post(
        '${AppConfig.apiHost}/getDataMensajesGrupo.php',
        body: {"canal": widget.name,"correo" : correo});
    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
      });
    }
  }

  void _addActivo() async {
    String correo = await _session.get();
    var url = "${AppConfig.apiHost}/updateActivo.php";

    http.post(url, body: {
      "correo": correo,
      "canal": widget.name,
      "correo2": widget.propietario
    });
  }

  void _addMensaje() {
    var url = "${AppConfig.apiHost}/addMensajeGrupo.php";

    http.post(url, body: {
      "mensaje": mensajeController.text,
      "canal": channel,
      "correo": correoId
    });
  }

  @override
  void initState() {
    Timer(
        Duration(milliseconds: 1000),
        () => _scrollController
            .jumpTo(_scrollController.position.maxScrollExtent));

    correo();
    super.initState();
  }

  @override
  void dispose() {
    mensajeController.dispose();
    _scrollController.dispose();
    super.dispose();
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
                child: TextFormField(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(100),
                    BlacklistingTextInputFormatter(
                      RegExp(
                        r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'
                      )
                    ),
                  ],
                  decoration: InputDecoration.collapsed(
                    hintText: "Mandar mensaje a ${widget.name}",
                  ),          
                  autovalidate: true,          
                  controller: mensajeController,
                  validator: (String text){
                    if (text.isNotEmpty) {   
                      validate = mensajeController.text;
                    }
                    if (text.isEmpty){
                      validate = mensajeController.text;
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
                    if(_formKey.currentState.validate()){                 
                      channel = widget.name;
                      _addMensaje();
                      mensajeController.clear();
                      Timer(
                          Duration(milliseconds: 1000),
                          () => _scrollController.jumpTo(
                              _scrollController.position.maxScrollExtent));  
                    }                 
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Future<Null> _onRefresh() {
  //   Completer<Null> completer = new Completer<Null>();
  //   Timer timer = new Timer(new Duration(seconds: 2), () {
  //     completer.complete();
  //     getData();
  //   });
  //   return completer.future;
  // }

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
    bool isMe;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.name),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: new RefreshIndicator(
                child: widget.activo == "1"
                    ? ListView.builder(
                        controller: _scrollController,
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          isMe = data[index]['Correo'] == correoId;
                          var correo = data[index]['Correo'];
                          List<String> correoSD = correo.split("@");

                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Wrap(
                              alignment: isMe
                                  ? WrapAlignment.end
                                  : WrapAlignment.start,
                              children: <Widget>[
                                ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth: 300),
                                  child: Container(
                                      margin: EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                      ),
                                      padding: EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                          color: isMe
                                              ? Color.fromARGB(
                                                  255, 58, 116, 105)
                                              : Color.fromARGB(
                                                  255, 185, 200, 195),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          isMe
                                              ? SizedBox(width: 0)
                                              : Padding(
                                                  child: Text(
                                                    correoSD[0],
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.only(
                                                      bottom: 5),
                                                ),
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
                                            linkStyle: TextStyle(
                                                color: Colors.lightBlue),
                                            style: TextStyle(
                                                color: isMe
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15.0),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            data[index]['Fecha'],
                                            style: TextStyle(
                                              color: isMe
                                                  ? Colors.white70
                                                  : Colors.black54,
                                              fontStyle: FontStyle.normal,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        ],
                                      )),
                                )
                              ],
                            ),
                          );
                        },
                      )
                    : Center(
                        child: CupertinoButton(
                          color: Color.fromARGB(255, 185, 200, 195),
                          borderRadius: BorderRadius.circular(25),
                          onPressed: () {
                            _addActivo();
                            Navigator.pop(context);
                          },
                          child: Text("Solicitud",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 82, 99, 74),
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                onRefresh: () async {},
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
                : Text(""),
          ],
        ));
  }
}
