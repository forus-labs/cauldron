import 'package:test/test.dart';

import 'package:sugar/sugar.dart';

void main() {
  test('factory', () => expect(Timezone.timezoneProvider.factory, 'Factory'));

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

    tearDown(() =>
        Timezone.platformTimezoneProvider = defaultPlatformTimezoneProvider);
  });

  group('Timezone(...)', () {
    setUp(() => Timezone.timezoneProvider = UniversalTimezoneProvider());

    test('valid', () => expect(Timezone('Asia/Tokyo').name, 'Asia/Tokyo'));

    test('invalid', () => expect(Timezone('invalid').name, 'Factory'));
  });
}
