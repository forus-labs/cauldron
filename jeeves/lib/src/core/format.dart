import 'package:ansicolor/ansicolor.dart';

/// A pen that colors all given text red.
final red = AnsiPen()..xterm(9);

/// A pen that colors all given text yellow.
final yellow = AnsiPen()..xterm(11);

final _default = AnsiPen();

/// Highlights the [selection] in [message] for the given [reason].
String highlight(String title, String message, String selection, String reason, [AnsiPen? color, int indentation = 0]) {
  final index = message.lastIndexOf(selection);
  final pen = color ?? _default;
  final colored = pen('${'~' * selection.length} $reason');

  return index == -1 ? message : '''
${pen(title)}:
|
|  ${' ' * indentation}$message
|  ${' ' * (indentation + index)}$colored
|
''';
}

/// An extension that provides functions for creating code-blocks.
extension CodeBlocks on StringBuffer {

  /// Highlights the [selection] in [message] for the given [reason].
  void highlight(String message, String selection, String reason, [AnsiPen? color, int indentation = 0]) {
    final index = message.lastIndexOf(selection);
    if (index == -1) {
      return;
    }

    final hint = (color ?? _default)('${'~' * selection.length} $reason');
    indent(message, indentation);
    indent('${' ' * index}$hint', indentation);
  }

  /// Adds a code block with the given [value].
  void indent(String value, [int indentation = 0]) => this..write('| ')..write(' ' * indentation)..write(value)..write('\n');

}

/// An extension that provides functions for creating YAML code-blocks.
extension YamlCodeBlocks on StringBuffer {

  /// Highlights the [selection] in [entry] for the given [reason].
  void error(List<String> path, MapEntry<dynamic, dynamic> entry, String selection, String reason) =>
      this..indent('...', (path.length + 1) * 2)
        ..highlight('${entry.key}: ${entry.value}', selection, reason, red, (path.length + 1) * 2)
        ..indent('');

}
