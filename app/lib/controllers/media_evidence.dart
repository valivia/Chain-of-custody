// Package imports:
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:watch_it/watch_it.dart';

// Project imports:
import 'package:coc/controllers/audit_log.dart';
import 'package:coc/controllers/case.dart';
import 'package:coc/service/api_service.dart';
import 'package:coc/service/authentication.dart';
import 'package:coc/service/data.dart';
import 'package:coc/service/enviroment.dart';
import 'package:coc/utility/helpers.dart';

class MediaEvidence {
  String id;
  String userId;
  String caseId;

  DateTime createdAt;
  DateTime updatedAt;
  DateTime madeOn;

  LatLng originCoordinates;

  List<AuditLog> auditLog;

  MediaEvidence({
    required this.id,
    required this.userId,
    required this.caseId,
    required this.createdAt,
    required this.updatedAt,
    required this.madeOn,
    required this.originCoordinates,
    required this.auditLog,
  });

  factory MediaEvidence.fromJson(Map<String, dynamic> json) {
    return MediaEvidence(
      id: json['id'] as String,
      userId: json['userId'] as String,
      caseId: json['caseId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      madeOn: DateTime.parse(json['madeOn'] as String),
      originCoordinates:
          coordinatesFromString(json['originCoordinates'] as String),
      auditLog: json['auditLog'] != null
          ? (json['auditLog'] as List)
              .map((log) => AuditLog.fromJson(log))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'caseId': caseId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'madeOn': madeOn.toIso8601String(),
      'originCoordinates': coordinatesToString(originCoordinates),
      'auditLog': auditLog.map((log) => log.toJson()).toList(),
    };
  }

  static Future<MediaEvidence> fromForm({
    required String filePath,
    required Case caseItem,
    required LatLng originCoordinates,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${EnvironmentConfig.apiUrl}/evidence/media'),
    );

    // Add headers including the Bearer token
    request.headers['Authorization'] = di<Authentication>().bearerToken;
    request.fields['caseId'] = caseItem.id;
    request.fields['coordinates'] = coordinatesToString(originCoordinates);
    request.files.add(await http.MultipartFile.fromPath('file', filePath));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    final data = ApiService.parseResponse(response);

    final evidence = MediaEvidence.fromJson(data);

    caseItem.mediaEvidence.add(evidence);
    caseItem.updatedAt = DateTime.now();
    di<DataService>().currentCase = caseItem;

    di<DataService>().upsertCase(caseItem);

    return evidence;
  }
}
