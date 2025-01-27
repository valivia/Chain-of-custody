// Dart imports:
import 'dart:convert';
import 'dart:developer';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:localstorage/localstorage.dart';
import 'package:watch_it/watch_it.dart';

// Project imports:
import 'package:coc/controllers/case.dart';
import 'package:coc/service/authentication.dart';

class DataService extends ChangeNotifier {
  // Cases
  Map<String, Case> _cases = {};
  List<Case> get cases => _cases.values.toList();

  // Current case
  Case? _currentCase;
  Case? get currentCase => _currentCase;
  set currentCase(Case? c) {
    log("set Current case: ${c?.id} ${c == _currentCase}");
    if (c != null) {
      _cases[c.id] = c;
      saveToLocalStorage();
    } else {
      log("Current case is null");
    }
    _currentCase = c;
    notifyListeners();
  }

  static Future<DataService> initialize() async {
    final instance = DataService();
    instance.loadFromLocalStorage();
    await instance.syncWithApi();
    return instance;
  }

  clear() {
    _cases = {};
    localStorage.removeItem("cases");
    notifyListeners();
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
    if (!di.get<Authentication>().isLoggedIn) return;

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

  upsertCase(Case c) {
    _cases[c.id] = c;
    saveToLocalStorage();
    notifyListeners();
  }

  deleteCase(Case c) {
    _cases.remove(c.id);
    saveToLocalStorage();
    notifyListeners();
  }
}
