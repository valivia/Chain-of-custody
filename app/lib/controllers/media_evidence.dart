// Package imports:
import 'package:latlong2/latlong.dart';

// Project imports:
import 'package:coc/controllers/audit_log.dart';
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
      auditLog: (json['auditLog'] as List)
          .map((log) => AuditLog.fromJson(log))
          .toList(),
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
}
