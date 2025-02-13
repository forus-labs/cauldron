/// Provides low-level functions for working with times.
///
/// These functions should only be used when it is not feasible to use `sugar.time`, such as when working with 3rd-party
/// date-time types.
extension Times on Never {
  /// Formats the time as a ISO-8601 time.
  ///
  /// ```dart
  /// Times.format(20, 30, 40, 5, 6); // 20:30:40.005006
  /// ```
  static String format(int hour, [int minute = 0, int second = 0, int millisecond = 0, int microsecond = 0]) {
    final hours = hour.toString().padLeft(2, '0');
    final minutes = minute.toString().padLeft(2, '0');

    final seconds = second == 0 && millisecond == 0 && microsecond == 0 ? '' : ':${second.toString().padLeft(2, '0')}';
    final milliseconds = millisecond == 0 && microsecond == 0 ? '' : '.${millisecond.toString().padLeft(3, '0')}';
    final microseconds = microsecond == 0 ? '' : microsecond.toString().padLeft(3, '0');

    return '$hours:$minutes$seconds$milliseconds$microseconds';
  }
}
