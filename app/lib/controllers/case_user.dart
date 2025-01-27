enum CasePermission {
  view,
  manage,
  addEvidence,
  removeEvidence,
  deleteCase,
}

extension CasePermissionValue on CasePermission {
  int get value {
    switch (this) {
      case CasePermission.view:
        return 1;
      case CasePermission.manage:
        return 2;
      case CasePermission.addEvidence:
        return 4;
      case CasePermission.removeEvidence:
        return 8;
      case CasePermission.deleteCase:
        return 16;
    }
  }
}

class CaseUser {
  final String userId;
  final String firstName;
  final String lastName;
  final String email;
  String permissions;

  CaseUser({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.permissions,
  });

  get fullName => '$firstName $lastName';

  factory CaseUser.fromJson(Map<String, dynamic> json) {
    return CaseUser(
      userId: json['userId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      permissions: json['permissions'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'permissions': permissions,
    };
  }

  bool hasPermission(CasePermission permission) {
    final permissionValue = permission.value;
    final userPermission = int.parse(permissions);
    return (userPermission & permissionValue) == permissionValue;
  }
}
