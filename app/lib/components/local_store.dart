import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:coc/service/authentication.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'dart:convert';

class LocalStore {
  static const String _boxName = 'apiCache';

  // Initialize Hive
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_boxName);
  }

  // Save API request
  static Future<void> saveApiResponse(String key, Map<String, dynamic> request) async {
    var box = Hive.box(_boxName);
    await box.put(key, request);
  }

  // Retrieve API request
  static Future<Map<String, dynamic>> getApiResponse(String key) async {
    var box = Hive.box(_boxName);
    return Map<String, dynamic>.from(box.get(key));
  }

  // Save picture metadata
  // TODO: Add caseId to the parameters
  static Future<void> savePictureMetadata(String filePath, String caseId, String coordinates) async {
    var box = Hive.box(_boxName);
    await box.add({'filePath': filePath, 'caseId': 'cm5v833zu0000vv2if2t2z3yh', 'coordinates': coordinates});
  }

  // Retrieve all pictures
  static List<Map<String, dynamic>> getAllPictures() {
    var box = Hive.box(_boxName);
    return box.values
        .where((value) => value is Map && value.containsKey('filePath') && value.containsKey('caseId'))
        .map((value) => Map<String, dynamic>.from(value))
        .toList();
  }

  // Check internet connection
  static Future<bool> hasInternetConnection() async {
    return await InternetConnectionChecker().hasConnection;
  }

  // Clear all data in the box
  static Future<void> clearApiCache() async {
    var box = Hive.box(_boxName);
    await box.clear();
  }

  // Send all saved requests
  static Future<List<Map<String, String>>> sendAllSavedRequests() async {
    var box = Hive.box(_boxName);
    List<Map<String, String>> statusList = [];

    for (var key in box.keys) {
      var value = box.get(key);
      if (value is Map && value.containsKey('url')) {
        // Handle API requests
        Map<String, dynamic> request = Map<String, dynamic>.from(value);
        try {
          final response = await http.post(
            Uri.parse(request['url']),
            headers: Map<String, String>.from(request['headers']),
            body: jsonEncode(request['body']), // Encode the body before sending
          );
          if (response.statusCode == 201 || response.statusCode == 200) {
            await box.delete(key); // Remove the request from the box if it was successfully sent
            statusList.add({'id': request['body']['id'], 'status': 'Success', 'type': 'evidence'});
          } else {
            statusList.add({'id': request['body']['id'], 'status': 'Failed: ${response.statusCode}', 'type': 'evidence'});
          }
        } catch (e) {
          statusList.add({'id': request['body']['id'], 'status': 'Error: $e'});
        }
      } else if (value is Map && value.containsKey('filePath') && value.containsKey('caseId')) {
        // Handle picture uploads
        String filePath = value['filePath'];
        String caseId = value['caseId'];
        try {
          var request = http.MultipartRequest(
            'POST',
            Uri.parse('https://coc.hootsifer.com/evidence/media'), /// Replace with your API endpoint
          );
          request.headers['Authorization'] = await Authentication.getBearerToken();
          request.fields['caseId'] = caseId;
          request.fields['coordinates'] = value['coordinates'];
          request.files.add(await http.MultipartFile.fromPath('file', filePath));

          var response = await request.send();
          if (response.statusCode == 201 || response.statusCode == 200) {
            await box.delete(key); // Remove the picture metadata from the box if it was successfully sent
            statusList.add({'id': caseId.substring(0, 5), 'status': 'Success', 'type': 'picture'});
          } else {
            statusList.add({'id': caseId.substring(0, 5), 'status': 'Failed: ${response.statusCode}', 'type': 'picure'});
          }
        } catch (e) {
          statusList.add({'filePath': filePath, 'status': 'Error: $e'});
        }
      }
    }
    return statusList;
  }

  // Get box name
  static String getBoxName() {
    return _boxName;
  }

  // Get all data for debugging
  static Future<Map<String, dynamic>> getAllData() async {
    var box = Hive.box(_boxName);
    var allData = <String, dynamic>{};

    // Convert integer keys to strings and filter out picture metadata
    var pictures = <Map<String, dynamic>>[];
    box.toMap().forEach((key, value) {
      if (value is Map && value.containsKey('filePath') && value.containsKey('caseId')) {
        pictures.add(Map<String, dynamic>.from(value));
      } else {
        allData[key.toString()] = value;
      }
    });

    // Include picture metadata separately
    allData['pictures'] = pictures;
    return allData;
  }
}