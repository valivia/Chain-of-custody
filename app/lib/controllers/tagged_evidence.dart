// Dart imports:
import 'dart:developer';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:latlong2/latlong.dart';
import 'package:watch_it/watch_it.dart';

// Project imports:
import 'package:coc/controllers/audit_log.dart' as audit_log;
import 'package:coc/controllers/case.dart';
import 'package:coc/service/api_service.dart';
import 'package:coc/service/authentication.dart';
import 'package:coc/service/data.dart';
import 'package:coc/utility/helpers.dart';

class TaggedEvidence {
  String id;

  String userId;
  String caseId;

  DateTime madeOn;

  ContainerType containerType;
  String itemType;
  String? description;

  LatLng originCoordinates;
  String originLocationDescription;

  List<audit_log.AuditLog> auditLog;

  // Api Only
  DateTime? createdAt;
  DateTime? updatedAt;
  bool offline;

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
    this.offline = false,
  });

  List<audit_log.AuditLog> get transfers {
    final sortedTransfers = auditLog
        .where((log) => log.action == audit_log.Action.transfer)
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
      containerType:
          ContainerType.values.byName(json['containerType'] as String),
      itemType: json['itemType'] as String,
      description: json['description'] as String?,
      originCoordinates:
          coordinatesFromString(json['originCoordinates'] as String),
      originLocationDescription: json['originLocationDescription'] as String,
      auditLog: json['auditLog'] != null
          ? (json['auditLog'] as List)
              .map((log) => audit_log.AuditLog.fromJson(log))
              .toList()
          : [],
      offline: json['offline'] as bool? ?? false,
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
      'containerType': containerType.name,
      'itemType': itemType,
      'description': description,
      'originCoordinates': coordinatesToString(originCoordinates),
      'originLocationDescription': originLocationDescription,
      'auditLog': auditLog.map((log) => log.toJson()).toList(),
      'offline': offline,
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
    late TaggedEvidence evidence;
    final isConnected = await InternetConnectionChecker().hasConnection;

    if (!isConnected) {
      evidence = TaggedEvidence(
        id: id,
        userId: di<Authentication>().user.id,
        caseId: caseItem.id,
        madeOn: DateTime.now(),
        containerType: containerType,
        itemType: itemType,
        description: description,
        originCoordinates: originCoordinates,
        originLocationDescription: originLocationDescription,
        auditLog: [],
        offline: true,
      );
    } else {
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
      evidence = TaggedEvidence.fromJson(data);
    }

    caseItem.taggedEvidence.add(evidence);
    di<DataService>().upsertCase(caseItem);

    return evidence;
  }

  static Future<void> transfer({
    required String id,
    required String coordinates,
  }) async {
    final body = {
      'coordinates': coordinates,
    };

    final response = await ApiService.post('/evidence/tag/$id/transfer', body);
    final data = ApiService.parseResponse(response);

    final transfer = audit_log.AuditLog.fromJson(data);

    log('Transferred evidence $id at $coordinates');

    di<DataService>()
        .cases
        .firstWhere((c) => c.taggedEvidence.any((e) => e.id == id))
        .taggedEvidence
        .firstWhere((e) => e.id == id)
        .auditLog
        .add(transfer);
  }
}

enum ContainerType {
  bag,
  box,
  envelope,
  other,
}

extension ContainerTypeExtension on ContainerType {
  IconData get icon {
    switch (this) {
      case ContainerType.bag:
        return Icons.shopping_bag;
      case ContainerType.box:
        return Icons.archive;
      case ContainerType.envelope:
        return Icons.mail;
      case ContainerType.other:
        return Icons.help;
    }
  }
}

extension ContainerTypeList on List<ContainerType> {
  ContainerType byName(String name) {
    return firstWhere((e) => e.name == name, orElse: () => ContainerType.other);
  }
}
