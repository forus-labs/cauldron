@TestOn('browser')
library;

import 'package:test/test.dart';

import 'package:sugar/core_system.dart';

void main() {
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

  const runtime = System();

  test('platform', () => expect(runtime.platform, isNot('unknown')));

  test('type', () => expect(runtime.type, PlatformType.web));

  test('web', () => expect(runtime.web, true));
}
