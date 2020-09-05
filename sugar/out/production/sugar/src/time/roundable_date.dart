import 'package:meta/meta.dart';

import 'package:sugar/time.dart';

mixin RoundableDate<T extends RoundableDate<T>> implements DateTime {

  T round(int value, TimeUnit unit);

  T ceil(int value, TimeUnit unit);

  T floor(int value, TimeUnit unit);

  @protected T of(int year, int month, int day, int hour, int minute, int second, int millisecond, int microsecond);

}