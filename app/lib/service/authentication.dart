import 'dart:convert';
import 'dart:developer';
import 'package:coc/main.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class Authentication {
  static Future<bool> login(String email, String password) async {
    final url = Uri.parse("https://coc.hootsifer.com/auth/login");
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final body = jsonEncode({
      'email': email,
      'password': password,
    });
    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final token = jsonDecode(response.body)['access_token'];
      globalState<FlutterSecureStorage>().write(key: "token", value: token);
      log('Logged in');
      return true;
    } else {
      final error = jsonDecode(response.body)['message'];
      log('Error: $error');
      return Future.error(error);
    }
  }

  static logout() {
    globalState<FlutterSecureStorage>().delete(key: "token");
    log('Logged out');
  }

  static Future<String> getToken() async {
    final token = await globalState<FlutterSecureStorage>().read(key: "token");
    if (token == null) {
      return Future.error('No token found');
    }
    return token;
  }

  static Future<String> getBearerToken() async {
    final token = await getToken();
    return 'Bearer $token';
  }
}
