import 'package:sugar/src/time/zone/providers/embedded/embedded_timezone_provider.dart';
import 'package:test/test.dart';

import 'package:sugar/sugar.dart';

void main() {
  test('factory', () => expect(Timezone.factory.name, 'Factory'));

  group('now()', () {
    setUp(() => Timezone.platformTimezoneProvider = () => 'Asia/Tokyo');

    test('cache hit', () {
      expect(Timezone.now().name, 'Asia/Tokyo');
      expect(Timezone.now().name, 'Asia/Tokyo');
    });

    test('cache miss', () => expect(Timezone.now().name, 'Asia/Tokyo'));

    test('platform error', () {
      Timezone.platformTimezoneProvider = () => 'invalid';
      expect(Timezone.now().name, 'Factory');
    });

    tearDown(() => Timezone.platformTimezoneProvider = defaultPlatformTimezoneProvider);
  });

  group('Timezone(...)', () {
    setUp(() => Timezone.timezoneProvider = EmbeddedTimezoneProvider());

    test('valid', () => expect(Timezone('Asia/Tokyo').name, 'Asia/Tokyo'));

    test('invalid', () => expect(Timezone('invalid').name, 'Factory'));

    test('custom timezoneProvider', () {
      Timezone.timezoneProvider = {};
      expect(Timezone('Asia/Tokyo').name, 'Factory');
    });
  });
}
