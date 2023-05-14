@TestOn('vm')
library;

import 'package:test/test.dart';

import 'package:sugar/core_runtime.dart';

void main() {
  const runtime = Runtime();

  test('platform', () => expect(runtime.platform, isNot('unknown')));

  test('type', () {
    expect(runtime.type, isNot(PlatformType.web));
    expect(runtime.type, isNot(PlatformType.unknown));
  });

  test('booleans', () {
    final types = [
      runtime.android,
      runtime.fuchsia,
      runtime.ios,
      runtime.linux,
      runtime.macos,
      runtime.windows,
    ];

    expect(types.where((e) => e).length, 1);
    expect(runtime.web, false);
  });
}
