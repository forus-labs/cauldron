extension RoundableNumber<T extends num> on T {

  T roundTo(num value) => value == 1 ? this : (this / value).round() * value;

  T ceilTo(num value) => value == 1 ? this : (this / value).ceil() * value;

  T floorTo(num value) => value == 1 ? this : (this / value).floor() * value;

}

T min<T extends Comparable<T>>(T a, T b) => a.compareTo(b) < 0 ? a : b;

T max<T extends Comparable<T>>(T a, T b) => a.compareTo(b) < 0 ? b : a;

int hash(Iterable<dynamic> values) {
  var hash = 17;
  for (final value in values) {
    hash = 37 * hash + value.hashCode;
  }

  return hash;
}