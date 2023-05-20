final class Haptic {

  const Haptic();

  Future<void> success();

}

enum HapticType {

  success._('confirm', 'success'),
  warning._('no_haptics', 'warning'),
  failure._('reject', 'error'),

  heavy._('context_click', 'heavy'),
  medium._('keyboard_tap', 'medium'),
  light._('virtual_key', 'light');

  final String _android;
  final String _ios;

  const HapticType._(this._android, this._ios);

}
