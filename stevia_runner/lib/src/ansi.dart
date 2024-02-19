import 'package:io/ansi.dart' as ansi;

/// Represents the color red.
const red = AnsiColor(ansi.red);
/// Represents the color yellow.
const yellow = AnsiColor(ansi.yellow);

/// Wraps an [ansi.AnsiCode] because its API is dog-shit.
class AnsiColor {

  /// The underlying ansi code.
  final ansi.AnsiCode code;

  /// Creates an [AnsiColor].
  const AnsiColor(this.code);

  /// Colors the given [message].
  String call(String message) => code.wrap(message) ?? '';

  /// The escape sequence for this color.
  String get escape => code.escape;

}
