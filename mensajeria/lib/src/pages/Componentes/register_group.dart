import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';

import 'package:mensajeria/http/insert.dart';
import 'package:mensajeria/src/widgets/session.dart';
import 'package:mensajeria/src/widgets/responsive.dart';

class RegisterGroup extends StatefulWidget {
  @override
  _RegisterGroupState createState() => _RegisterGroupState();
}

class _RegisterGroupState extends State<RegisterGroup> {
  final _session = Session();
  final _formKey = GlobalKey<FormState>();
  final nombre = TextEditingController();
  final descripcion = TextEditingController();

  String correo;

  getEmail() async {
    correo = await _session.get();
  }

  @override
  void initState() {
    getEmail();
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final responsive = Responsive(context);

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/nuevo_grupo.png"), fit: BoxFit.fill),
      ),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
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
                                          decoration: InputDecoration(
                                            suffixIcon: Icon(Icons.add_comment,
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
                                            labelText: "Nombre del Grupo",
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
                                          controller: nombre,
                                          validator: (String text) {
                                            if (text.isNotEmpty) {
                                              return null;
                                            }
                                            return "Campo Vacío";
                                          },
                                        ),
                                        SizedBox(height: responsive.hp(1.5)),
                                        TextFormField(
                                          decoration: InputDecoration(
                                            suffixIcon: Icon(Icons.add_comment,
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
                                            labelText: "Descripcion del Grupo",
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
                                          controller: descripcion,
                                          validator: (String text) {
                                            if (text.isNotEmpty) {
                                              return null;
                                            }
                                            return "Campo Vacío";
                                          },
                                        ),
                                        SizedBox(height: responsive.hp(1.5)),
                                      ],
                                    ),
                                  )),
                              SizedBox(height: responsive.ip(3)),
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
                                      insertGroup(nombre.text, descripcion.text,
                                          correo);

                                      Navigator.of(context).pop();
                                    }
                                  },
                                  child: Text("Crear Grupo",
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
