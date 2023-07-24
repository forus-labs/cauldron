import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stevia/stevia.dart';

Widget stub(BuildContext context, bool enabled, double size, Widget? child) => child!; // ignore: avoid_positional_boolean_parameters

void main() {
  for (final (index, constructor) in [
    () => ResizableRegion(initialSize: 0, sliderSize: 10, builder: stub),
    () => ResizableRegion(initialSize: 10, sliderSize: 0, builder: stub),
    () => ResizableRegion(initialSize: 10, sliderSize: 10, builder: stub),
  ].indexed) {
    test('[$index] constructor throws error', () => expect(constructor, throwsAssertionError));
  }
}
