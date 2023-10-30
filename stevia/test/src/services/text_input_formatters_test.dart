import 'package:flutter/material.dart' hide Interval;
import 'package:flutter_test/flutter_test.dart';

import 'package:stevia/stevia.dart';
import 'package:sugar/sugar.dart';

void main() {
  group('IntTextInputFormatter', () {
    group('negative range', () {
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

    group('[-1, 50)', () {
      late Widget widget;

      setUp(() => widget = MaterialApp(
          home: Scaffold(
            body: TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [ IntTextInputFormatter(Interval.closedOpen(-1, 50)) ],
            ),
          )
      ));

      for (final (actual, expected) in [
        ('-2', ''),
        ('-1', '-1'),
        ('-', '-'),
      ]) {
        testWidgets('values', (tester) async {
          await tester.pumpWidget(widget);
          await tester.enterText(find.byType(TextField), actual);

          expect(find.text(expected), findsOneWidget);
        });
      }
    });

    group('(-1, 50)', () {
      late Widget widget;

      setUp(() => widget = MaterialApp(
          home: Scaffold(
            body: TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [ IntTextInputFormatter(Interval.open(-1, 50)) ],
            ),
          )
      ));

      for (final (actual, expected) in [
        ('-1', ''),
        ('0', '0'),
        ('-', ''),
      ]) {
        testWidgets('values', (tester) async {
          await tester.pumpWidget(widget);
          await tester.enterText(find.byType(TextField), actual);

          expect(find.text(expected), findsOneWidget);
        });
      }
    });

    group('(-2, 50)', () {
      late Widget widget;

      setUp(() => widget = MaterialApp(
          home: Scaffold(
            body: TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [ IntTextInputFormatter(Interval.open(-2, 50)) ],
            ),
          )
      ));

      for (final (actual, expected) in [
        ('-2', ''),
        ('-1', '-1'),
        ('-', '-'),
      ]) {
        testWidgets('values', (tester) async {
          await tester.pumpWidget(widget);
          await tester.enterText(find.byType(TextField), actual);

          expect(find.text(expected), findsOneWidget);
        });
      }
    });
  });

  group('CaseTextInputFormatter', () {
    group('upper case', () {
      late Widget widget;

      setUp(() => widget = const MaterialApp(
          home: Scaffold(
            body: TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [ CaseTextInputFormatter.upper() ],
            ),
          )
      ));

      for (final (actual, expected) in [
        ('', ''),
        ('UPPER', 'UPPER'),
        ('miXEd', 'MIXED'),
        ('something', 'SOMETHING'),
      ]) {
        testWidgets('values', (tester) async {
          await tester.pumpWidget(widget);
          await tester.enterText(find.byType(TextField), actual);

          expect(find.text(expected), findsOneWidget);
        });
      }
    });

    group('lower case', () {
      late Widget widget;

      setUp(() => widget = const MaterialApp(
          home: Scaffold(
            body: TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [ CaseTextInputFormatter.lower() ],
            ),
          )
      ));

      for (final (actual, expected) in [
        ('', ''),
        ('lower', 'lower'),
        ('miXEd', 'mixed'),
        ('SOMETHING', 'something'),
      ]) {
        testWidgets('values', (tester) async {
          await tester.pumpWidget(widget);
          await tester.enterText(find.byType(TextField), actual);

          expect(find.text(expected), findsOneWidget);
        });
      }
    });
  });
}
