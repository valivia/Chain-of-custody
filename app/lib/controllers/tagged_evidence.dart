// Package imports:
import 'package:latlong2/latlong.dart';

// Project imports:
import 'package:coc/controllers/audit_log.dart';
import 'package:coc/controllers/case.dart';
import 'package:coc/service/api_service.dart';
import 'package:coc/utility/helpers.dart';

enum ContainerType {
  bag,
  box,
  envelope,
  other,
}

class TaggedEvidence {
  String id;

  String userId;
  String caseId;

  DateTime madeOn;

  String containerType;
  String itemType;
  String? description;

  LatLng originCoordinates;
  String originLocationDescription;

  List<AuditLog> auditLog;

  // Api Only
  DateTime? createdAt;
  DateTime? updatedAt;

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

  List<AuditLog> get transfers {
    final sortedTransfers = auditLog
        .where((log) => log.action == Action.transfer)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sortedTransfers;
  }

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

  static Future<TaggedEvidence> fromForm({
    required String id,
    required Case caseItem,
    required ContainerType containerType,
    required String itemType,
    required String description,
    required LatLng originCoordinates,
    required String originLocationDescription,
  }) async {
    final body = {
      'id': id,
      'caseId': caseItem.id,
      'containerType': containerType.name,
      'itemType': itemType,
      'description': description,
      'originCoordinates': coordinatesToString(originCoordinates),
      'originLocationDescription': originLocationDescription,
    };

    final response = await ApiService.post('/evidence/tag', body);
    final data = ApiService.parseResponse(response);

    final evidence = TaggedEvidence.fromJson(data);

    caseItem.taggedEvidence.add(evidence);

    return evidence;
  }
}
