import 'package:args/command_runner.dart';

/// A mixin that provides frequently used formatting operations.
mixin Formatting on Command<void> {

  late final String line = globalResults!.arguments.join(' ');
  late final String remaining = argResults!.rest.join(' ');

  String highlight(String title, String value, String part, String message) {
    final index = value.indexOf(part);
    return index == -1 ? value : '''
$title
|
|  $value
|  ${' ' * index}${'~' * part.length} $message
|
  ''';
  }
}

/// An extension which provides functions for formatting code-blocks.
extension SyntaxBuffer on StringBuffer {

  void highlight(String value, String part, String message, [int indentation = 0]) {
    final index = value.indexOf(part);
    if (index == -1) {
      return;
    }

    block(value, indentation);
    block('{' ' * index}${'~' * part.length} $message', indentation);
  }

  void block(String value, [int indentation = 0]) => writeln('|  ${' ' * indentation}$value');

}