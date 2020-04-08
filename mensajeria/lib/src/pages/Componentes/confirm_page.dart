// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';

// class ConfirmPage extends StatefulWidget {
//   List<String> seleccionados = List<String>();

//   ConfirmPage(this.seleccionados);

//   @override
//   _ConfirmPageState createState() => _ConfirmPageState();
// }

// class _ConfirmPageState extends State<ConfirmPage> {
//   final _formKey = GlobalKey<FormState>();
//   String user = "jona@gmail.com";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(centerTitle: true, title: Text('Confirmacion')),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Form(
//           key: _formKey,
//           child: Container(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 TextFormField(
//                   decoration: InputDecoration(hintText: 'Nombre del canal'),
//                   validator: (value) {
//                     if (value.isEmpty) {
//                       return 'Por favor ingrese el nombre del canal';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 20.0),
//                 Text('Integrantes:'),
//                 getTextWidgets(widget.seleccionados),
//                 SizedBox(height: 20.0),
//                 RaisedButton(
//                   onPressed: () {
//                     if (_formKey.currentState.validate()) {}
//                   },
//                   child: Text('Confirmar'),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget getTextWidgets(List<String> strings) {
//     List<Widget> list = new List<Widget>();
//     for (var i = 0; i < strings.length; i++) {
//       list.add(
//         Chip(
//             avatar: CircleAvatar(
//               backgroundColor: Colors.blue,
//               child: Icon(Icons.account_circle),
//             ),
//             backgroundColor: Colors.blue[100],
//             label: Text(strings[i])),
//       );
//     }
//     return new Wrap(
//         spacing: 10.0,
//         alignment: WrapAlignment.spaceEvenly,
//         direction: Axis.horizontal,
//         children: list);
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';

import 'package:mensajeria/api/auth_api.dart';
import 'package:mensajeria/src/pages/splash.dart';
import 'package:mensajeria/src/widgets/session.dart';
import 'package:mensajeria/src/widgets/responsive.dart';

class ConfirmPage extends StatefulWidget {
  final List<String> seleccionados;
  final tipo;

  ConfirmPage(this.seleccionados, this.tipo);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<ConfirmPage> {
  final _session = Session();
  final _authAPI = AuthAPI();
  final _formKey = GlobalKey<FormState>();
  final nombre = TextEditingController();
  final descripcion = TextEditingController();
  final enlace = TextEditingController();
  final idchannel = TextEditingController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  }

  _channel() async {
    String correo = await _session.get();

    idchannel.text = 'null';
    enlace.text = 'null';

    final isOk = await _authAPI.registerChanel(context,
        nombre: nombre.text,
        descripcion: descripcion.text,
        enlace: enlace.text,
        idchannel: idchannel.text,
        correo: correo,
        integrantes: widget.seleccionados.toString());

    if (isOk) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Splash()));
    }
  }

  _group() async {
    String correo = await _session.get();

    final isOk = await _authAPI.registerGroup(context,
        nombre: nombre.text,
        descripcion: descripcion.text,
        correo: correo,
        integrantes: widget.seleccionados.toString());

    if (isOk) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Splash()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final responsive = Responsive(context);

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: widget.tipo == "Channel"
                ? AssetImage("assets/nuevo_canal.png")
                : widget.tipo == "Group"
                    ? AssetImage('assets/nuevo_grupo.png')
                    : ("assets/nuevo_canal.png"),
            fit: BoxFit.fill),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            width: size.width,
            height: size.height,
            child: Stack(
              children: <Widget>[
                SingleChildScrollView(
                  child: Container(
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              SizedBox(height: responsive.hp(35)),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: 280,
                                    minWidth: 280,
                                  ),
                                  child: Form(
                                    key: _formKey,
                                    child: widget.tipo == "Channel"
                                        ? Column(
                                            children: <Widget>[
                                              TextFormField(
                                                inputFormatters: [
                                                  new WhitelistingTextInputFormatter(RegExp("[a-zA-ZñÑ ]")),
                                                ],
                                                decoration: InputDecoration(
                                                  suffixIcon: Icon(
                                                      Icons.add_comment,
                                                      color: Colors.white),
                                                  fillColor: Color.fromARGB(
                                                      255, 58, 116, 105),
                                                  filled: true,
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    58,
                                                                    116,
                                                                    105)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    255)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.red),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Colors.white),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                  ),
                                                  labelText: "Nombre del Canal",
                                                  hintStyle: TextStyle(
                                                      color: Colors.white70),
                                                  alignLabelWithHint: true,
                                                  labelStyle: TextStyle(
                                                      fontSize:
                                                          responsive.ip(1.8),
                                                      color: Colors.white70),
                                                  contentPadding:
                                                      EdgeInsets.only(left: 20),
                                                ),
                                                cursorColor: Colors.white,
                                                keyboardType:
                                                    TextInputType.text,
                                                style: TextStyle(
                                                    color: Colors.white),
                                                controller: nombre,
                                                validator: (String text) {
                                                  if (text.isEmpty) {
                                                    return "Campo Vacío";
                                                  }else if(text.startsWith(" ") || text.endsWith(" ")){
                                                    return "Sin espacios al Inicio o al Final";
                                                  }else{
                                                    return null;
                                                  }                                                 
                                                },
                                              ),
                                              SizedBox(
                                                  height: responsive.ip(3)),
                                              TextFormField(
                                                inputFormatters: [
                                                  new WhitelistingTextInputFormatter(RegExp("[a-zA-ZñÑ ]")),
                                                ],
                                                decoration: InputDecoration(
                                                  suffixIcon: Icon(
                                                      Icons.short_text,
                                                      color: Colors.white),
                                                  fillColor: Color.fromARGB(
                                                      255, 58, 116, 105),
                                                  filled: true,
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    58,
                                                                    116,
                                                                    105)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    255)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.red),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Colors.white),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                  ),
                                                  labelText: "Descripción",
                                                  hintStyle: TextStyle(
                                                      color: Colors.white70),
                                                  alignLabelWithHint: true,
                                                  labelStyle: TextStyle(
                                                      fontSize:
                                                          responsive.ip(1.8),
                                                      color: Colors.white70),
                                                  contentPadding:
                                                      EdgeInsets.only(left: 20),
                                                ),
                                                cursorColor: Colors.white,
                                                keyboardType:
                                                    TextInputType.text,
                                                style: TextStyle(
                                                    color: Colors.white),
                                                controller: descripcion,
                                                validator: (String text) {
                                                  if (text.isEmpty) {
                                                    return "Campo Vacío";
                                                  }else if(text.startsWith(" ") || text.endsWith(" ")){
                                                    return "Sin espacios al Inicio o al Final";
                                                  }else{
                                                    return null;
                                                  }                                                 
                                                },
                                              ),
                                              SizedBox(
                                                  height: responsive.ip(3)),
                                              // TextFormField(
                                              //   enabled: false,
                                              //   enableInteractiveSelection:
                                              //       false,
                                              //   focusNode: FocusNode(),
                                              //   decoration: InputDecoration(
                                              //     suffixIcon: Icon(Icons.link,
                                              //         color: Colors.white),
                                              //     fillColor: Color.fromARGB(
                                              //         255, 58, 116, 105),
                                              //     filled: true,
                                              //     enabledBorder:
                                              //         OutlineInputBorder(
                                              //       borderSide:
                                              //           const BorderSide(
                                              //               color:
                                              //                   Color.fromARGB(
                                              //                       255,
                                              //                       58,
                                              //                       116,
                                              //                       105)),
                                              //       borderRadius:
                                              //           BorderRadius.circular(
                                              //               25),
                                              //     ),
                                              //     focusedBorder:
                                              //         OutlineInputBorder(
                                              //       borderSide:
                                              //           const BorderSide(
                                              //               color:
                                              //                   Color.fromARGB(
                                              //                       255,
                                              //                       255,
                                              //                       255,
                                              //                       255)),
                                              //       borderRadius:
                                              //           BorderRadius.circular(
                                              //               25),
                                              //     ),
                                              //     errorBorder:
                                              //         OutlineInputBorder(
                                              //       borderSide:
                                              //           const BorderSide(
                                              //               color: Colors.red),
                                              //       borderRadius:
                                              //           BorderRadius.circular(
                                              //               25),
                                              //     ),
                                              //     focusedErrorBorder:
                                              //         OutlineInputBorder(
                                              //       borderSide:
                                              //           const BorderSide(
                                              //               color:
                                              //                   Colors.white),
                                              //       borderRadius:
                                              //           BorderRadius.circular(
                                              //               25),
                                              //     ),
                                              //     disabledBorder:
                                              //         OutlineInputBorder(
                                              //       borderSide:
                                              //           const BorderSide(
                                              //               color: Colors.red),
                                              //       borderRadius:
                                              //           BorderRadius.circular(
                                              //               25),
                                              //     ),
                                              //     labelText: "Enlace del Canal",
                                              //     hintStyle: TextStyle(
                                              //         color: Colors.white70),
                                              //     alignLabelWithHint: true,
                                              //     labelStyle: TextStyle(
                                              //         fontSize:
                                              //             responsive.ip(1.8),
                                              //         color: Colors.white70),
                                              //     contentPadding:
                                              //         EdgeInsets.only(left: 20),
                                              //   ),
                                              //   cursorColor: Colors.white,
                                              //   keyboardType:
                                              //       TextInputType.text,
                                              //   style: TextStyle(
                                              //       color: Colors.white),
                                              //   controller: enlace,
                                              //   // validator: (String text) {
                                              //   //   if (text.isNotEmpty) {
                                              //   //     return null;
                                              //   //   }
                                              //   //   return "Campo Vacío";
                                              //   // },
                                              // ),
                                              // SizedBox(
                                              //     height: responsive.ip(3)),
                                              // TextFormField(
                                              //   enabled: false,
                                              //   enableInteractiveSelection:
                                              //       false,
                                              //   focusNode: FocusNode(),
                                              //   decoration: InputDecoration(
                                              //     suffixIcon: Icon(
                                              //         Icons.phonelink_lock,
                                              //         color: Colors.white),
                                              //     fillColor: Color.fromARGB(
                                              //         255, 58, 116, 105),
                                              //     filled: true,
                                              //     enabledBorder:
                                              //         OutlineInputBorder(
                                              //       borderSide:
                                              //           const BorderSide(
                                              //               color:
                                              //                   Color.fromARGB(
                                              //                       255,
                                              //                       58,
                                              //                       116,
                                              //                       105)),
                                              //       borderRadius:
                                              //           BorderRadius.circular(
                                              //               25),
                                              //     ),
                                              //     focusedBorder:
                                              //         OutlineInputBorder(
                                              //       borderSide:
                                              //           const BorderSide(
                                              //               color:
                                              //                   Color.fromARGB(
                                              //                       255,
                                              //                       255,
                                              //                       255,
                                              //                       255)),
                                              //       borderRadius:
                                              //           BorderRadius.circular(
                                              //               25),
                                              //     ),
                                              //     errorBorder:
                                              //         OutlineInputBorder(
                                              //       borderSide:
                                              //           const BorderSide(
                                              //               color: Colors.red),
                                              //       borderRadius:
                                              //           BorderRadius.circular(
                                              //               25),
                                              //     ),
                                              //     focusedErrorBorder:
                                              //         OutlineInputBorder(
                                              //       borderSide:
                                              //           const BorderSide(
                                              //               color:
                                              //                   Colors.white),
                                              //       borderRadius:
                                              //           BorderRadius.circular(
                                              //               25),
                                              //     ),
                                              //     disabledBorder:
                                              //         OutlineInputBorder(
                                              //       borderSide:
                                              //           const BorderSide(
                                              //               color: Colors.red),
                                              //       borderRadius:
                                              //           BorderRadius.circular(
                                              //               25),
                                              //     ),
                                              //     labelText: "Id del Canal",
                                              //     hintStyle: TextStyle(
                                              //         color: Colors.white70),
                                              //     alignLabelWithHint: true,
                                              //     labelStyle: TextStyle(
                                              //         fontSize:
                                              //             responsive.ip(1.8),
                                              //         color: Colors.white70),
                                              //     contentPadding:
                                              //         EdgeInsets.only(left: 20),
                                              //   ),
                                              //   cursorColor: Colors.white,
                                              //   keyboardType:
                                              //       TextInputType.text,
                                              //   style: TextStyle(
                                              //       color: Colors.white),
                                              //   controller: idchannel,
                                              //   // validator: (String text) {
                                              //   //   if (text.isNotEmpty) {
                                              //   //     return null;
                                              //   //   }
                                              //   //   return "Campo Vacío";
                                              //   // },
                                              // ),
                                              SizedBox(
                                                  height: responsive.hp(1.5)),
                                            ],
                                          )
                                        : widget.tipo == "Group"
                                            ? Column(
                                                children: <Widget>[
                                                  TextFormField(
                                                    inputFormatters: [
                                                      new WhitelistingTextInputFormatter(RegExp("[a-zA-ZñÑ ]")),
                                                    ],
                                                    decoration: InputDecoration(
                                                      suffixIcon: Icon(
                                                          Icons.add_comment,
                                                          color: Colors.white),
                                                      fillColor: Color.fromARGB(
                                                          255, 58, 116, 105),
                                                      filled: true,
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        58,
                                                                        116,
                                                                        105)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        255,
                                                                        255,
                                                                        255)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                      ),
                                                      errorBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color:
                                                                    Colors.red),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                      ),
                                                      focusedErrorBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Colors
                                                                    .white),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                      ),
                                                      labelText:
                                                          "Nombre del Grupo",
                                                      hintStyle: TextStyle(
                                                          color:
                                                              Colors.white70),
                                                      alignLabelWithHint: true,
                                                      labelStyle: TextStyle(
                                                          fontSize: responsive
                                                              .ip(1.8),
                                                          color:
                                                              Colors.white70),
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              left: 20),
                                                    ),
                                                    cursorColor: Colors.white,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                    controller: nombre,
                                                    validator: (String text) {
                                                      if (text.isEmpty) {
                                                        return "Campo Vacío";
                                                      }else if(text.startsWith(" ") || text.endsWith(" ")){
                                                        return "Sin espacios al Inicio o al Final";
                                                      }else{
                                                        return null;
                                                      }                                                 
                                                    },
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          responsive.hp(1.5)),
                                                  TextFormField(
                                                    inputFormatters: [
                                                      new WhitelistingTextInputFormatter(RegExp("[a-zA-ZñÑ ]")),
                                                    ],
                                                    decoration: InputDecoration(
                                                      suffixIcon: Icon(
                                                          Icons.add_comment,
                                                          color: Colors.white),
                                                      fillColor: Color.fromARGB(
                                                          255, 58, 116, 105),
                                                      filled: true,
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        58,
                                                                        116,
                                                                        105)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        255,
                                                                        255,
                                                                        255)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                      ),
                                                      errorBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color:
                                                                    Colors.red),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                      ),
                                                      focusedErrorBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Colors
                                                                    .white),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                      ),
                                                      labelText:
                                                          "Descripcion del Grupo",
                                                      hintStyle: TextStyle(
                                                          color:
                                                              Colors.white70),
                                                      alignLabelWithHint: true,
                                                      labelStyle: TextStyle(
                                                          fontSize: responsive
                                                              .ip(1.8),
                                                          color:
                                                              Colors.white70),
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              left: 20),
                                                    ),
                                                    cursorColor: Colors.white,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                    controller: descripcion,
                                                    validator: (String text) {
                                                      if (text.isEmpty) {
                                                        return "Campo Vacío";
                                                      }else if(text.startsWith(" ") || text.endsWith(" ")){
                                                        return "Sin espacios al Inicio o al Final";
                                                      }else{
                                                        return null;
                                                      }                                                 
                                                    },
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          responsive.hp(1.5)),
                                                ],
                                              )
                                            : Text("Cargando Widgets"),
                                  )),
                              SizedBox(height: responsive.ip(2)),
                              Text(
                                'Integrantes:\n',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              getTextWidgets(widget.seleccionados),
                              SizedBox(height: responsive.ip(5)),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: 260,
                                  minWidth: 260,
                                ),
                                child: CupertinoButton(
                                    padding: EdgeInsets.symmetric(
                                        vertical: responsive.ip(1.5)),
                                    color: Color.fromARGB(255, 185, 200, 195),
                                    borderRadius: BorderRadius.circular(25),
                                    onPressed: () {
                                      if (_formKey.currentState.validate()) {
                                        widget.tipo == "Channel"
                                            ? _channel()
                                            : widget.tipo == "Group"
                                                ? _group()
                                                : Text("Cargando");
                                      }
                                    },
                                    child: widget.tipo == "Channel"
                                        ? Text("Crear Canal",
                                            style: TextStyle(
                                                fontSize: responsive.ip(2.4),
                                                color: Color.fromARGB(
                                                    255, 34, 71, 16)))
                                        : widget.tipo == "Group"
                                            ? Text("Crear Grupo",
                                                style: TextStyle(
                                                    fontSize:
                                                        responsive.ip(2.4),
                                                    color: Color.fromARGB(
                                                        255, 34, 71, 16)))
                                            : Text("Cargando Widget",
                                                style: TextStyle(
                                                    fontSize:
                                                        responsive.ip(2.4),
                                                    color: Color.fromARGB(
                                                        255, 34, 71, 16)))),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                              ),
                              SizedBox(height: responsive.hp(15)),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 15,
                  top: 5,
                  child: SafeArea(
                    child: CupertinoButton(
                      padding: EdgeInsets.all(10),
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.black12,
                      onPressed: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getTextWidgets(List<String> strings) {
    List<Widget> list = new List<Widget>();
    for (var i = 0; i < strings.length; i++) {
      list.add(
        Chip(
          avatar: CircleAvatar(
            backgroundColor: Colors.blue,
            child: Icon(Icons.account_circle),
          ),
          backgroundColor: Colors.white,
          label: Text(
            strings[i],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
    return new Wrap(
        spacing: 10.0,
        alignment: WrapAlignment.spaceEvenly,
        direction: Axis.horizontal,
        children: list);
  }
}
