import 'package:meta/meta.dart';

// ignore_for_file: public_member_api_docs

/// A skeleton that implements comparison operators using [compareTo].
mixin Relatable<T extends Relatable<T>> implements Comparable<T> {

  @override
  bool operator == (dynamic other) => identical(this, other) || (runtimeType == other.runtimeType && compareTo(other) == 0);

  bool operator < (T other) => compareTo(other) < 0;

  bool operator > (T other) => other < (this as T);


  bool operator <= (T other) => !(this > other);

  bool operator >= (T other) => !(this < other);

  @override
  int get hashCode => hash;

  /// The hashCode for this [Relatable].
  @protected int get hash;

}