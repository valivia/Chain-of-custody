import 'dart:convert';

import 'package:coc/service/authentication.dart';
import 'package:coc/service/enviroment.dart';
import 'package:watch_it/watch_it.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Map<String, String> getHeaders() {
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': di<Authentication>().bearerToken,
    };
  }

  static Future<http.Response> post(
    String url,
    Map<String, dynamic> body,
  ) async {
    final headers = getHeaders();
    final response = await http.post(
      Uri.parse('${EnvironmentConfig.apiUrl}$url'),
      headers: headers,
      body: jsonEncode(body),
    );

    return response;
  }

  /// Parses and validates the HTTP response
  static Map<String, dynamic> parseResponse(http.Response response) {
    try {
      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonResponse['data'];
      } else {
        throw ApiException(
          code: response.statusCode,
          message: jsonResponse['message'] ?? 'An error occurred',
        );
      }
    } catch (e) {
      throw ApiException(
        code: response.statusCode,
        message: e.toString(),
      );
    }
  }
}

class ApiException implements Exception {
  final int code;
  final String message;

  ApiException({required this.code, required this.message});

  @override
  String toString() {
    return message;
  }
}
