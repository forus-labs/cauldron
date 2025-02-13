import 'package:test/test.dart';

import 'package:sugar/core_system.dart';

void main() {
  test('default platform', () => expect(const FakeSystem().platform, 'unknown'));

  test('platform', () => expect(const FakeSystem(PlatformType.unknown, 'something').platform, 'something'));

  test('default type', () => expect(const FakeSystem().type, PlatformType.unknown));

  test('type', () => expect(const FakeSystem(PlatformType.android).type, PlatformType.android));

  test('default bools', () {
    const system = FakeSystem();

    expect([
      system.android,
      system.fuchsia,
      system.ios,
      system.linux,
      system.macos,
      system.windows,
      system.web,
    ], List.filled(7, false));
  });

  test('bools', () {
    const system = FakeSystem(PlatformType.windows);

    expect(system.windows, true);
    expect([system.android, system.fuchsia, system.ios, system.linux, system.macos, system.web], List.filled(6, false));
  });
}
