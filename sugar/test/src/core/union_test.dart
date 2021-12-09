import 'package:sugar/sugar.dart';
import 'package:test/test.dart';

class Consumer<T> {
  T? parameter;

  // ignore: use_setters_to_change_properties
  void call(T parameter) => this.parameter = parameter;
}

void main() {
  final left = Union<String, int>.left('something');
  final right = Union<String, int>.right(404);

  for (final arguments in [['left', left, 'something'], ['right', right, 404]].triples<String, Union<String, int>, dynamic>()) {
    group(arguments.left, () {
      test('map', () {
        expect(arguments.middle.map((left) {
          expect(left, isA<String>());
          return arguments.left;

        }, (right) {
          expect(right, isA<int>());
          return arguments.left;

        }), arguments.left);
      });

      test('value', () => expect(arguments.middle.value, arguments.right));

      test('left', () => expect(arguments.middle.left, arguments.right is String));

      test('right', () => expect(arguments.middle.right, arguments.right is int));

      // ignore: invalid_use_of_protected_member
      test('fields', () => expect(arguments.middle.fields, [arguments.right]));
    });
  }
}
