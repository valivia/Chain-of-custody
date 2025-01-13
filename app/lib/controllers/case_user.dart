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

  factory CaseUser.fromJson(Map<String, dynamic> json) {
    return CaseUser(
      userId: json['userId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      permissions: json['permissions'],
    );
  }

  bool hasPermission(String permission) {
    throw UnimplementedError();
  }
}
