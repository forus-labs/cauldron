@TestOn('vm')
library;

import 'package:sugar/core_runtime.dart';
import 'package:test/test.dart';

void main() {
  const runtime = Runtime();

  test('platform', () => expect(runtime.platform, isNot('unknown')));

  test('type', () => expect(runtime.type, PlatformType.web));

  test('web', () => expect(runtime.web, true));
}
