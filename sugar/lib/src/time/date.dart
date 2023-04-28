import 'package:meta/meta.dart';
import 'package:sugar/sugar.dart';

part 'local_date.dart';

/// A temporal that contains units of date.
@internal abstract class Date {

  final DateTime _native;

  /// Creates a [Date] from the days since Unix epoch.
  Date.fromEpochDays(EpochDays days): _native = DateTime.fromMillisecondsSinceEpoch(days * Duration.millisecondsPerDay, isUtc: true);

  /// Creates a [Date] from the milliseconds since Unix epoch, floored to the nearest day.
  Date.fromEpochMilliseconds(EpochMilliseconds milliseconds): _native = DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: true);

  /// Creates a [Date] from the microseconds since Unix epoch, floored to the nearest day.
  Date.fromEpochMicroseconds(EpochMicroseconds microseconds): _native = DateTime.fromMicrosecondsSinceEpoch(microseconds, isUtc: true);

  /// Creates a [Date] from the native [DateTime].
  Date.fromNative(DateTime date): _native = DateTime.utc(date.year, date.month, date.day);

  /// Creates a [Date].
  Date(int year, [int month = 1, int day = 1]): _native = DateTime.utc(year, month, day);

  Date._(this._native);

  /// The year.
  int get year => _native.year;
  /// The month.
  int get month => _native.month;
  /// The day.
  int get day => _native.day;

}
