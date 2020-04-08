import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationProvider {

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final String serverToken = 'AAAAW4dUJyU:APA91bEFE_WuSSMAWpG0ZtJgCTPGExQSKu4wgXI-DfFhaFu0LkXRFxvXNASmg1RcFZ1UgZ6bgcVNj-MvbAQgLpy4KfNG2Jl1aRwLqGZNMbjY15QdCyOrAOnbE_9qo0c3lNn3aqZuzrWK';
  final _mensajesStreamController = StreamController<String>.broadcast();
  Stream<String> get mensajes => _mensajesStreamController.stream;

  Future<Map<String, dynamic>> sendAndRetrieveMessage(String mensaje,String canal) async {
     _firebaseMessaging.requestNotificationPermissions();

      await http.post(
        'https://fcm.googleapis.com/fcm/send',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverToken',
        },
        body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': '$mensaje',
            'title': 'Nuevo mensaje del canal $canal'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'canal': '$canal'
          },
          'to':'/topics/$canal',
        },
        ),
      );

      final Completer<Map<String, dynamic>> completer =
        Completer<Map<String, dynamic>>();

      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          completer.complete(message);
        },
      );

      return completer.future;
  }

  initNotifications() {

    _firebaseMessaging.requestNotificationPermissions();

    _firebaseMessaging.getToken().then( (token) {
  
    });


    _firebaseMessaging.configure(

      onMessage: ( info ) async {

        String argumento = 'no-data';
        if ( Platform.isAndroid  ) {  
          argumento = info['data']['canal'] ?? 'no-data';
        } else {
          argumento = info['canal'] ?? 'no-data-ios';
        }

        _mensajesStreamController.sink.add(argumento);

      },
      onLaunch: ( info ) async {
        
        String argumento = 'no-data';

        if ( Platform.isAndroid  ) {  
          argumento = info['data']['canal'] ?? 'no-data';
        } else {
          argumento = info['canal'] ?? 'no-data-ios';
        }
        
        _mensajesStreamController.sink.add(argumento);

      },

      onResume: ( info ) async {
        
        final noti = info['data']['canal']; 
        
        _mensajesStreamController.sink.add(noti);

      }
    );
  }

  dispose() {
    _mensajesStreamController?.close();
  }

}