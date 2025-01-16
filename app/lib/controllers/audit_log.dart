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
  final String? location;
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
    return AuditLog(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      userId: json['userId'],
      caseId: json['caseId'],
      caseUserId: json['caseUserId'],
      mediaEvidenceId: json['mediaEvidenceId'],
      taggedEvidenceId: json['taggedEvidenceId'],
      action: Action.values[json['action']],
      ip: json['ip'],
      userAgent: json['userAgent'],
      location: json['location'],
      oldData: json['oldData'],
      newData: json['newData'],
    );
  }
}
