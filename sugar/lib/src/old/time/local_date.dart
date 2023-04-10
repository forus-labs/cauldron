import 'package:sugar/core.dart';
import 'package:sugar/time.dart';

/// Represents a date without a timezone.
abstract class LocalDate {

  static const _days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

  final int year;
  final int month;
  final int day;

  @Possible({RangeError})
  LocalDate(this.year, this.month, this.day) {
    RangeError.checkValidRange(0, null, year, null, null, 'Year is $year. Valid range: "0 <= year"');
    RangeError.checkValidRange(1, 12, month, null, null, 'Month is $month. Valid range:  "1 <= month <= 12"');

    final days = leapYear && month == 2 ?  29 : _days[month - 1];
    RangeError.checkValidRange(1, days, day, null, null, 'Day is $day. Valid range: "1 <= day <= $days"');
  }

  LocalDate.fromEpochDay();

  LocalDate.from

  LocalDate._(this.year, this.month, this.day);

  LocalDate truncate({required DateUnit to});

  LocalDate add({int year = 0, int month = 0, int day = 0});

  LocalDate subtract({int year = 0, int month = 0, int day = 0});

  LocalDate operator + (Duration duration);

  LocalDate operator - (Duration duration);

  LocalDate round(int value, TimeUnit unit) => _adjust(value, unit, (time, to) => time.roundTo(to));

  LocalDate ceil(int value, TimeUnit unit) => _adjust(value, unit, (time, to) => time.ceilTo(to));

  LocalDate floor(int value, TimeUnit unit) => _adjust(value, unit, (time, to) => time.floorTo(to));

  toEpochDay();


  int firstDayOfMonth;

  int lastDayOfMonth;

  int firstDayOfWeek;

  int lastDayOfWeek;

}