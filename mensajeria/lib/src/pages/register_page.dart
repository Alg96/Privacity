import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/services.dart';
import 'package:mensajeria/api/auth_api.dart';
import 'package:mensajeria/http/app_config.dart';
import 'package:random_string/random_string.dart';
import 'package:mensajeria/src/widgets/responsive.dart';
import 'package:toast/toast.dart';

import 'Componentes/perfil_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _authAPI = AuthAPI();
  final usuarioController = TextEditingController();
  final correoController = TextEditingController();
  final passController = TextEditingController();
  final passRepetController = TextEditingController();

  String passwordRandom = randomAlphaNumeric(8);
  String usuario, correo,password;
  var _password = '';
  var _isFetching = false;
  bool _obscureText = true;
  bool _obscureTextRepeat = true;

  void _toggleRepeat() {
    setState(() {
      _obscureTextRepeat = !_obscureTextRepeat;
    });
  }

  void _addUsuario() {
    var url = "${AppConfig.apiHost}/usuario.php";

    http.post(url, body: {"usuario": usuario, "correo": correo});
  }

  
  // void  _sendEmail() {
  //   var url = ("http://alg96email.000webhostapp.com/email.php");

  //   http.post(url, body: {
  //     "para": correoController.text,
  //     "titulo": "Password Provisional",
  //     "mensaje": passwordRandom
  //   });
  // }


  _submit() async {
    if (_isFetching) return;

    final isValid = _formKey.currentState.validate();

    if (isValid) {
      setState(() {
        _isFetching = true;
      });
      final isOk =
          await _authAPI.register(context, email: correo, password: password);

      setState(() {
        _isFetching = false;
      });

      if (isOk) {
        _addUsuario();
        //_sendEmail();
        //Navigator.pushNamedAndRemoveUntil(context, 'Diputado', (_) => false);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PerfilPage("usuario")));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  }


  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
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
              image: AssetImage("assets/fondo_registro.png"), fit: BoxFit.fill),
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
                                SizedBox(height: responsive.hp(40)),
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
                                      child: Column(
                                        children: <Widget>[
                                          TextFormField(
                                            controller: usuarioController,
                                            decoration: InputDecoration(
                                              suffixIcon: Icon(Icons.person,
                                                  color: Colors.white),
                                              fillColor: Color.fromARGB(
                                                  255, 58, 116, 105),
                                              filled: true,
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 58, 116, 105)),
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255)),
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.red),
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                              labelText: "Nombre de Usuario",
                                              hintStyle: TextStyle(
                                                  color: Colors.white70),
                                              alignLabelWithHint: true,
                                              labelStyle: TextStyle(
                                                  fontSize: responsive.ip(1.8),
                                                  color: Colors.white70),
                                              contentPadding:
                                                  EdgeInsets.only(left: 20),
                                            ),
                                            cursorColor: Colors.white,
                                            keyboardType: TextInputType.text,
                                            style: TextStyle(color: Colors.white),
                                            validator: (String text) {
                                              if (text.isNotEmpty) {
                                                return null;
                                              }
                                              return "No se permiten campos vacíos";
                                            },
                                          ),
                                          SizedBox(height: responsive.hp(1.5)),
                                          TextFormField(
                                            controller: correoController,
                                            decoration: InputDecoration(
                                              suffixIcon: Icon(Icons.alternate_email,
                                                  color: Colors.white),
                                              fillColor: Color.fromARGB(
                                                  255, 58, 116, 105),
                                              filled: true,
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 58, 116, 105)),
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255)),
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.red),
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                              labelText: "Correo",
                                              hintStyle: TextStyle(
                                                  color: Colors.white70),
                                              alignLabelWithHint: true,
                                              labelStyle: TextStyle(
                                                  fontSize: responsive.ip(1.8),
                                                  color: Colors.white70),
                                              contentPadding:
                                                  EdgeInsets.only(left: 20),
                                            ),
                                            cursorColor: Colors.white,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            style: TextStyle(color: Colors.white),
                                            validator: (String value) {
                                              Pattern pattern =
                                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                              RegExp regex = new RegExp(pattern);
                                              if (!regex.hasMatch(value))
                                                return 'Introduce un correo valido';
                                              else
                                                return null;
                                            }
                                          ),
                                          SizedBox(height: responsive.hp(1.5)),
                                          TextFormField(
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
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 58, 116, 105)),
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255)),
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.red),
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                              labelText: "Contraseña",
                                              hintStyle: TextStyle(
                                                  color: Colors.white70),
                                              alignLabelWithHint: true,
                                              labelStyle: TextStyle(
                                                  fontSize: responsive.ip(1.8),
                                                  color: Colors.white70),
                                              contentPadding:
                                                  EdgeInsets.only(left: 20),
                                            ),
                                            cursorColor: Colors.white,
                                            obscureText: _obscureText,
                                            controller: passController,
                                            style: TextStyle(color: Colors.white),
                                            validator: (String text) {
                                              if (text.isNotEmpty &&
                                                  text.length > 3) {
                                                _password = text;
                                                return null;
                                              }
                                              return "Contraseña invalida";
                                            },
                                          ),
                                          SizedBox(height: responsive.hp(1.5)),
                                          TextFormField(
                                            decoration: InputDecoration(
                                              suffixIcon: GestureDetector(
                                                onTap: () {
                                                  _toggleRepeat();
                                                },
                                                child: Icon(
                                                  _obscureTextRepeat
                                                      ? Icons.lock
                                                      : Icons.lock_open,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              fillColor: Color.fromARGB(
                                                  255, 58, 116, 105),
                                              filled: true,
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 58, 116, 105)),
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255)),
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.red),
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                              labelText: "Repetir contraseña",
                                              hintStyle: TextStyle(
                                                  color: Colors.white70),
                                              alignLabelWithHint: true,
                                              labelStyle: TextStyle(
                                                  fontSize: responsive.ip(1.8),
                                                  color: Colors.white70),
                                              contentPadding:
                                                  EdgeInsets.only(left: 20),
                                            ),
                                            cursorColor: Colors.white,
                                            obscureText: _obscureTextRepeat,
                                            controller: passRepetController,
                                            style: TextStyle(color: Colors.white),
                                            validator: (String text) {
                                              if (text.isNotEmpty &&
                                                  text.length > 3) {
                                                if (text == _password) {
                                                  return null;
                                                }
                                                return "Contraseña no coincide";
                                              }
                                              return "Contraseña invalida";
                                            },
                                          ),
                                        ],
                                      )),
                                ),
                                SizedBox(height: responsive.ip(4)),
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
                                      if(passController.text == passRepetController.text){
                                        usuario = usuarioController.text;
                                        correo = correoController.text;
                                        password = passController.text;
                                        _submit();       
                                      }else{
                                        Toast.show("Las Contraseñas no Coinciden", context,
                                        duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
                                      }
                                    },
                                    child: Text("Registrarse",
                                        style: TextStyle(
                                            fontSize: responsive.ip(2.4),
                                            color:
                                                Color.fromARGB(255, 82, 99, 74))),
                                  ),
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
                  _isFetching
                      ? Positioned.fill(
                          child: Container(
                          color: Colors.black45,
                          child: Center(
                            child: CupertinoActivityIndicator(radius: 15),
                          ),
                        ))
                      : Container(),
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
          onPressed: ()=> exit(0),
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
