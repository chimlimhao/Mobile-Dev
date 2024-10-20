// import 'dart:ffi';

class MyDuration {
  final int _milliseconds;

  MyDuration(this._milliseconds) {
    if (_milliseconds < 0) {
      throw Exception('Duration cannot be negative!');
    }
  }
  MyDuration.fromHours(int hours) : _milliseconds = hours * 3600000;
  MyDuration.fromMinutes(int minutes) : _milliseconds = minutes * 60000;
  MyDuration.fromSeconds(int seconds) : _milliseconds = seconds * 1000;

  // Display the duration in a readable format
  @override
  String toString() {
    int seconds = (_milliseconds / 1000).round();
    int minutes = (seconds / 60).floor();
    seconds = seconds % 60;
    int hours = (minutes / 60).floor();
    minutes = minutes % 60;
    return '$hours hours, $minutes minutes, $seconds seconds';
  }

  MyDuration operator +(MyDuration md) {
    return MyDuration(_milliseconds + md._milliseconds);
  }

  MyDuration operator -(MyDuration md) {
    int result = _milliseconds - md._milliseconds;
    if (result < 0) {
      result = 0;
      throw Exception('The result cannot be negative!');
    }
    return MyDuration(result);
  }

  bool operator >(MyDuration md) {
    return _milliseconds > md._milliseconds;
  }
}

void main() {
  MyDuration duration1 = MyDuration.fromHours(3); // 3 hours
  MyDuration duration2 = MyDuration.fromMinutes(45); // 45 minutes
  print(duration1 + duration2); // 3 hours, 45 minutes, 0 seconds
  print(duration1 > duration2); //true

  try {
    print(duration2 - duration1); // This will throw an exception
  } catch (e) {
    print(e);
  }
}
