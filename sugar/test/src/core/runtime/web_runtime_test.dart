@TestOn('browser')
library;

import 'package:test/test.dart';

import 'package:sugar/core_runtime.dart';

void main() {
  const runtime = Runtime();

  test('platform', () => expect(runtime.platform, isNot('unknown')));

  test('type', () => expect(runtime.type, PlatformType.web));

  test('web', () => expect(runtime.web, true));
}
