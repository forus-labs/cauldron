import 'package:meta/meta.dart';

import 'package:sugar/core.dart' as math show round, ceil, floor;
import 'package:sugar/time.dart';

int _unzero(int value) => value == 0 ? 1 : value;

mixin RoundableDateTime<T extends RoundableDateTime<T>> implements DateTime {

  T round(int value, TimeUnit unit) => _adjust(value, unit, math.round);

  T ceil(int value, TimeUnit unit) => _adjust(value, unit, math.ceil);

  T floor(int value, TimeUnit unit) => _adjust(value, unit, math.floor);


  T _adjust(int value, TimeUnit unit, int Function(int, int) function) {
    switch (unit) {
      case TimeUnit.year:
        return of(function(year, value), month, day, hour, minute, second, millisecond, microsecond);
      case TimeUnit.month:
        return of(year, _unzero(function(month, value)), day, hour, minute, second, millisecond, microsecond);
      case TimeUnit.day:
        return of(year, month, _unzero(function(day, value)), hour, minute, second, millisecond, microsecond);
      case TimeUnit.hour:
        return of(year, month, day, function(hour, value), minute, second, millisecond, microsecond);
      case TimeUnit.minute:
        return of(year, month, day, hour, function(minute, value), second, millisecond, microsecond);
      case TimeUnit.second:
        return of(year, month, day, hour, minute, function(second, value), millisecond, microsecond);
      case TimeUnit.millisecond:
        return of(year, month, day, hour, minute, second, function(millisecond, value), microsecond);
      case TimeUnit.microsecond:
        return of(year, month, day, hour, minute, second, millisecond, function(microsecond, value));
      default:
        throw UnimplementedError('DateTime does not support adjustment of ${unit}s');
    }
  }

  // TODO: Replace with function parameter once https://github.com/dart-lang/language/issues/216 is resolved
  @protected T of(int year, int month, int day, int hour, int minute, int second, int millisecond, int microsecond);

}

extension DefaultRoundableDate on DateTime {

  DateTime round(int value, TimeUnit unit) => _adjust(value, unit, math.round);

  DateTime ceil(int value, TimeUnit unit) => _adjust(value, unit, math.ceil);

  DateTime floor(int value, TimeUnit unit) => _adjust(value, unit, math.floor);


  DateTime _adjust(int value, TimeUnit unit, int Function(int, int) function) {
    switch (unit) {
      case TimeUnit.year:
        return _of(function(year, value), month, day, hour, minute, second, millisecond, microsecond);
      case TimeUnit.month:
        return _of(year, _unzero(function(month, value)), day, hour, minute, second, millisecond, microsecond);
      case TimeUnit.day:
        return _of(year, month, _unzero(function(day, value)), hour, minute, second, millisecond, microsecond);
      case TimeUnit.hour:
        return _of(year, month, day, function(hour, value), minute, second, millisecond, microsecond);
      case TimeUnit.minute:
        return _of(year, month, day, hour, function(minute, value), second, millisecond, microsecond);
      case TimeUnit.second:
        return _of(year, month, day, hour, minute, function(second, value), millisecond, microsecond);
      case TimeUnit.millisecond:
        return _of(year, month, day, hour, minute, second, function(millisecond, value), microsecond);
      case TimeUnit.microsecond:
        return _of(year, month, day, hour, minute, second, millisecond, function(microsecond, value));
      default:
        throw UnimplementedError('DateTime does not support adjustment of ${unit}s');
    }
  }

  DateTime _of(int year, int month, int day, int hour, int minute, int second, int millisecond, int microsecond) =>
      isUtc ? DateTime.utc(year, month, day, hour, minute, second, millisecond, microsecond)
            : DateTime(year, month, day, hour, minute, second, millisecond, microsecond);

}
