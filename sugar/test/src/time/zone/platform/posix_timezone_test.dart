@TestOn('mac-os || linux')
library;

import 'dart:io';

import 'package:sugar/src/time/zone/platform/vm_provider.dart';
import 'package:sugar/src/time/zone/timezones.g.dart';

import 'package:test/test.dart';

void main() {
  group('provider()', () {
    test('zoneinfo returns valid timezone', () {
      final timezone = provider();

      expect(iana.contains(timezone), true);
      expect(timezone, isNot('Factory'));
    });
  });

}