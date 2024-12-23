import 'dart:convert';
import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Evidence {
  final String evidenceID;
  final String evidenceType;
  final String evidenceDescription;

  const Evidence({
    required this.evidenceID,
    required this.evidenceType,
    required this.evidenceDescription,
  });

  factory Evidence.fromJson(Map<String, dynamic> json) {
    return Evidence(
      evidenceID: json['evidenceID'],
      evidenceType: json['evidenceType'],
      evidenceDescription: json['evidenceDescription'],
    );
  }

  static Future<List<Evidence>> fetchEvidence() async {
    final url = Uri.parse("https://coc.hootsifer.com/evidence/tag");
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        log(" --- Request Successful --- ");
        final evidenceList = await compute(parseJson, response.body);
        log(evidenceList.toString());
        return evidenceList;
      } else {
        final error = jsonDecode(response.body)["message"];
        log(" --- Error occurred fetching data: $error --- ");
        return Future.error(error);
      }
    } catch (error) {
      log(" --- Error occurred with request: $error --- ");
      return Future.error("Unknown error occurred");
    }
  }

  static List<Evidence> parseJson(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Evidence>((json) => Evidence.fromJson(json)).toList();
  }
}