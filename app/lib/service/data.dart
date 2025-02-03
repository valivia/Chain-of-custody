// Dart imports:
import 'dart:collection';
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
  List<Case> _cases = [];
  UnmodifiableListView<Case> get cases => UnmodifiableListView(_cases);

  bool isLoading = false;

  // Current case
  Case? _currentCase;
  Case? get currentCase => _currentCase;
  set currentCase(Case? c) {
    log("set Current case: ${c?.id} changed: ${c == _currentCase}");

    if (c == _currentCase) return;

    _currentCase = c;

    if (c != null) {
      upsertCase(c);
    } else {
      log("Current case is null");
      notifyListeners();
    }
  }

  static Future<DataService> initialize() async {
    final instance = DataService();
    instance.loadFromLocalStorage();
    return instance;
  }

  clear() {
    _cases.clear();
    localStorage.removeItem("cases");
    notifyListeners();
  }

  loadFromLocalStorage() {
    final jsonCases = localStorage.getItem("cases");
    if (jsonCases != null) {
      final cases = jsonDecode(jsonCases);
      _cases = [for (var c in cases) Case.fromJson(c)];
    }

    log("Loaded cases from local storage");

    notifyListeners();
  }

  saveToLocalStorage() {
    localStorage.setItem(
      "cases",
      jsonEncode(_cases.map((c) => c.toJson()).toList()),
    );

    log("Saved cases to local storage");
  }

  Future<void> syncWithApi() async {
    if (!di.get<Authentication>().isLoggedIn) return;

    log("Syncing with API");

    isLoading = true;
    notifyListeners();

    try {
      final apiCases = await Case.fetchCases();

      for (var existingCase in _cases) {
        for (var evidence in existingCase.taggedEvidence) {
          if (evidence.offline == true) {
            evidence.offline = false;
            var apiCase = apiCases.firstWhere(
              (apiCase) => apiCase.id == existingCase.id
            );
            if (apiCase != null) {
              apiCase.taggedEvidence.add(evidence);
            } else {
              apiCases.add(existingCase);
            }
          }
        }
      }

      _cases = apiCases;

      saveToLocalStorage();
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  upsertCase(Case c) {
    final index = _cases.indexWhere((element) => element.id == c.id);

    if (index == -1) {
      _cases.add(c);
    } else {
      _cases[index] = c;
    }

    if (currentCase?.id == c.id) {
      _currentCase = c;
    }

    saveToLocalStorage();
    notifyListeners();
  }

  deleteCase(Case c) {
    _cases.removeWhere((element) => element.id == c.id);
    saveToLocalStorage();
    notifyListeners();
  }
}
