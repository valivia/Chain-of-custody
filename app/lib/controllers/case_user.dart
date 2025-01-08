class CaseUser {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  final String caseId;
  final String userId;
  String permissions;

  CaseUser({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.caseId,
    required this.userId,
    required this.permissions,
  });

  factory CaseUser.fromJson(Map<String, dynamic> json) {
    return CaseUser(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      caseId: json['caseId'] as String,
      userId: json['userId'] as String,
      permissions: json['permissions'] as String,
    );
  }

  bool hasPermission(String permission) {
    throw UnimplementedError();
  }
}
