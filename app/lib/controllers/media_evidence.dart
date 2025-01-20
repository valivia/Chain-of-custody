import 'package:coc/controllers/audit_log.dart';
import 'package:coc/utility/helpers.dart';
import 'package:latlong2/latlong.dart';

class MediaEvidence {
  String id;
  String userId;
  String caseId;

  DateTime createdAt;
  DateTime updatedAt;
  DateTime madeOn;

  LatLng originCoordinates;

  List<AuditLog> auditLogs;

  MediaEvidence({
    required this.id,
    required this.userId,
    required this.caseId,
    required this.createdAt,
    required this.updatedAt,
    required this.madeOn,
    required this.originCoordinates,
    required this.auditLogs,
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
      auditLogs: (json['auditLog'] as List)
          .map((log) => AuditLog.fromJson(log))
          .toList(),
    );
  }
}
