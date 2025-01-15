import 'dart:core';

class User {
  String id;

  String firstName;
  String lastName;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
    );
  }

  bool hasPermission(String permission) {
    throw UnimplementedError();
  }
}
