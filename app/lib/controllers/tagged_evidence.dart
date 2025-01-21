// Package imports:
import 'package:latlong2/latlong.dart';

// Project imports:
import 'package:coc/controllers/audit_log.dart';
import 'package:coc/utility/helpers.dart';

class TaggedEvidence {
  String id;

  String userId;
  String caseId;

  DateTime madeOn;
  DateTime? createdAt;
  DateTime? updatedAt;

  String containerType;
  String itemType;
  String? description;

  LatLng originCoordinates;
  String originLocationDescription;

  List<AuditLog> auditLog;

  // Api Only

  TaggedEvidence({
    required this.id,
    required this.userId,
    required this.caseId,
    this.createdAt,
    this.updatedAt,
    required this.madeOn,
    required this.containerType,
    required this.itemType,
    required this.description,
    required this.originCoordinates,
    required this.originLocationDescription,
    required this.auditLog,
  });

  factory TaggedEvidence.fromJson(Map<String, dynamic> json) {
    final createdAt = json['createdAt'] as String?;
    final updatedAt = json['updatedAt'] as String?;
    return TaggedEvidence(
      id: json['id'] as String,
      userId: json['userId'] as String,
      caseId: json['caseId'] as String,
      createdAt: createdAt == null ? null : DateTime.parse(createdAt),
      updatedAt: updatedAt == null ? null : DateTime.parse(updatedAt),
      madeOn: DateTime.parse(json['madeOn'] as String),
      containerType: json['containerType'],
      itemType: json['itemType'] as String,
      description: json['description'] as String?,
      originCoordinates:
          coordinatesFromString(json['originCoordinates'] as String),
      originLocationDescription: json['originLocationDescription'] as String,
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
      'madeOn': madeOn.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'containerType': containerType,
      'itemType': itemType,
      'description': description,
      'originCoordinates': coordinatesToString(originCoordinates),
      'originLocationDescription': originLocationDescription,
      'auditLog': auditLog.map((log) => log.toJson()).toList(),
    };
  }
}
