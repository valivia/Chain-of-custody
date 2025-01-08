import 'dart:convert';
import 'dart:async';
import 'dart:developer';
import 'package:coc/service/authentication.dart';
import 'package:coc/service/evidence.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Case {
  final String caseID;
  final DateTime caseCreatedAt;
  final DateTime caseUpdatedAt;
  final String caseTitle;
  final String caseDescription;
  final String caseStatus;
  // final List caseUsers;
  // final List<Evidence> caseTaggedEvidence;

  const Case({
    required this.caseID,
    required this.caseCreatedAt,
    required this.caseUpdatedAt,
    required this.caseTitle,
    required this.caseDescription,
    required this.caseStatus,
    // required this.caseUsers,
    // required this.caseTaggedEvidence,

  });

  factory Case.fromJson(Map<dynamic, dynamic> json){
    return Case(
        caseID: json['id'] as String,
        caseCreatedAt: DateTime.parse(json['createdAt'] as String),
        caseUpdatedAt: DateTime.parse(json['updatedAt'] as String),
        caseTitle: json['title'] as String,
        caseDescription: json['description'] as String,
        caseStatus: json['status'] as String,
        // caseUsers: List<String>.from(json['users']),
        // caseTaggedEvidence: Evidence.parseJson(json['taggedEvidence']),

      );
  }

  static Future<List<Case>> fetchCases() async {
    final token = await Authentication.getBearerToken();
    final url = Uri.parse("https://coc.hootsifer.com/case/");
    final headers = <String, String> { 
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': token,
    };
    try { 
      final response = await http.get(url, headers: headers ); 

      if (response.statusCode == 200) {
        // log(response.body);
        log(" --- Request Succesfulll! --- "); 
        final caseList = await compute(parseJson, response.body);
        return caseList;
      } else {
        final error = jsonDecode(response.body)["message"];
        log(" --- Error occured fetching data: $error --- ");
        return Future.error(error);
      }
    } catch (error) {
      log(" --- Error occurred with request: $error --- ");
      return Future.error("Unknown error occurred");
    }
  }

  static List<Case> parseJson(String responseBody) {
    final parsed = jsonDecode(responseBody) as Map<String, dynamic>;
    log(parsed.toString());
    final caseList = parsed['data'] as List<dynamic>;
    return caseList.map<Case>((json) => Case.fromJson(json as Map<String, dynamic>)).toList();
  }
}
