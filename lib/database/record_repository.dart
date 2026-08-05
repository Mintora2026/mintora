import 'package:flutter/foundation.dart';

import '../models/record_model.dart';
import 'database_helper.dart';

class RecordRepository extends ChangeNotifier {
  RecordRepository._();

  static final RecordRepository instance = RecordRepository._();

  final List<RecordModel> _records = [];

  List<RecordModel> getAll() {
    return List.unmodifiable(_records);
  }

  Future<void> loadRecords() async {
    final records = await DatabaseHelper.instance.getRecords();

    _records
      ..clear()
      ..addAll(records);

    notifyListeners();
  }

  Future<void> addRecord(RecordModel record) async {
    await DatabaseHelper.instance.insertRecord(record);

    _records.insert(0, record);

    notifyListeners();
  }

  Future<void> removeRecord(String id) async {
    await DatabaseHelper.instance.deleteRecord(id);

    _records.removeWhere((record) => record.id == id);

    notifyListeners();
  }

  Future<void> clear() async {
    await DatabaseHelper.instance.clearRecords();

    _records.clear();

    notifyListeners();
  }

  int get totalRecords => _records.length;

  int get totalGrowthPoints =>
      _records.fold(0, (sum, record) => sum + record.growthPoints);
}