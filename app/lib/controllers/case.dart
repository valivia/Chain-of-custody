// Dart imports:
import 'dart:convert';
import 'dart:developer';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:http/http.dart' as http;
import 'package:watch_it/watch_it.dart';

// Project imports:
import 'package:coc/controllers/audit_log.dart';
import 'package:coc/controllers/case_user.dart';
import 'package:coc/controllers/media_evidence.dart';
import 'package:coc/controllers/tagged_evidence.dart';
import 'package:coc/service/authentication.dart';
import 'package:coc/service/enviroment.dart';

enum CaseStatus {
  open,
  closed,
  archived,
}

class Case {
  final String id;
  DateTime? createdAt;
  DateTime? updatedAt;

  String title;
  String description;
  CaseStatus status;

  List<CaseUser> users;
  List<TaggedEvidence> taggedEvidence;
  List<MediaEvidence> mediaEvidence;
  List<AuditLog> auditLog;

  Case({
    required this.id,
    this.createdAt,
    this.updatedAt,
    required this.title,
    required this.description,
    required this.status,
    required this.users,
    required this.taggedEvidence,
    required this.mediaEvidence,
    required this.auditLog,
  });

  String get statusString => status.name;

  factory Case.fromForm(
    String title,
    String description,
    CaseStatus status,
  ) {
    return Case(
      id: "",
      title: title,
      description: description,
      status: status,
      users: [],
      taggedEvidence: [],
      mediaEvidence: [],
      auditLog: [],
    );
  }

  factory Case.fromJson(Map<String, dynamic> json) {
    final createdAt = json['createdAt'] as String?;
    final updatedAt = json['updatedAt'] as String?;

    return Case(
      id: json['id'] as String,
      createdAt: createdAt == null ? null : DateTime.parse(createdAt),
      updatedAt: updatedAt == null ? null : DateTime.parse(updatedAt),
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
      auditLog: (json['auditLog'] as List)
          .map((log) => AuditLog.fromJson(log))
          .toList(),
    );
  }

  toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status.name,
      'users': users.map((user) => user.toJson()).toList(),
      'taggedEvidence':
          taggedEvidence.map((evidence) => evidence.toJson()).toList(),
      'mediaEvidence':
          mediaEvidence.map((evidence) => evidence.toJson()).toList(),
      'auditLog': auditLog.map((log) => log.toJson()).toList(),
    };
  }

  static List<Case> parseJson(String responseBody) {
    final parsed = jsonDecode(responseBody) as Map<String, dynamic>;
    final caseList = parsed['data'] as List<dynamic>;
    return caseList
        .map<Case>((json) => Case.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  static Future<List<Case>> fetchCases() async {
    final url = Uri.parse("${EnvironmentConfig.apiUrl}/case");
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': di<Authentication>().bearerToken,
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        log(" --- Sucessfully fetched cases --- ");
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

  // Upload case to API
  Future<Case> upload() async {
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': di<Authentication>().bearerToken,
    };

    final body = jsonEncode({
      'title': title,
      'description': description,
      'status': status.name,
    });

    try {
      http.Response response;
      if (createdAt != null) {
        final updateUrl = Uri.parse("${EnvironmentConfig.apiUrl}/case/$id");
        response = await http.put(updateUrl, headers: headers, body: body);
      } else {
        final url = Uri.parse("${EnvironmentConfig.apiUrl}/case");
        response = await http.post(url, headers: headers, body: body);
      }

      if (response.statusCode == 201) {
        log(" --- Sucessfully uploaded case --- ");
        final caseItem = Case.fromJson(jsonDecode(response.body));
        return caseItem;
      } else {
        final error = jsonDecode(response.body)["message"];
        log(" --- Error occured uploading case data: $error --- ");
        return Future.error(error);
      }
    } catch (error) {
      log(" --- Error occurred with case upload request: $error --- ");
      return Future.error("Unknown error occurred");
    }
  }

  canIUse(CasePermission permission) {
    final userId = di<Authentication>().user.id;
    final user = users.firstWhere((user) {
      return user.userId == userId;
    });
    return user.hasPermission(permission);
  }
}
