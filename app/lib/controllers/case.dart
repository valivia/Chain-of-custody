import 'dart:convert';
import 'dart:developer';

import 'package:coc/controllers/case_user.dart';
import 'package:coc/controllers/media_evidence.dart';
import 'package:coc/controllers/tagged_evidence.dart';
import 'package:coc/service/authentication.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

enum CaseStatus {
  open,
  closed,
  archived,
}

class Case {
  final String id;
  DateTime createdAt;
  DateTime updatedAt;
  String title;
  String description;
  CaseStatus status;

  List<CaseUser> users;
  List<TaggedEvidence> taggedEvidence;
  List<MediaEvidence> mediaEvidence;

  Case({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
    required this.description,
    required this.status,
    required this.users,
    required this.taggedEvidence,
    required this.mediaEvidence,
  });

  factory Case.fromJson(Map<String, dynamic> json) {
    return Case(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      title: json['title'] as String,
      description: json['description'] as String,
      status: CaseStatus.values.byName(json['status'] as String),
      users: (json['users'] as List)
          .map((user) => CaseUser.fromJson(user))
          .toList(),
      taggedEvidence: (json['taggedEvidence'] as List)
          .map((evidence) => TaggedEvidence.fromJson(evidence))
          .toList(),
      mediaEvidence: (json['mediaEvidence'] as List)
          .map((evidence) => MediaEvidence.fromJson(evidence))
          .toList(),
    );
  }

  static Future<List<Case>> fetchCases() async {
    final token = await Authentication.getBearerToken();
    final url = Uri.parse("https://coc.hootsifer.com/case");
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': token,
    };
    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        log(" --- Request Succesfulll! --- ");
        final caseList = await compute(parseJson, response.body);
        return caseList;
      } else {
        final error = jsonDecode(response.body)["message"];
        log(" --- Error occured fetching case data: $error --- ");
        return Future.error(error);
      }
    } catch (error) {
      log(" --- Error occurred with case request: $error --- ");
      return Future.error("Unknown error occurred");
    }
  }

  static List<Case> parseJson(String responseBody) {
    final parsed = jsonDecode(responseBody) as Map<String, dynamic>;
    final caseList = parsed['data'] as List<dynamic>;
    return caseList
        .map<Case>((json) => Case.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  String get caseStatusString { 
    switch (status) {
      case CaseStatus.open:
        return 'Open';
      case CaseStatus.closed:
        return 'Closed';
      case CaseStatus.archived:
        return 'Archived';
      default:
        return 'Unknown';
    }
  }  
}
