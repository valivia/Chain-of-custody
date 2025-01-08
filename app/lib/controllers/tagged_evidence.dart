import 'package:coc/utility/helpers.dart';
import 'package:latlong2/latlong.dart';

class TaggedEvidence {
  String id;
  String userId;
  String evidenceId;

  DateTime createdAt;
  DateTime updatedAt;
  DateTime madeOn;

  String containerType;
  String itemType;
  String description;

  LatLng originCoordinates;
  String originLocationDescription;

  TaggedEvidence({
    required this.id,
    required this.userId,
    required this.evidenceId,
    required this.createdAt,
    required this.updatedAt,
    required this.madeOn,
    required this.containerType,
    required this.itemType,
    required this.description,
    required this.originCoordinates,
    required this.originLocationDescription,
  });

  factory TaggedEvidence.fromJson(Map<String, dynamic> json) {
    return TaggedEvidence(
      id: json['id'] as String,
      userId: json['userId'] as String,
      evidenceId: json['evidenceId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      madeOn: DateTime.parse(json['madeOn'] as String),
      containerType: json['containerType'] as String,
      itemType: json['itemType'] as String,
      description: json['description'] as String,
      originCoordinates: coordinatesFromString(json['originCoordinates'] as String),
      originLocationDescription: json['originLocationDescription'] as String,
    );
  }
}
