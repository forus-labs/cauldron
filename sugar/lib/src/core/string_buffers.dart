/// Provides functions for working with [StringBuffer]s.
extension StringBuffers on StringBuffer {

  /// Adds the string representation of [object] with the given [indentation] to this buffer.
  ///
  /// ```dart
  /// final buffer = StringBuffer()..enclose('hello world');
  /// buffer.toString(); // '    hello world'
  /// ```
  void enclose(Object? object) {

  }

  /// Adds the string representation of [object] with the given [indentation] to this buffer.
  ///
  /// ```dart
  /// final buffer = StringBuffer()..indent(4, 'hello world');
  /// buffer.toString(); // '    hello world'
  /// ```
  void indent(int indentation, [Object? object]) {
    write(' ' * indentation);
    write(object.toString());
  }

}
