import 'package:hive/hive.dart';

class ScoresService {
  Box? _box;

  final _boxName = "Scores";
  // Ensure the box is open.
  Future<Box> _getBox(String boxName) async {
    if (_box != null && _box!.isOpen) return _box!;
    _box = await Hive.openBox(boxName);
    return _box!;
  }

  // Write
  Future<void> write(dynamic key, int score) async {
    final scoreBox = await _getBox(_boxName);
    await scoreBox.put(key, score);
    // print("Score written");
  }

  // Read
  Future<int> read(dynamic key) async {
    final scoreBox = await _getBox(_boxName);
    final score = await scoreBox.get(key);
    // print("Score read: $score");
    return score;
  }

  // Get all
  Future<Map<dynamic, dynamic>> getAll() async {
    final scoreBox = await _getBox(_boxName);
    final scores = scoreBox.toMap();
    // print(scores);
    return scores;
  }
}
