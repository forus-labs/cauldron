import 'package:flutter/material.dart' hide Interval;
import 'package:flutter_test/flutter_test.dart';

import 'package:stevia/stevia.dart';
import 'package:sugar/sugar.dart';

void main() {
  group('IntTextInputFormatter', () {
    late Widget widget;

    setUp(() => widget = MaterialApp(
      home: Scaffold(
        body: TextField(
          keyboardType: TextInputType.number,
          inputFormatters: [ IntTextInputFormatter(Interval.closedOpen(-50, 50)) ],
        ),
      )
    ));

    for (final (actual, expected) in [
      ('-50', '-50'),
      ('-51', ''),
      ('49', '49'),
      ('50', ''),
      ('-', '-'),
      ('0.0', ''),
      ('  0   ', '0'),
      ('1,0', '10'),
      ('  1,0 ', '10'),
    ]) {
      testWidgets('values', (tester) async {
        await tester.pumpWidget(widget);
        await tester.enterText(find.byType(TextField), actual);

        expect(find.text(expected), findsOneWidget);
      });
    }

    testWidgets('empty string', (tester) async {
      await tester.pumpWidget(widget);
      await tester.enterText(find.byType(TextField), '1');
      await tester.enterText(find.byType(TextField), '');

      expect(find.text(''), findsOneWidget);
    });
  });
}
