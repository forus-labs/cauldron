import 'package:meta/meta.dart';


const positive = 'Positive number';
const negative = 'Negative number';
const nonZero = 'Non-zero';
const unsigned = 'Unsigned number';

@immutable class Between {

  final num min;
  final num max;

  @literal const Between(this.min, this.max);

}

@immutable class Outside {

  final num min;
  final num max;

  @literal const Outside(this.min, this.max);

}


extension RoundableNumber<T extends num> on T {

  T roundTo(@nonZero num value) => value == 1 ? this : (this / value).round() * value;

  T ceilTo(@nonZero num value) => value == 1 ? this : (this / value).ceil() * value;

  T floorTo(@nonZero num value) => value == 1 ? this : (this / value).floor() * value;

}

int hash(Iterable<dynamic> values) {
  var hash = 17;
  for (final value in values) {
    hash = 37 * hash + value.hashCode;
  }

  return hash;
}