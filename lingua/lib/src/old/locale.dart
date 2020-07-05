import 'dart:ui';

const _defaultFallback = Locale('en', 'US');


Locale parseTag(String tag) {
  final parts = tag?.split('-');
  if (parts == null) {
    return _defaultFallback;
  }

  switch (parts.length) {
    case 1:
      return Locale(parts[0]);
    case 2:
      return Locale(parts[0], parts[1]);
    default:
      return null;
  }
}


class LocaleError extends Error {

  final String message;

  LocaleError(this.message);

  @override
  String toString() => message;

}