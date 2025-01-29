// Dart imports:
import 'dart:convert';
import 'dart:developer';

// Package imports:
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:watch_it/watch_it.dart';

// Project imports:
import 'package:coc/controllers/user.dart';
import 'package:coc/service/data.dart';
import 'package:coc/service/enviroment.dart';

class Authentication extends ChangeNotifier {
  String? _token;
  User? _user;

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Authentication._();

  static Future<Authentication> create() async {
    var instance = Authentication._();
    await instance._getTokenFromStorage();
    return instance;
  }

  void _updateToken(String? token) {
    if (token == null) {
      _user = null;
      _secureStorage.delete(key: "token");
    } else {
      _user = User.fromJson(JwtDecoder.decode(token));
      _secureStorage.write(key: "token", value: token);
    }

    _token = token;

    notifyListeners();
  }

  Future<void> _getTokenFromStorage() async {
    var token = await _secureStorage.read(key: "token");
    _updateToken(token);
  }

  Future<bool> login(String email, String password) async {
    final url = Uri.parse("${EnvironmentConfig.apiUrl}/auth/login");
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
      _updateToken(token);
      di<DataService>().syncWithApi();
      log('Logged in');
      return true;
    } else {
      final error = jsonDecode(response.body)['message'];
      log('Error: $error');
      return Future.error(error);
    }
  }

  void logout() {
    _updateToken(null);
    di<DataService>().clear();
    log('Logged out');
  }

  bool get isLoggedIn => _token != null;

  User get user => _user != null ? _user! : throw 'Not logged in';

  String get bearerToken =>
      isLoggedIn ? 'Bearer $_token' : throw 'Not logged in';

  bool get isExpired => isLoggedIn ? JwtDecoder.isExpired(_token!) : true;
}
