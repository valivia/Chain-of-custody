// Dart imports:
import 'dart:convert';
import 'dart:developer';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:localstorage/localstorage.dart';

// Project imports:
import 'package:coc/controllers/case.dart';

class DataService extends ChangeNotifier {
  Map<String, Case> _cases = {};

  static Future<DataService> initialize() async {
    final instance = DataService();
    instance.loadFromLocalStorage();
    await instance.syncWithApi();
    return instance;
  }

  loadFromLocalStorage() {
    final jsonCases = localStorage.getItem("cases");
    if (jsonCases != null) {
      final cases = jsonDecode(jsonCases);
      _cases = {for (var c in cases) c["id"]: Case.fromJson(c)};
    }

    log("Loaded cases from local storage");

    notifyListeners();
  }

  saveToLocalStorage() {
    localStorage.setItem(
      "cases",
      jsonEncode(_cases.values.map((c) => c.toJson()).toList()),
    );

    log("Saved cases to local storage");
  }

  Future<void> syncWithApi() async {
    try {
      final apiCases = await Case.fetchCases();
      final apiCasesMap = {for (var c in apiCases) c.id: c};

      _cases = apiCasesMap;

      saveToLocalStorage();
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  List<Case> get cases => _cases.values.toList();
}
