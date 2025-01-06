import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';
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
    Map<String, dynamic> request = Map<String, dynamic>.from(box.get(key));
    try {
      final response = await http.post(
        Uri.parse(request['url']),
        headers: Map<String, String>.from(request['headers']),
        body: jsonEncode(request['body']), // Encode the body before sending
      );
      if (response.statusCode == 200) {
        await box.delete(key); // Remove the request from the box if it was successfully sent
        statusList.add({'id': request['body']['id'], 'status': 'Success'});
      } else {
        statusList.add({'id': request['body']['id'], 'status': 'Failed: ${response.statusCode}'});
      }
    } catch (e) {
      statusList.add({'id': request['body']['id'], 'status': 'Error: $e'});
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
    return Map<String, dynamic>.from(box.toMap());
  }
}