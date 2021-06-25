import 'package:meta/meta.dart';
import 'package:sugar/core.dart';

/// Maps a value of type [T] to [R}.
typedef Apply<T, R> = R Function(T value);


/// Represents an immutable key-value pair.
@immutable class Pair<K, V> with Equality implements MapEntry<K, V> {

  /// The key.
  @override final K key;
  /// The value.
  @override final V value;
  /// The fields in this [Pair].
  @override final List<dynamic> fields;

  /// Creates a [Pair] with the given key and value.
  Pair(this.key, this.value): fields = List.unmodifiable([key, value]);


  /// Creates a [Pair] which key and/or value has been replaced.
  Pair<K, V> replace({K? key, V? value}) => Pair(key ?? this.key, value ?? this.value);

  /// Creates a [Pair] which key and value has been mapped using [key] and [value].
  Pair<K1, V1> map<K1, V1>(Apply<K, K1> key, Apply<V, V1> value) => Pair(key(this.key), value(this.value));

  /// Reduces [key] and [value] using [reduce].
  T reduce<T>(T Function(K, V) reduce) => reduce(key, value);

}

/// Represents an immutable tuple that contains 3 values.
@immutable class Triple<L, M, R> with Equality {

  /// The left value.
  final L left;
  /// The middle value.
  final M middle;
  /// The right value.
  final R right;
  /// The fields in this [Triple].
  @override final List<dynamic> fields;

  /// Creates a [Triple] with the given left, middle and right values.
  Triple(this.left, this.middle, this.right): fields = List.unmodifiable([left, middle, right]);


  /// Creates a [Triple] which left, middle and/or right values have been replaced.
  Triple<L, M, R> replace({L? left, M? middle, R? right}) => Triple(left ?? this.left, middle ?? this.middle, right ?? this.right);

  /// Creates a [Triple] which left, middle and right values have been mapped using [left], [middle] and [right].
  Triple<L1, M1, R1> map<L1, M1, R1>(Apply<L, L1> left, Apply<M, M1> middle, Apply<R, R1> right) => Triple(left(this.left), middle(this.middle), right(this.right));

  /// Reduces [left], [middle] and [right] using [reduce].
  T reduce<T>(T Function(L, M, R) reduce) => reduce(left, middle, right);

}

/// Represents an immutable tuple that contains 4 values.
@immutable class Quad<T1, T2, T3, T4> with Equality {

  /// The first value.
  final T1 first;
  /// The second value.
  final T2 second;
  /// The third value.
  final T3 third;
  /// The fourth value.
  final T4 fourth;
  /// The fields in this [Quad].
  @override final List<dynamic> fields;

  /// Creates a [Quad] with the given first, second, third and fourth values.
  Quad(this.first, this.second, this.third, this.fourth): fields = List.unmodifiable([first, second, third, fourth]);


  /// Creates a [Quad] which first, second, third and/or fourth values have been replaced.
  Quad<T1, T2, T3, T4> replace({T1? first, T2? second, T3? third, T4? fourth}) => Quad(first ?? this.first, second ?? this.second, third ?? this.third, fourth ?? this.fourth);

  /// Creates a [Quad] which first, second, third and fourth values have been mapped using [first], [second], [third] and [fourth].
  Quad<R1, R2, R3, R4> map<R1, R2, R3, R4>(Apply<T1, R1> first, Apply<T2, R2> second, Apply<T3, R3> third, Apply<T4, R4> fourth)
  => Quad(first(this.first), second(this.second), third(this.third), fourth(this.fourth));

  /// Reduces [first], [second], [third] and [fourth] using [reduce].
  T reduce<T>(T Function(T1, T2, T3, T4) reduce) => reduce(first, second, third, fourth);

}


/// Provides functions to convert [Iterable]s of lists into [Iterable]s of tuples.
extension TupleIterable on Iterable<Iterable<dynamic>> {

  /// Creates an [Iterable] of [Pair]s from an [Iterable] of lists. Each list should
  /// contain 2 values.
  Iterable<Pair<K, V>> pairs<K, V>() sync* {
    for (final iterable in this) {
      if (iterable.length == 2) {
        yield Pair<K, V>(iterable.elementAt(0), iterable.elementAt(1));

      } else {
        throw ArgumentError.value('Pair has a length of: ${iterable.length}, should be 2');
      }
    }
  }

  /// Creates an [Iterable] of [Triple]s from an [Iterable] of lists. Each list should
  /// contain 3 values.
  Iterable<Triple<L, M, R>> triples<L, M, R>() sync* {
    for (final iterable in this) {
      if (iterable.length == 3) {
        yield Triple<L, M, R>(iterable.elementAt(0), iterable.elementAt(1), iterable.elementAt(2));

      } else {
        throw ArgumentError.value(iterable, 'Triple has a length of: ${iterable.length}, should be 3');
      }
    }
  }

  /// Creates an [Iterable] of [Quad]s from an [Iterable] of lists. Each list should
  /// contain 4 values.
  Iterable<Quad<T1, T2, T3, T4>> quads<T1, T2, T3, T4>() sync* {
    for (final iterable in this) {
      if (iterable.length == 4) {
        yield Quad<T1, T2, T3, T4>(iterable.elementAt(0), iterable.elementAt(1), iterable.elementAt(2), iterable.elementAt(3));

      } else {
        throw ArgumentError.value(iterable, 'Quad has a length of: ${iterable.length}, should be 4');
      }
    }
  }

}