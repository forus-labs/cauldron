import 'package:args/command_runner.dart';

/// A mixin that provides frequently used formatting operations.
mixin Formatting on Command<void> {

  late final String actual = globalResults!.arguments.join(' ');
  late final String remaining = argResults!.rest.join(' ');

  String highlight(String title, String value, String message, {String? command}) {
    final index = (command ?? actual).lastIndexOf(value);
    if (index == -1) {
      return value;
    }

    return '''
$title:
 |
 |  $actual
 |  ${' ' * index}${'~' * value.length} $message
 |
    ''';
  }

}