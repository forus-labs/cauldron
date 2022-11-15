import 'package:meta/meta.dart';
import 'package:sugar/core.dart';

@sealed abstract class Range<T extends Comparable<Object?>> {

  const Range._();


  bool contains(T value);

  bool containsAll(Iterable<T> values) => values.every(contains);


  bool encloses(Range<T> other);

  bool intersects(Range<T> other);

}


class Min<T extends Comparable<Object?>> extends Range<T> {

  final T value;
  final bool open;

  const Min.open(this.value): open = true, super._();

  const Min.closed(this.value): open = false, super._();

  @override
  bool contains(T value) => open ? this.value.compareTo(value) < 0 : this.value.compareTo(value) <= 0;

  @override
  bool encloses(Range<T> other) {
    if (other is Min<T>) {
      if (open) {
        final comparison = value.compareTo(value);
        return (comparison == 0 && !other.open) || (comparison < 0);



      } else {
        return value.compareTo(value) <= 0;
      }

    } else if (other is Interval<T>) {


    } else {
      return false;
    }
  }

  @override
  bool intersects(Range<T> other) {
    // TODO: implement intersects
    throw UnimplementedError();
  }

}


class Max<T extends Comparable<Object?>> extends Range<T> {

  final T value;
  final bool open;

  const Max.open(this.value): open = true, super._();

  const Max.closed(this.value): open = false, super._();

  @override
  bool contains(T value) => open ? this.value.compareTo(value) > 0 : this.value.compareTo(value) >= 0;

  @override
  bool encloses(Range<T> other) {
    // TODO: implement encloses
    throw UnimplementedError();
  }

  @override
  bool intersects(Range<T> other) {
    // TODO: implement intersects
    throw UnimplementedError();
  }

}


class Interval<T extends Comparable<Object?>> extends Range<T> {

  final Min<T> min;
  final Max<T> max;
  final bool minOpen;

  const Interval(this.min, this.max): super._();

  @override
  bool contains(T value) {
    // TODO: implement contains
    throw UnimplementedError();
  }

  @override
  bool encloses(Range<T> other) {
    // TODO: implement encloses
    throw UnimplementedError();
  }

  @override
  bool intersects(Range<T> other) {
    // TODO: implement intersects
    throw UnimplementedError();
  }

}

void a(Interval<int> interval) {
  final a = const Interval(Min.open(1), Max.closed(2));
  if (a.min.closed) { // <- How often do you want to do this? What will you use bound type for?

  }

  if (interval.lower == Bound.open);
}