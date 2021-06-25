const _whitespace = 32;
final _delimiters = RegExp(r'(\s|-|_)+');
final _identifier = RegExp(r'(([a-zA-Z$_][a-zA-Z\d$_]+)|[a-zA-Z$])');

/// Utilities for manipulating [String]s.
extension Strings on String {

  /// Capitalizes this [String].
  String capitalize() {
    if (isBlank) {
      return this;

    } else if (length == 1) {
      return toUpperCase();

    } else {
      return this[0].toUpperCase() + substring(1);
    }
  }


  /// Camel-cases this [String] with separations determined using the given pattern.
  String camelCase([Pattern? pattern]) {
    final parts = split(pattern ?? _delimiters)..removeWhere((val) => val.isEmpty);
    if (parts.length <= 1) {
      return this;
    }

    final buffer = StringBuffer()..write(parts[0]);
    for (var i = 1; i < parts.length; i++) {
      buffer.write(parts[i].capitalize());
    }

    return buffer.toString();
  }


  /// Pascal-cases this [String] with separations determined using the given pattern.
  String pascalCase([Pattern? pattern]) {
    final parts = split(pattern ?? _delimiters)..removeWhere((val) => val.isEmpty);
    if (parts.isEmpty) {
      return this;
    }

    final buffer = StringBuffer();
    for (final part in parts) {
      buffer.write(part.capitalize());
    }

    return buffer.toString();
  }

  /// Snake-cases this [String] with separations determined using the given pattern.
  String snakeCase([Pattern? pattern]) => split(pattern ?? _delimiters).join('_');


  /// Determines this [String] and [other] are equal, ignoring capitalization.
  bool equalsIgnoreCase(String other) => toLowerCase() == other.toLowerCase();

  /// Determines if this [String] matches the given pattern.
  bool matches(Pattern expression) {
    final match = expression.matchAsPrefix(this);
    return match != null && match.start == 0 && match.end == length;
  }


  /// Returns `true` if this [String] is empty or contains only whitespaces.
  bool get isBlank => isEmpty || codeUnits.every((unit) => unit == _whitespace);

  /// Returns `true` if this [String] is not empty and does not contain only whitespaces.
  bool get isNotBlank => !isBlank;

  /// Returns `true` if this [String] is a valid Dart identifier.
  bool get isIdentifier => matches(_identifier);

}

/// Utilities for formatting numbers.
extension PaddedNumber<T extends num> on T {

  /// Pads this number on the left with [padding] if it is shorter than [width].
  String padLeft(int width, [String padding = '0']) => toString().padLeft(width, padding);

  /// Pads this number on the right with [padding] if it is shorter than [width].
  String padRight(int width, [String padding = '0']) => toString().padRight(width, padding);

}