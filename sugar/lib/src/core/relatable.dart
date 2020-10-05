import 'package:meta/meta.dart';

/// A skeleton that implements comparison operators using [compareTo].
mixin Relatable<T extends Relatable<T>> implements Comparable<T> {

  @override
  bool operator == (dynamic other) => identical(this, other) || (runtimeType == other.runtimeType && compareTo(other) == 0);

  bool operator < (T other) => compareTo(other) < 0;

  bool operator > (T other) => other < this;

  bool operator <= (T other) => !(this > other);

  bool operator >= (T other) => !(this < other);

  @override
  int get hashCode => hash;

  /// The hashCode for this [Relatable].
  @protected int get hash;

}