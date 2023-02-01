/// Provides functions for working with [StringBuffer]s.
extension StringBuffers on StringBuffer {

  /// Adds the string representation of [object] with the given [enclosing] string to this buffer.
  ///
  /// ```dart
  /// final buffer = StringBuffer()..writeEnclosed('hello world');
  /// buffer.toString(); // "'hello world'"
  /// ```
  void writeEnclosed([Object? object, String enclosing = "'"]) => this..write(enclosing)..write(object)..write(enclosing);

  /// Adds the string representation of [object] with the given [indentation] to this buffer.
  ///
  /// ```dart
  /// final buffer = StringBuffer()..writeIndented(4, 'hello world');
  /// buffer.toString(); // '    hello world'
  /// ```
  void writeIndented(int indentation, [Object? object]) => this..write(' ' * indentation)..write(object);

}
