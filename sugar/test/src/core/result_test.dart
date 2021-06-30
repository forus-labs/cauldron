import 'package:test/test.dart';
import 'package:sugar/sugar.dart';

class Consumer<T> {
  T? parameter;

  // ignore: use_setters_to_change_properties
  void call(T parameter) => this.parameter = parameter;
}

void main() {
  final value = Result<String, int>.value('something');
  final error =  Result<String, int>.error(404);

  group('result', () {
    for (final arguments in [
      ['value', value, true],
      ['error', error, false],
    ].triples<String, Result<String, int>, bool>()) {
      group(arguments.left, () {
        final result = arguments.middle;

        test('success', () {
          expect(result.successful, arguments.right);
          expect(result.failure, !arguments.right);
        });

        test('ifSuccessful', () {
          final consumer = Consumer<String>();
          result.ifSuccessful(consumer);

          expect(consumer.parameter == 'something', arguments.right);
        });

        test('ifFailure', () {
          final consumer = Consumer<int>();
          result.ifFailure(consumer);

          expect(consumer.parameter == 404, !arguments.right);
        });

        test('unwrap', () {
          expect(result.unwrap('pop') == 'pop', !arguments.right);
          expect(result.unwrapError(400) == 400, arguments.right);
        });
      });
    }

    test('contains value' , () {
      expect(value.contains('something'), isTrue);
      expect(value.contains('else'), isFalse);
    });
    
    test('contains error', () {
      expect(error.containsError(404), isTrue);
      expect(error.containsError(400), isFalse);
    });
  });

  group('value', () {
    test('value', () => expect(value.value, 'something'));

    test('error', () => expect(
      () => value.error,
      throwsA(predicate<ResultError>((e) => e.message == 'Result does not contain an error'))
    ));
  });

  group('error', () {
    test('value', () => expect(
      () => error.value,
      throwsA(predicate<ResultError>((e) => e.message == 'Result does not contain a value'))
    ));

    test('error', () => expect(error.error, 404));
  });

}