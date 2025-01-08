import 'dart:core';

class User {
  String id;
  DateTime createdAt;
  DateTime updatedAt;

  String firstName;
  String lastName;

  User({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.firstName,
    required this.lastName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
    );
  }

  bool hasPermission(String permission) {
    throw UnimplementedError();
  }
}
