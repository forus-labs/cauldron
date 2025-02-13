@TestOn('vm')
library;

import 'package:test/test.dart';

import 'package:sugar/core_system.dart';

void main() {
  const system = System();

  test('currentDateTime', () {
    System.currentDateTime = () => DateTime.utc(1990);
    expect(System.currentDateTime(), DateTime.utc(1990));
  });

  test('epochMilliseconds', () {
    System.currentDateTime = () => DateTime.utc(1990);
    expect(System.epochMilliseconds, DateTime.utc(1990).millisecondsSinceEpoch);
  });

  test('epochMicroseconds', () {
    System.currentDateTime = () => DateTime.utc(1990);
    expect(System.epochMicroseconds, DateTime.utc(1990).microsecondsSinceEpoch);
  });

  test('platform', () => expect(system.platform, isNot('unknown')));

  test('type', () {
    expect(system.type, isNot(PlatformType.web));
    expect(system.type, isNot(PlatformType.unknown));
  });

  test('booleans', () {
    final types = [system.android, system.fuchsia, system.ios, system.linux, system.macos, system.windows];

    expect(types.where((e) => e).length, 1);
    expect(system.web, false);
  });
}
