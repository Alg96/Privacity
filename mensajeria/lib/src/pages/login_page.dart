import 'dart:io';

import 'Usuario/usuario_page.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
//import 'package:local_auth/local_auth.dart';
import 'package:mensajeria/api/auth_api.dart';
import 'package:mensajeria/src/widgets/responsive.dart';
import 'package:mensajeria/src/pages/register_page.dart';
import 'package:mensajeria/src/pages/Administrador/admin_page.dart';
import 'package:mensajeria/src/pages/Comunicador/comunicador_page.dart';
import 'package:mensajeria/src/providers/push_notifications_provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _authAPI = AuthAPI();
  //final LocalAuthentication _localAuthentication = LocalAuthentication();

  var _email = '', _password = '';
  var _isFetching = false;
  bool _obscureText = true;
  //ool _hasFingerPrintSupport = false;

  //String _authorizedOrNot = "Not Authorized";
  //List<BiometricType> _availableBuimetricType = List<BiometricType>();

  // Future<void> _getBiometricsSupport() async {
  //   bool hasFingerPrintSupport = false;
  //   try {
  //     hasFingerPrintSupport = await _localAuthentication.canCheckBiometrics;
  //   } catch (e) {
  //     print(e);
  //   }
  //   if (!mounted) return;
  //   setState(() {
  //     _hasFingerPrintSupport = hasFingerPrintSupport;
  //   });
  // }

  // Future<void> _getAvailableSupport() async {
  //   List<BiometricType> availableBuimetricType = List<BiometricType>();
  //   try {
  //     availableBuimetricType =
  //         await _localAuthentication.getAvailableBiometrics();
  //   } catch (e) {
  //     print(e);
  //   }
  //   if (!mounted) return;
  //   setState(() {
  //     _availableBuimetricType = availableBuimetricType;
  //   });
  // }

  // Future<void> _authenticateMe() async {
  //   bool authenticated = false;
  //   try {
  //     authenticated = await _localAuthentication.authenticateWithBiometrics(
  //       localizedReason: "Coloca tu Huella", // message for dialog
  //       useErrorDialogs: true, // show error in dialog
  //       stickyAuth: true, // native process
  //     );
  //   } catch (e) {
  //     print(e);
  //   }
  //   if (!mounted) return;
  //   setState(() {
  //     _authorizedOrNot = authenticated ? "Authorized" : "Not Authorized";
  //     if (_authorizedOrNot == "Authorized") {
  //       Navigator.pushReplacementNamed(context, 'Diputado');
  //     }
  //   });
  // }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    //_getBiometricsSupport();
    //_getAvailableSupport();

    final pushProvider = PushNotificationProvider();
    pushProvider.initNotifications();

    pushProvider.mensajes.listen((argumento) {
      //Navigator.push(context, new MaterialPageRoute(builder: (context) =>new ChatScreenPublico(argumento,"")));
    });
  }

  _submit() async {
    if (_isFetching) return;

    final isValid = _formKey.currentState.validate();

    if (isValid) {
      setState(() {
        _isFetching = true;
      });

      final isOk =
          await _authAPI.login(context, email: _email, password: _password);

      setState(() {
        _isFetching = false;
      });

      if (isOk == '0') {
        //Navigator.pushNamedAndRemoveUntil(context, 'Administrador', (_) => false);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AdminPage()));
      } else if (isOk == '1') {
        //Navigator.pushNamedAndRemoveUntil(context, 'Comunicador', (_) => false);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ComunicadorPage()));
      } else if (isOk == '2') {
        //Navigator.pushNamedAndRemoveUntil(context, 'Diputado', (_) => false);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => UsuarioPage()));
      } else {
        
      }
    }
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
                                SizedBox(height: responsive.hp(20)),
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
                                              _email = value;
                                                return null;
                                            }
                                          ),
                                          SizedBox(height: responsive.hp(3)),
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
                                              style:
                                                  TextStyle(color: Colors.white),
                                              obscureText: _obscureText,
                                              validator: (String text) {
                                                if (text.isNotEmpty &&
                                                    text.length > 1) {
                                                  _password = text;
                                                  return null;
                                                }
                                                return "Contraseña invalida";
                                              }),
                                        ],
                                      )),
                                ),
                                SizedBox(height: responsive.hp(2)),
                                Container(
                                  child: Image.asset(
                                    "assets/images/mensajeria2.png",
                                  ),
                                  width: responsive.wp(20),
                                  height: responsive.wp(20),
                                ),
                                SizedBox(height: responsive.hp(2)),
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
                                    onPressed: () => _submit(),
                                    child: Text("Ingresar",
                                        style: TextStyle(
                                          fontSize: responsive.ip(2.4),
                                          color: Color.fromARGB(255, 82, 99, 74),
                                          fontWeight: FontWeight.w600,
                                        )),
                                  ),
                                ),
                                SizedBox(height: responsive.hp(3)),
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
                                    onPressed: /*_authenticateMe*/ null,
                                    child: Text("Huella",
                                        style: TextStyle(
                                            fontSize: responsive.ip(2.4),
                                            color:
                                                Color.fromARGB(255, 82, 99, 74),
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ),
                                SizedBox(height: responsive.hp(2)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text("¿No tienes una cuenta?",
                                        style: TextStyle(
                                            fontSize: responsive.ip(1.5),
                                            color: Colors.white70)),
                                    CupertinoButton(
                                      onPressed: () {
                                        //Navigator.pushNamed(context, "Registro");
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RegisterPage()));
                                        // Navigator.pushNamed(
                                        // context, "Registro",arguments:<String,String>{
                                        //   'email': correo,
                                        //   'email2': correo2,
                                        // });
                                      },
                                      child: Text("Registrate",
                                          style: TextStyle(
                                              fontSize: responsive.ip(1.5),
                                              color: Colors.white)),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text("¿Olvidó su Contraseña?",
                                        style: TextStyle(
                                            fontSize: responsive.ip(1.5),
                                            color: Colors.white70)),
                                    CupertinoButton(
                                      onPressed: () =>
                                          /*Navigator.pushNamed(
                                          context, "Registro")*/
                                          null,
                                      child: Text("Recuperar",
                                          style: TextStyle(
                                              fontSize: responsive.ip(1.5),
                                              color: Colors.white)),
                                    )
                                  ],
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
