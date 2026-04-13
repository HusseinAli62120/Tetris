import 'package:tetris/utils/values.dart';

class HelperFunctions {
  int findRow(int position) {
    return (position / rowLength).floor();
  }

  int findColumn(int position) {
    return position % rowLength;
  }

  String convertSecondsToMinutes(int ticks) {
    // ~/ is division that rounds down the fractional part to the nearest integer
    int seconds = ticks ~/ 1000;
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;

    String timeType = "";
    if (minutes > 0) {
      timeType = "minutes";
    } else {
      timeType = "seconds";
    }
    return "$minutes:${remainingSeconds.toString().padLeft(2, '0')} $timeType";
  }
}
