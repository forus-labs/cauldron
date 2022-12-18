import 'package:sugar/core_range.dart';
import 'package:sugar/src/core/range/range_collision.dart';

class Max<T extends Comparable<Object?>> extends Range<T> {

  final T value;
  final bool open;

  const Max.open(this.value): open = true;

  const Max.closed(this.value): open = false;

  @override
  bool contains(T value) => this.value.compareTo(value) >= (closed ? 0 : 1);

  @override
  Iterable<T> iterate({required T Function(T current) by}) sync* {
    for (var current = closed ? value : by(value); contains(current); current = by(current)) {
      yield current;
    }
  }

  @override
  bool besides(Range<T> other) {
    if (other is Min<T>) {
      return Besides.minMax(other, this);

    } else if (other is Interval<T>) {
      return Besides.maxInterval(this, other);

    } else {
      return false;
    }
  }

  @override
  bool encloses(Range<T> other) {
    if (other is Max<T>) {
      // return contains(other.value); this does not work because of other's closed/opened status

    } else if (other is Interval<T>) {
      // return contains(other.max);

    } else {
      return false;
    }
  }

  @override
  bool intersects(Range<T> other) {
    // TODO: implement intersects
    throw UnimplementedError();
  }

  @override
  bool get empty => false;

  bool get closed => !open;


  @override
  bool operator ==(Object other) => identical(this, other) || other is Max && runtimeType == other.runtimeType
                && value == other.value && open == other.open;

  @override
  int get hashCode => value.hashCode ^ open.hashCode;

  @override
  String toString() => '(-∞..$value${open ? ')' : ']'}';
}