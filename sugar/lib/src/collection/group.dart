
/// An intermediate operation for grouping elements in an [Iterable].
///
/// See [Groups] for more information.
typedef Group<E> = Iterable<E> Function();

/// Provides functions for grouping elements in an [Iterable].
extension Groups<E> on Group<E> {

  /// Groups the elements in an [Iterable] by the returned values of the given function. The grouped elements are subsequently
  /// combined using the given [as] function.
  ///
  /// ```dart
  /// final counts = ['a', 'b', 'aa', 'bb', 'cc'].group.by((string) => string.length, as: (count, string) => (count ?? 0) + 1);
  /// expect(counts, {1: 2, 2: 3});
  /// ```
  Map<K, V> by<K, V>(K Function(E) by, {required V Function(V? previous, E current) as}) {
    final results = <K, V>{};
    for (final element in this()) {
      final key = by(element);
      results[key] = as(results[key], element);
    }

    return results;
  }

  /// Groups the elements in an [Iterable] by the returned values of the given function.
  ///
  /// ```dart
  /// final aggregate = ['a', 'b', 'aa', 'bb', 'cc'].group.lists(by: (string) => string.length);
  /// expect(aggregate, {1: ['a', 'b'], 2: ['aa', 'bb', 'cc']});
  /// ```
  Map<K, List<E>> lists<K>({required K Function(E) by}) {
    final results = <K, List<E>>{};
    for (final element in this()) {
      (results[by(element)] ??= []).add(element);
    }

    return results;
  }

  /// Groups the elements in an [Iterable] by the returned values of the given function.
  ///
  /// ```dart
  /// final aggregate = ['a', 'b', 'aa', 'bb', 'cc'].group.sets(by: (string) => string.length);
  /// expect(aggregate, {1: {'a', 'b'}, 2: {'aa', 'bb', 'cc'}});
  /// ```
  Map<K, Set<E>> sets<K>({required K Function(E) by}) {
    final results = <K, Set<E>>{};
    for (final element in this()) {
      (results[by(element)] ??= {}).add(element);
    }

    return results;
  }

}
