import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

import 'package:mensajeria/http/app_config.dart';
import 'package:mensajeria/src/widgets/responsive.dart';

class RegisterCom extends StatefulWidget {
  @override
  _PrivateRouteState createState() => _PrivateRouteState();
}

class _PrivateRouteState extends State<RegisterCom> {
  final _formKey = GlobalKey<FormState>();
  final correo = TextEditingController();
  final password = TextEditingController();
  final usuario = TextEditingController();

  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  }

  void _addCom() {
    var url = "${AppConfig.apiHost}/addComunicador.php";

    http.post(url, body: {
      "usuario" : usuario.text,
      "correo": correo.text,
      "password": password.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final responsive = Responsive(context);

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/fondo_login.png"), fit: BoxFit.fill),
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
                              SizedBox(height: responsive.hp(30)),
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
                                            labelText: "Usuario",
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
                                          controller: usuario,
                                          validator: (String text) {
                                            if (text.isEmpty) {
                                              return "Campo Vacío";
                                            }else if(text.startsWith(" ") || text.endsWith(" ")){
                                              return "Sin espacios al Inicio y al Final";
                                            }else{
                                              return null;
                                            }                                       
                                          },
                                        ),
                                        SizedBox(height: responsive.hp(3)),
                                        TextFormField(
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
                                          keyboardType: TextInputType.text,
                                          style: TextStyle(color: Colors.white),
                                          controller: correo,
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
                                        SizedBox(height: responsive.hp(3)),
                                        TextFormField(
                                          obscureText: _obscureText,
                                          inputFormatters: [
                                            new BlacklistingTextInputFormatter(new RegExp('[" "]')),
                                          ],
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
                                          keyboardType: TextInputType.text,
                                          style: TextStyle(color: Colors.white),
                                          controller: password,
                                          validator: (String text) {
                                            if (text.isEmpty) {
                                              return "Contraseña Invalida";
                                            }else{
                                              return null;
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  )),
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
                                    if (_formKey.currentState.validate()) {
                                      _addCom();
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Text("Crear Comunicador",
                                      style: TextStyle(
                                          fontSize: responsive.ip(2.4),
                                          color:
                                              Color.fromARGB(255, 34, 71, 16))),
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
}
