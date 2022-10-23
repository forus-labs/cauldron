import 'package:sugar/core.dart';
import 'package:test/test.dart';

void main() {
  Future<Some<int>> func<T>(T value) async => const Some(1);

  group('Some', () {
    test('contains value', () => expect(const Some('value').contains('value'), true));

    test('does not contain value', () => expect(const Some('value').contains('v'), false));

    test('where predicate successful', () => expect(const Some('value').where((value) => value == 'value'), const Some('value')));

    test('where predicate not successful', () => expect(const Some('value').where((value) => value == 'v'), const None<String>()));

    test('bind', () => expect(const Some(1).bind((value) => Some(value.toString())), const Some('1')));

    test('map', () => expect(const Some(1).map((value) => value.toString()), const Some('1')));

    test('pipe', () async => expect(await const Some(1).pipe(func), const Some(1)));

    test('unwrap()', () => expect(const Some('value').unwrap(), 'value'));

    test('exists', () => expect(const Some('value').exists, true));

    test('nullable', () => expect(const Some('value').nullable, 'value'));

    group('equality', () {
      test('equals other Some', () => expect(const Some('value'), const Some('value')));

      test('equals other Some with different type', () => expect(const Some<String>('value'), const Some<dynamic>('value')));

      test('does not equal to other Some', () => expect(const Some('value'), isNot(const Some('other'))));

      test('deep values equal', () => expect(Some([1, 2, 3, 4, 5]), Some([1, 2, 3, 4, 5]))); // ignore: prefer_const_constructors

      test('does not equal None', () => expect(Some('value'), isNot(None<String>()))); // ignore: prefer_const_constructors

      test('does not equal value', () => expect(Some('value'), isNot('value'))); // ignore: prefer_const_constructors

      test('does not equal other type', () => expect(Some('1'), isNot(Some(1)))); // ignore: prefer_const_constructors
    });

    group('hashCode', () {
      test('equals other Some', () => expect(const Some('value').hashCode, const Some('value').hashCode));

      test('does not equal to other Some', () => expect(const Some('value').hashCode, isNot(const Some('other').hashCode)));

      test('deep values equal', () => expect(Some([1, 2, 3, 4, 5]).hashCode, Some([1, 2, 3, 4, 5]).hashCode)); // ignore: prefer_const_constructors

      test('does not equal None', () => expect(Some('value').hashCode, isNot(None<String>().hashCode))); // ignore: prefer_const_constructors

      test('does not equal value', () => expect(Some('value').hashCode, 'value'.hashCode)); // ignore: prefer_const_constructors

      test('does not equal other type', () => expect(Some('1'), isNot(Some(1)))); // ignore: prefer_const_constructors
    });

    test('toString()', () => expect(const Some('value').toString(), 'Some(value)'));
  });

  group('None', () {
    test('does not contain value', () => expect(const None().contains('v'), false));

    test('where predicate successful', () => expect(const None<String>().where((value) => true), const None()));

    test('where predicate not successful', () => expect(const None().where((value) => false), const None()));

    test('bind', () => expect(const None().bind((value) => Some(value.toString())), const None()));

    test('map', () => expect(const None().map((value) => value.toString()), const None()));

    test('pipe', () async => expect(await const None().pipe(func), const None()));

    test('unwrap', () => expect(const None().unwrap, throwsStateError));

    test('exists', () => expect(const None().exists, false));

    test('nullable', () => expect(const None<String>().nullable, null));

    group('equality', () {
      test('equals other None', () => expect(const None(), const None()));

      test('equals other None with different type', () => expect(const None<int>(), const None<String>()));

      test('does not equal Some', () => expect(None<String>(), isNot(Some('value')))); // ignore: prefer_const_constructors

      test('does not equal value', () => expect(None<String>(), isNot(''))); // ignore: prefer_const_constructors
    });

    group('equality', () {
      test('equals other None', () => expect(const None().hashCode, const None().hashCode));

      test('equals other None with different type', () => expect(const None<int>().hashCode, const None<String>().hashCode));

      test('does not equal Some', () => expect(None<String>().hashCode, isNot(Some('value').hashCode))); // ignore: prefer_const_constructors

      test('does not equal value', () => expect(None<String>().hashCode, isNot(''.hashCode))); // ignore: prefer_const_constructors
    });

    test('toString()', () => expect(const None().toString(), 'None()'));
  });

}