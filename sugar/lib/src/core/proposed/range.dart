import 'package:meta/meta.dart';

@sealed abstract class Range<T extends Comparable<Object?>> {

  static Range<T>? intersection<T extends Comparable<Object?>>(Range<T> a, Range<T> b) {

  }

  static Range<T>? gap<T extends Comparable<Object?>>(Range<T> a, Range<T> b) {

  }


  const Range._();


  Iterable<T> iterate({required T Function(T) by});


  bool contains(T value);

  bool containsAll(Iterable<T> values) => values.every(contains);


  bool besides(Range<T> other);

  bool encloses(Range<T> other);

  bool intersects(Range<T> other);


  bool get empty;

}

void a(Range<int> range) {
  for (final e in range.iterate(by: (e) => e + 1)) {
    print(e);
  }
}


class Min<T extends Comparable<Object?>> extends Range<T> {

  final T value;
  final bool open;

  const Min.open(this.value): open = true, super._();

  const Min.closed(this.value): open = false, super._();

  @override
  bool contains(T value) => open ? this.value.compareTo(value) < 0 : this.value.compareTo(value) <= 0;

  @override
  bool besides(Range<T> other) {
    // TODO: implement besides
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

  @override
  bool get empty => false;

  bool get closed => !open;

}

class Max<T extends Comparable<Object?>> extends Range<T> {

  final T value;
  final bool open;

  const Max.open(this.value): open = true, super._();

  const Max.closed(this.value): open = false, super._();

  @override
  bool contains(T value) {
    // TODO: implement contains
    throw UnimplementedError();
  }

  @override
  bool besides(Range<T> other) {
    // TODO: implement besides
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

  @override
  bool get empty => false;

  bool get closed => !open;

}

class Interval<T extends Comparable<Object?>> extends Range<T> {

  final T min;
  final bool minOpen;
  final T max;
  final bool maxOpen;

  Interval.open(this.min, this.max): minOpen = true, maxOpen = true, super._();

  Interval.openClosed(this.min, this.max): minOpen = true, maxOpen = false, super._();

  Interval.closed(this.min, this.max): minOpen = false, maxOpen = false, super._();

  Interval.closedOpen(this.min, this.max): minOpen = false, maxOpen = true, super._();

  @override
  bool contains(T value) {
    // TODO: implement contains
    throw UnimplementedError();
  }

  @override
  bool besides(Range<T> other) {
    // TODO: implement besides
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

  @override
  // TODO: implement empty
  bool get empty => minOpen != maxOpen &&

}