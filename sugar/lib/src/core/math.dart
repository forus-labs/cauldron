extension RoundableNumber<T extends num> on T {

  T roundTo(num value) => round(this, value);

  T ceilTo(num value) => ceil(this, value);

  T floorTo(num value) => floor(this, value);

}


T round<T extends num>(T value, num nearest) =>  nearest == 1 ? value : (value / nearest).round() * nearest;

T ceil<T extends num>(T value, num nearest) =>  nearest == 1 ? value : (value / nearest).ceil() * nearest;

T floor<T extends num>(T value, num nearest) =>  nearest == 1 ? value : (value / nearest).floor() * nearest;


T min<T extends Comparable<T>>(T a, T b) => a.compareTo(b) < 0 ? a : b;

T max<T extends Comparable<T>>(T a, T b) => a.compareTo(b) < 0 ? b : a;

int hash(Iterable<dynamic> values) {
  var hash = 17;
  for (final value in values) {
    hash = 37 * hash + value.hashCode;
  }

  return hash;
}