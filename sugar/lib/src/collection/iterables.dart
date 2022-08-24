/// Provides functions for working with iterables.
extension Iterables<E> on Iterable<E> {

  /// Creates a map that associates a value returned by the given function with an element in this iterable. An earlier
  /// association will be overridden by a newer association if duplicate keys exist.
  ///
  /// This function is meant for mapping a single key to a single element in this iterable, (1:1). For aggregating several
  /// elements by the same key, (1:N), it is recommended to use the functions in `Group` instead.
  ///
  /// ```dart
  /// class Foo {
  ///   final String id;
  ///
  ///   Foo(this.id);
  /// }
  ///
  /// final map = [Foo('A'), Foo('B'), Foo('C')].preimage((foo) => foo.id);
  /// print(map); // { 'A': Foo('A'), 'B': Foo('B'), 'C': Foo('C') }
  /// ```
  Map<R, E> preimage<R>(R Function(E element) function) => { for (final element in this) function(element): element };

}
