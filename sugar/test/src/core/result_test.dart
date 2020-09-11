import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:sugar/sugar.dart';

class Consumer<T> {
  T parameter;

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

        test('present', () {
          expect(result.present, arguments.right);
          expect(result.notPresent, !arguments.right);
        });

        test('ifPresent', () {
          final consumer = Consumer<String>();
          result.ifPresent(consumer);

          expect(consumer.parameter == 'something', arguments.right);
        });

        test('ifError', () {
          final consumer = Consumer<int>();
          result.ifError(consumer);

          expect(consumer.parameter == 404, !arguments.right);
        });

        test('unwrap', () {
          expect(result.unwrap('pop') == 'pop', !arguments.right);
          expect(result.unwrapError(400) == 400, arguments.right);
        });
      });
    }
  });


}