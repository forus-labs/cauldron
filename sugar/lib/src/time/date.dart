import 'package:meta/meta.dart';
import 'package:sugar/src/core/constants.dart';
import 'package:sugar/sugar.dart';

part 'local_date.dart';

/// A date.
@internal abstract class Date {

  final DateTime _native;

  /// Creates a [Date] from the days since Unix epoch.
  Date.fromEpochDays(EpochDays days): _native = DateTime.fromMillisecondsSinceEpoch(days * Duration.millisecondsPerDay, isUtc: true);

  /// Creates a [Date] from the [milliseconds] since Unix epoch, floored to the nearest day.
  Date.fromEpochMilliseconds(EpochMilliseconds milliseconds):
    _native = DateTime.fromMillisecondsSinceEpoch(milliseconds.floorTo(Duration.millisecondsPerDay), isUtc: true);

  /// Creates a [Date] from the [microseconds] since Unix epoch, floored to the nearest day.
  Date.fromEpochMicroseconds(EpochMicroseconds microseconds): 
    _native = DateTime.fromMicrosecondsSinceEpoch(microseconds.floorTo(Duration.microsecondsPerDay), isUtc: true);

  /// Creates a [Date].
  Date(int year, [int month = 1, int day = 1]): _native = DateTime.utc(year, month, day);

  Date._(this._native): 
    assert(_native.isUtc, '$_native is in local timezone. Should be UTC. $issueTracker'),
    assert(_native.hour == 0, 'Hour is ${_native.hour}. Should be 0. $issueTracker'),
    assert(_native.minute == 0, 'Minute is ${_native.minute}. Should be 0. $issueTracker'),
    assert(_native.second == 0, 'Second is ${_native.second}. Should be 0. $issueTracker'),
    assert(_native.millisecond == 0, 'Millisecond is ${_native.millisecond}. Should be 0. $issueTracker'),
    assert(_native.microsecond == 0, 'Microsecond is ${_native.microsecond}. Should be 0. $issueTracker');

  /// The year.
  int get year => _native.year;
  /// The month.
  int get month => _native.month;
  /// The day.
  int get day => _native.day;

}
