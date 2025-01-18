import 'package:coc/controllers/case.dart';

class DataService {
  List<Case> _cases = [];

  DataService._();

  static Future<DataService> load() async {
    var instance = DataService._();
    await instance.syncWithApi();
    return instance;
  }

  Future<void> syncWithApi() async {
    _cases = await Case.fetchCases();
  }

  List<Case> get cases => _cases;
}
