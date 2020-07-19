import 'dart:ui';

final _separator = RegExp(r'(-|_)');

extension Locales on Locale {

  static Locale parse(String tag) {
    if (tag == null) {
      return const Locale('en', 'US');
    }

    final parts = tag.split(_separator);
    switch (parts.length) {
      case 1:
        return Locale(parts[0]);
      case 2:
        return Locale(parts[1]);
      default:
        return null;
    }
  }

}

