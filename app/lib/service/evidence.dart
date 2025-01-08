import 'dart:convert';
import 'dart:async';
import 'dart:developer';
import 'package:coc/service/authentication.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Evidence {
  final String evidenceID;
  final String evidenceType;
  final String evidenceDescription;
  final String evidenceOriginCoords;
  final String evidenceOriginDescription;
  final DateTime evidenceCreatedAt;
  final DateTime evidenceUpdatedAt;

  const Evidence({
    required this.evidenceID,
    required this.evidenceType,
    required this.evidenceDescription,
    required this.evidenceOriginCoords,
    required this.evidenceOriginDescription,
    required this.evidenceCreatedAt,
    required this.evidenceUpdatedAt,
  });

  factory Evidence.fromJson(Map<String, dynamic> json) {
    return Evidence(
      evidenceID: json['id'] as String,
      evidenceType: json['itemType'] as String,
      evidenceDescription: json['description'] as String,
      evidenceOriginCoords: json['originCoordinates'] as String,
      evidenceOriginDescription: json['originLocationDescription'] as String,
      evidenceCreatedAt: DateTime.parse(json['createdAt'] as String),
      evidenceUpdatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  static Future<List<Evidence>> fetchEvidence(String caseID) async {
    // TODO: make URL dynamic for case selection later
    final token = await Authentication.getBearerToken();
    final url = Uri.parse("https://coc.hootsifer.com/case/$caseID");
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': token,
    };
    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        log(" --- Request Successful --- ");
        final evidenceList = await compute(parseJson, response.body);
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
    final parsed = jsonDecode(responseBody) as Map<String, dynamic>;
    final evidenceList = parsed['data']['taggedEvidence'] as List<dynamic>;
    return evidenceList.map<Evidence>((json) => Evidence.fromJson(json as Map<String, dynamic>)).toList();
  }
}