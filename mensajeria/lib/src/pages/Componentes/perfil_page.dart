import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:mensajeria/api/auth_api.dart';
import 'package:mensajeria/http/app_config.dart';
import 'package:mensajeria/src/pages/splash.dart';
import 'package:mensajeria/src/widgets/session.dart';
import 'package:mensajeria/src/widgets/responsive.dart';
import 'package:mensajeria/src/pages/Usuario/usuario_page.dart';
import 'package:mensajeria/src/pages/Administrador/admin_page.dart';
import 'package:mensajeria/src/pages/Comunicador/comunicador_page.dart';

class PerfilPage extends StatefulWidget {
  final tipoUsuario;

  PerfilPage(this.tipoUsuario);

  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final _session = Session();
  final _authAPI = AuthAPI();
  final usuarioController = TextEditingController();
  final passController = TextEditingController();
  final pass2Controller = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _userformKey = GlobalKey<FormState>();
  final _passformKey = GlobalKey<FormState>();
  final _pass2formKey = GlobalKey<FormState>();

  var _isFetching = false;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  void _editUsuario() async {
    String correo = await _session.get();

    var url = "${AppConfig.apiHost}/editUser.php";

    http.post(url, body: {"usuario": usuarioController.text, "correo": correo});

    Navigator.push(context, MaterialPageRoute(builder: (context) => Splash()));
  }

  void _changePass() async {
    String correo = await _session.get();

    var url = "${AppConfig.apiHost}/editPass.php";

    http.post(url, body: {"password": passController.text, "correo": correo});

    Navigator.push(context, MaterialPageRoute(builder: (context) => Splash()));
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  _pass(tipo) async {
    String correo = await _session.get();

    final isOk = (await _authAPI.password(context,
        password: pass2Controller.text, correo: correo));

    if (isOk) {
      tipo == 'usuario'
          ? _editUsuario()
          : tipo == 'password' ? _changePass() : Text("Cargando");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final responsive = Responsive(context);

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/fondo_login.png"), fit: BoxFit.fill),
        ),
        child: Scaffold(
          key: this._scaffoldKey,
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
                                SizedBox(height: responsive.hp(12)),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: 280,
                                      minWidth: 280,
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        widget.tipoUsuario == 'usuario'
                                            ? Text("USUARIO",
                                                style: TextStyle(
                                                    fontSize:
                                                        responsive.ip(2.5),
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w600))
                                            : widget.tipoUsuario ==
                                                    'administrador'
                                                ? Text("ADMINISTRADOR",
                                                    style: TextStyle(
                                                        fontSize:
                                                            responsive.ip(2.5),
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600))
                                                : widget.tipoUsuario ==
                                                        'comunicador'
                                                    ? Text("COMUNICADOR",
                                                        style: TextStyle(
                                                            fontSize: responsive
                                                                .ip(2.5),
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600))
                                                    : Text("Cargando Usuario",
                                                        style: TextStyle(
                                                            fontSize: responsive
                                                                .ip(2.5),
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                        SizedBox(height: responsive.hp(10)),
                                        // Container(
                                        //   child: Image.asset(
                                        //     "assets/images/user.png",
                                        //     color: Colors.white,
                                        //   ),
                                        //   width: responsive.wp(35),
                                        //   height: responsive.wp(35),
                                        // ),
                                        SizedBox(height: responsive.hp(3)),
                                        Form(
                                          key: _userformKey,
                                          child: Column(
                                            children: <Widget>[
                                              TextFormField(
                                                inputFormatters: [
                                                  new WhitelistingTextInputFormatter(
                                                      RegExp("[a-zA-ZñÑ ]")),
                                                ],
                                                controller: usuarioController,
                                                decoration: InputDecoration(
                                                  suffixIcon: Icon(Icons.person,
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
                                                  labelText: "Nuevo Usuario",
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
                                                    TextInputType.emailAddress,
                                                style: TextStyle(
                                                    color: Colors.white),
                                                validator: (String text) {
                                                  if (text.isEmpty) {
                                                    return "Campo Vacío";
                                                  } else if (text
                                                          .startsWith(" ") ||
                                                      text.endsWith(" ")) {
                                                    return "Sin espacios al Inicio o al Final";
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                              ),
                                              SizedBox(
                                                  height: responsive.hp(2)),
                                              ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  maxWidth: 230,
                                                  minWidth: 230,
                                                ),
                                                child: CupertinoButton(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical:
                                                          responsive.ip(1.5)),
                                                  color: Color.fromARGB(
                                                      255, 185, 200, 195),
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  onPressed: () {
                                                    if (_userformKey
                                                        .currentState
                                                        .validate()) {
                                                      this
                                                          ._scaffoldKey
                                                          .currentState
                                                          .showBottomSheet((ctx) =>
                                                              _buildBottonSheet(
                                                                  ctx,
                                                                  'Confirma tu contraseña para realizar los cambios: ',
                                                                  'usuario'));
                                                    }
                                                  },
                                                  child: Text("Guardar Usuario",
                                                      style: TextStyle(
                                                        fontSize:
                                                            responsive.ip(2.4),
                                                        color: Color.fromARGB(
                                                            255, 34, 71, 16),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      )),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Form(
                                          key: _passformKey,
                                          child: Column(
                                            children: <Widget>[
                                              SizedBox(
                                                  height: responsive.hp(7)),
                                              TextFormField(
                                                inputFormatters: [
                                                  new BlacklistingTextInputFormatter(
                                                      RegExp("[ ]")),
                                                ],
                                                controller: passController,
                                                decoration: InputDecoration(
                                                  suffixIcon: GestureDetector(
                                                    onTap: _toggle,
                                                    child: Icon(
                                                      _obscureText
                                                          ? Icons.lock
                                                          : Icons.lock_open,
                                                      color: Colors.white,
                                                    ),
                                                  ),
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
                                                  labelText: "Nueva Contraseña",
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
                                                style: TextStyle(
                                                    color: Colors.white),
                                                obscureText: _obscureText,
                                                validator: (String text) {
                                                  if (text.isEmpty) {
                                                    return "Campo Vacío";
                                                  } else if (text
                                                          .startsWith(" ") ||
                                                      text.endsWith(" ")) {
                                                    return "Sin espacios al Inicio o al Final";
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: responsive.hp(2)),
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxWidth: 230,
                                            minWidth: 230,
                                          ),
                                          child: CupertinoButton(
                                            padding: EdgeInsets.symmetric(
                                                vertical: responsive.ip(1.5)),
                                            color: Color.fromARGB(
                                                255, 185, 200, 195),
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            onPressed: () {
                                              if (_passformKey.currentState
                                                  .validate()) {
                                                this
                                                    ._scaffoldKey
                                                    .currentState
                                                    .showBottomSheet((ctx) =>
                                                        _buildBottonSheet(
                                                            ctx,
                                                            'Confirma tu contraseña anterior para realizar los cambios: ',
                                                            'password'));
                                              }
                                            },
                                            child: Text(
                                              "Guardar Contraseña",
                                              style: TextStyle(
                                                fontSize: responsive.ip(2.4),
                                                color: Color.fromARGB(
                                                    255, 34, 71, 16),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                                SizedBox(height: responsive.hp(10)),
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: 200,
                                    minWidth: 200,
                                  ),
                                  child: CupertinoButton(
                                    padding: EdgeInsets.symmetric(
                                        vertical: responsive.ip(1.5)),
                                    color: Color.fromARGB(255, 185, 200, 195),
                                    borderRadius: BorderRadius.circular(25),
                                    onPressed: () {
                                      // Navigator.pushReplacementNamed(
                                      //     context, "Splash");
                                      widget.tipoUsuario == 'usuario'
                                          ? Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UsuarioPage()))
                                          : widget.tipoUsuario ==
                                                  'administrador'
                                              ? Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AdminPage()))
                                              : widget.tipoUsuario ==
                                                      'comunicador'
                                                  ? Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ComunicadorPage()))
                                                  : Text("Cargando");
                                    },
                                    child: Text("Regresar",
                                        style: TextStyle(
                                            fontSize: responsive.ip(2.4),
                                            color:
                                                Color.fromARGB(255, 34, 71, 16),
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                ),
                                SizedBox(
                                  height: responsive.hp(5),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  _isFetching
                      ? Positioned.fill(
                          child: Container(
                              color: Colors.black45,
                              child: Center(
                                child: CupertinoActivityIndicator(radius: 15),
                              )))
                      : Container()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container _buildBottonSheet(
      BuildContext context, String mensaje, String tipo) {
    return Container(
      height: 250,
      padding: EdgeInsets.all(20.0),
      child: ListView(
        children: <Widget>[
          ListTile(title: Text(mensaje)),
          Form(
            key: _pass2formKey,
            // child: TextFormField(
            //   inputFormatters: [
            //     new BlacklistingTextInputFormatter(RegExp("[ ]")),
            //   ],
            //   controller: pass2Controller,
            //   keyboardType: TextInputType.text,
            //   obscureText: true,
            //   decoration: InputDecoration(labelText: 'Contraseña'),
            //   validator: (String text) {
            //     if (text.isEmpty) {
            //       return "Contraseña Invalida";
            //     }else{
            //       return null;
            //     }
            //   }
            // ),
            child: TextFormField(
              inputFormatters: [
                new BlacklistingTextInputFormatter(RegExp("[ ]")),
              ],
              controller: pass2Controller,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black),
                ),
                labelText: "Nueva Contraseña",
                hintStyle: TextStyle(color: Colors.black),
                alignLabelWithHint: true,
                labelStyle: TextStyle(color: Colors.black),
                contentPadding: EdgeInsets.only(left: 20),
              ),
              cursorColor: Colors.black,
              style: TextStyle(color: Colors.black),
              obscureText: true,
              validator: (String text) {
                if (text.isEmpty) {
                  return "Campo Vacío";
                } else if (text.startsWith(" ") || text.endsWith(" ")) {
                  return "Sin espacios al Inicio o al Final";
                } else {
                  return null;
                }
              },
            ),
          ),
          SizedBox(height: 20.0),
          Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.clear),
                  label: Text('Cancelar'),
                ),
                SizedBox(width: 10.0),
                RaisedButton.icon(
                  onPressed: () {
                    if (_pass2formKey.currentState.validate()) {
                      _pass(tipo);
                    }
                  },
                  icon: Icon(Icons.lock),
                  label: Text('Confirmar'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<bool> _onBackPressed() {
    return showCupertinoDialog(
          context: context,
          builder: (context) => new CupertinoAlertDialog(
            title: Text("¿Deseas salir de la Aplicación?"),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text("Si"),
                onPressed: () => exit(0),
              ),
              CupertinoDialogAction(
                child: Text("No"),
                onPressed: () => Navigator.of(context).pop(false),
              ),
            ],
          ),
        ) ??
        false;
  }
}
