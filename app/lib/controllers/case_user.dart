// Package imports:
import 'package:watch_it/watch_it.dart';

// Project imports:
import 'package:coc/controllers/case.dart';
import 'package:coc/service/api_service.dart';
import 'package:coc/service/data.dart';

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

int allPermissions() {
  return CasePermission.values.fold<int>(0, (int previousValue, element) {
    return previousValue | element.value;
  });
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

  static Future<CaseUser> fromForm({
    required String userId,
    required List<CasePermission> permissions,
    required Case caseItem,
  }) async {
    final body = {
      'userId': userId,
      'permissions': permissions.fold<int>(0, (int previousValue, element) {
        return previousValue | element.value;
      }).toRadixString(2),
    };

    final response = await ApiService.post('/case/${caseItem.id}/user', body);
    final data = ApiService.parseResponse(response);

    final caseUser = CaseUser.fromJson(data);

    caseItem.users.add(caseUser);

    di<DataService>().currentCase = caseItem;
    di<DataService>().syncWithApi();

    return caseUser;
  }

  bool hasPermission(CasePermission permission) {
    final permissionValue = permission.value;
    final userPermission = int.parse(permissions);
    return (userPermission & permissionValue) == permissionValue;
  }

  // Get permission string array
  List<String> get permissionStrings {
    final userPermission = int.parse(permissions, radix: 2);
    return CasePermission.values
        .where((permission) =>
            (userPermission & permission.value) == permission.value)
        .map((permission) => permission.toString().split('.').last)
        .toList();
  }
}
