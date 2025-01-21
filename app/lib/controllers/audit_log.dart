// Package imports:
import 'package:latlong2/latlong.dart';

// Project imports:
import 'package:coc/utility/helpers.dart';

enum Action {
  create,
  update,
  delete,
  transfer,
}

class AuditLog {
  final String id;
  final DateTime createdAt;
  final String userId;
  final String? caseId;
  final String? caseUserId;
  final String? mediaEvidenceId;
  final String? taggedEvidenceId;
  final Action action;
  final String ip;
  final String userAgent;
  final LatLng? location;
  final String? oldData;
  final String? newData;

  AuditLog({
    required this.id,
    required this.createdAt,
    required this.userId,
    this.caseId,
    this.caseUserId,
    this.mediaEvidenceId,
    this.taggedEvidenceId,
    required this.action,
    required this.ip,
    required this.userAgent,
    this.location,
    this.oldData,
    this.newData,
  });

  factory AuditLog.fromJson(Map<String, dynamic> json) {
    final location = json['location'] != null
        ? coordinatesFromString(json['location'] as String)
        : null;

    return AuditLog(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      userId: json['userId'],
      caseId: json['caseId'],
      caseUserId: json['caseUserId'],
      mediaEvidenceId: json['mediaEvidenceId'],
      taggedEvidenceId: json['taggedEvidenceId'],
      action: Action.values.byName(json['action']),
      ip: json['ip'],
      userAgent: json['userAgent'],
      location: location,
      oldData: json['oldData'],
      newData: json['newData'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'userId': userId,
      'caseId': caseId,
      'caseUserId': caseUserId,
      'mediaEvidenceId': mediaEvidenceId,
      'taggedEvidenceId': taggedEvidenceId,
      'action': action.name,
      'ip': ip,
      'userAgent': userAgent,
      // 'location': location != null ? coordinatesToString(location!) : null,
      'oldData': oldData,
      'newData': newData,
    };
  }
}
