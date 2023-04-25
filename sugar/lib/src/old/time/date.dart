import 'package:meta/meta.dart';
import 'package:sugar/core.dart';
import 'package:sugar/math.dart';
import 'package:sugar/time.dart';

part 'local_date.dart';

/// Represents a temporal that contains units of date.
@internal abstract class Date {

  final DateTime _native;

  /// Creates a [Date] from the given days since Unix epoch.
  Date.fromEpochDaysAsUtc(EpochDays days): _native = DateTime.fromMillisecondsSinceEpoch(days * Duration.millisecondsPerDay, isUtc: true);

  /// Creates a [Date] from the given seconds since Unix epoch, floored to the nearest day.
  Date.fromEpochSecondsAsUtc(EpochSeconds seconds): _native = DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: true);

  /// Creates a [Date] from the given milliseconds since Unix epoch, floored to the nearest day.
  Date.fromEpochMillisecondsAsUtc(EpochMilliseconds milliseconds): _native = DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: true);

  /// Creates a [Date] from the native [DateTime].
  Date.fromNativeDateTime(DateTime date): _native = DateTime.utc(date.year, date.month, date.day);

  /// Creates a [Date].
  Date(int year, [int month = 1, int day = 1]): _native = DateTime.utc(year, month, day);

  Date._copy(this._native);

  /// The year.
  int get year => _native.year;
  /// The month.
  int get month => _native.month;
  /// The day.
  int get day => _native.day;

}
