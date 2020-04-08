import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Session {
  final key = "SESSION";
  final storage = new FlutterSecureStorage();

  set(String email) async {
    await storage.write(key: key, value: email);
  }

  get() async {
    String result = await storage.read(key: key);
    if (result != null) {
      return result;
    }
    return null;
  }

  del() async {
    final result = await storage.read(key: key);
    if (result != null) {
      await storage.delete(key: key);
    }
    return null;
  }
}
