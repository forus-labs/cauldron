import 'package:meta/meta.dart';

/// A [Range] is a convex (contiguous) portion of a domain. Ranges may extend to infinity, for example, `x > 3`.
@sealed abstract class Range<T extends Comparable<Object?>> {

  const Range();

  bool contains(T value);

  bool containsAll(Iterable<T> values) => values.every(contains);


  Iterable<T> iterate({required T Function(T current) by});


  bool besides(Range<T> other);

  bool encloses(Range<T> other);

  bool intersects(Range<T> other);


  bool get empty;

}
