import 'dart:io';
import 'dart:io' as os show exit;

import 'package:ansicolor/ansicolor.dart';
import 'package:args/command_runner.dart';

/// A pen that colors all given text red.
final red = AnsiPen()..xterm(9);

/// A pen that colors all given text yellow.
final yellow = AnsiPen()..xterm(11);

final _default = AnsiPen();

/// A [Command] that interacts with the terminal.
abstract class TerminalCommand<T> extends Command<T> {

  /// The terminal.
  final Terminal terminal;
  /// The entire command.
  late final String line = globalResults!.arguments.join(' ');
  /// The remaining part of the command.
  late final String remaining = argResults!.rest.join(' ');

  /// Creates a [TerminalCommand].
  TerminalCommand([this.terminal = const Terminal()]);

}

/// Represents a command-line terminal.
class Terminal {

  /// Creates a [Terminal].
  const Terminal();

  /// Prints the given [message] to the standard output stream.
  void print(String message) => stdout.writeln(message);

  /// Prints the given error [message] to the standard error output stream.
  void error(String message) => stderr.writeln(message);

  /// Terminates this process with the given [code].
  Never exit(int code) => os.exit(code);

}

/// An extension that provides functions for creating code-blocks.
extension CodeBlockBuffer on StringBuffer {

  /// Highlights the [part] of the [value] with the given message.
  void highlight(String value, String part, String message, [AnsiPen? color, int indentation = 0]) {
    final index = value.lastIndexOf(part);
    if (index == -1) {
      return;
    }

    final colored = (color ?? _default)('${'~' * part.length} $message');
    code(value, indentation);
    code('${' ' * index}$colored', indentation);
  }

  /// Adds a code block with the given [value].
  void code(String value, [int indentation = 0]) => this..write('| ')..write(' ' * indentation)..write(value)..write('\n');

}

/// Highlights the [part] of the [value] with the given [message].
String highlight(String title, String value, String part, String message, [AnsiPen? color, int indentation = 0]) {
  final index = value.lastIndexOf(part);
  final pen = color ?? _default;
  final colored = pen('${'~' * part.length} $message');

  return index == -1 ? value : '''
${pen(title)}:
|
|  ${' ' * indentation}$value
|  ${' ' * (indentation + index)}$colored
|
  ''';
}