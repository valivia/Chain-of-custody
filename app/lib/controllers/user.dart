// Dart imports:
import 'dart:core';

class User {
  String id;

  String firstName;
  String lastName;

  String email;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  String get fullName => '$firstName $lastName';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
    );
  }

  bool hasPermission(String permission) {
    throw UnimplementedError();
  }
}

class UserScannable {
  final String id;
  final String name;

  UserScannable({
    required this.id,
    required this.name,
  });

  factory UserScannable.fromUser(User user) {
    return UserScannable(
      id: user.id,
      name: user.fullName,
    );
  }

  factory UserScannable.fromJson(Map<String, dynamic> json) {
    return UserScannable(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
