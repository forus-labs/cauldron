import 'dart:io';
import 'dart:io' as os show exit;

import 'package:args/command_runner.dart';

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

/// A [Command] that interacts with the terminal.
abstract class TerminalCommand<T> extends Command<T> {

  /// The terminal.
  final Terminal terminal;

  /// The entire command.
  late final String line = globalResults?.arguments.join(' ') ?? '';

  /// The remaining part of the command.
  late final String remaining = argResults?.rest.join(' ') ?? '';

  /// Creates a [TerminalCommand].
  TerminalCommand([this.terminal = const Terminal()]);

}
