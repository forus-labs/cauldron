/// Provides functions for working with [StringBuffer]s.
extension StringBuffers on StringBuffer {

  /// Adds [object], enclosed by [enclosing], to this buffer.
  ///
  /// ```dart
  /// final buffer = StringBuffer()..writeEnclosed('hello world');
  /// buffer.toString(); // "'hello world'"
  /// ```
  void writeEnclosed([Object? object, String enclosing = "'"]) => this..write(enclosing)..write(object)..write(enclosing);

  /// Adds [object], indented by [indentation], to this buffer.
  ///
  /// ```dart
  /// final buffer = StringBuffer()..writeIndented(4, 'hello world');
  /// buffer.toString(); // '    hello world'
  /// ```
  void writeIndented(int indentation, [Object? object]) => this..write(' ' * indentation)..write(object);

}
