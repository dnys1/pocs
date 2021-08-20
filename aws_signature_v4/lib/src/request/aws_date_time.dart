import 'dart:math';

class AWSDateTime {
  final DateTime _dateTime;

  AWSDateTime(DateTime dateTime) : _dateTime = dateTime.toUtc();

  AWSDateTime.now() : _dateTime = DateTime.now().toUtc();

  String formatFull() => formatDate() + 'T' + formatTime() + 'Z';

  String formatDate() =>
      _padZeros('${_dateTime.year}', 4) + _padZeros('${_dateTime.month}', 2) + _padZeros('${_dateTime.day}', 2);

  String formatTime() =>
      _padZeros('${_dateTime.hour}', 2) + _padZeros('${_dateTime.minute}', 2) + _padZeros('${_dateTime.second}', 2);

  static String _padZeros(String str, int length) {
    final strLength = str.length;
    return '0' * max(0, length - strLength) + str;
  }
}
