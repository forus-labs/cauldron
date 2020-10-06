const _whitespace = 32;
final _delimiters = RegExp(r'(\s|-|_)+');
final _identifier = RegExp(r'(([a-zA-Z$_][a-zA-Z\d$_]+)|[a-zA-Z$])');

extension Strings on String {

  String capitalize() {
    if (isBlank) {
      return this;

    } else if (length == 1) {
      return toUpperCase();

    } else {
      return this[0].toUpperCase() + substring(1);
    }
  }


  String camelCase([Pattern pattern]) {
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

  String pascalCase([Pattern pattern]) {
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

  String snakeCase([Pattern pattern]) => split(pattern ?? _delimiters).join('_');


  bool equalsIgnoreCase(String other) => toLowerCase() == other.toLowerCase();

  bool matches(Pattern expression) {
    final match = expression.matchAsPrefix(this);
    return match != null && match.start == 0 && match.end == length;
  }


  bool get isBlank => isEmpty || codeUnits.every((unit) => unit == _whitespace);

  bool get isNotBlank => !isBlank;

  bool get isIdentifier => matches(_identifier);

}

extension PaddedNumber<T extends num> on T {

  String padLeft(int width, [String padding = '0']) => toString().padLeft(width, padding);

  String padRight(int width, [String padding = '0']) => toString().padRight(width, padding);

}