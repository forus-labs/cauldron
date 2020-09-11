import 'package:meta/meta.dart';

import 'package:sugar/core.dart';

typedef Apply<T, R> = R Function(T value);


@immutable class Pair<K, V> with Equality implements MapEntry<K, V> {

  @override final K key;
  @override final V value;
  @override final List<dynamic> fields;

  Pair(this.key, this.value): fields = List.unmodifiable([key, value]);


  Pair<K, V> replace({K key, V value}) => Pair(key ?? this.key, value ?? this.value);

  Pair<K1, V1> map<K1, V1>(Apply<K, K1> key, Apply<V, V1> value) => Pair(key(this.key), value(this.value));

  T reduce<T>(T Function(K, V) reduce) => reduce(key, value);

}

@immutable class Triple<L, M, R> with Equality {

  final L left;
  final M middle;
  final R right;
  @override final List<dynamic> fields;

  Triple(this.left, this.middle, this.right): fields = List.unmodifiable([left, middle, right]);


  Triple<L, M, R> replace({L left, M middle, R right}) => Triple(left ?? this.left, middle ?? this.middle, right ?? this.right);

  Triple<L1, M1, R1> map<L1, M1, R1>(Apply<L, L1> left, Apply<M, M1> middle, Apply<R, R1> right) => Triple(left(this.left), middle(this.middle), right(this.right));

  T reduce<T>(T Function(L, M, R) reduce) => reduce(left, middle, right);

}

@immutable class Quad<T1, T2, T3, T4> with Equality {

  final T1 first;
  final T2 second;
  final T3 third;
  final T4 fourth;
  @override final List<dynamic> fields;

  Quad(this.first, this.second, this.third, this.fourth): fields = List.unmodifiable([first, second, third, fourth]);


  Quad<T1, T2, T3, T4> replace({T1 first, T2 second, T3 third, T4 fourth}) => Quad(first ?? this.first, second ?? this.second, third ?? this.third, fourth ?? fourth);

  Quad<R1, R2, R3, R4> map<R1, R2, R3, R4>(Apply<T1, R1> first, Apply<T2, R2> second, Apply<T3, R3> third, Apply<T4, R4> fourth)
                          => Quad(first(this.first), second(this.second), third(this.third), fourth(this.fourth));

  T reduce<T>(T Function(T1, T2, T3, T4) reduce) => reduce(first, second, third, fourth);

}


extension TupleIterable on Iterable<Iterable<dynamic>> {

  Iterable<Pair<K, V>> pairs<K, V>() sync* {
    for (final iterable in this) {
      if (iterable.length == 2) {
        yield Pair<K, V>(iterable.elementAt(0), iterable.elementAt(1));

      } else {
        throw ArgumentError.value(iterable, 'Pair has a length of: ${iterable.length}, should be 2');
      }
    }
  }

  Iterable<Triple<L, M, R>> triples<L, M, R>() sync* {
    for (final iterable in this) {
      if (iterable.length == 3) {
        yield Triple<L, M, R>(iterable.elementAt(0), iterable.elementAt(1), iterable.elementAt(2));

      } else {
        throw ArgumentError.value(iterable, 'Triple has a length of: ${iterable.length}, should be 3');
      }
    }
  }

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