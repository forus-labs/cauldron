import 'package:test/test.dart';

import 'package:sugar/core_runtime.dart';

void main() {
  test('default platform', () => expect(const FakeRuntime().platform, 'unknown'));

  test('platform', () => expect(const FakeRuntime(PlatformType.unknown, 'something').platform, 'something'));

  test('default type', () => expect(const FakeRuntime().type, PlatformType.unknown));

  test('type', () => expect(const FakeRuntime(PlatformType.android).type, PlatformType.android));

  test('default bools', () {
    const runtime = FakeRuntime();

    expect([
      runtime.android,
      runtime.fuchsia,
      runtime.ios,
      runtime.linux,
      runtime.macos,
      runtime.windows,
      runtime.web,
    ], List.filled(7, false));
  });

  test('bools', () {
    const runtime = FakeRuntime(PlatformType.windows);

    expect(runtime.windows, true);
    expect([
      runtime.android,
      runtime.fuchsia,
      runtime.ios,
      runtime.linux,
      runtime.macos,
      runtime.web,
    ], List.filled(6, false));
  });
}
