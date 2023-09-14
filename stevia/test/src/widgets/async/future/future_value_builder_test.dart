import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stevia/stevia.dart';

import '../async.dart';

class UnderTest extends StatefulWidget {
  @override
  State<UnderTest> createState() => _UnderTestState();
}

class _UnderTestState extends State<UnderTest> {
  int memoizedSideEffect = 0;
  int futureSideEffect = 0;

  @override
  Widget build(BuildContext context) => MaterialApp(
    home: Column(
      children: [
        FloatingActionButton(onPressed: () => setState(() {})),
        FutureValueBuilder(
          future: memoizedBuilder,
          builder: (_, __, ___) => Container(),
        ),
        FutureBuilder(
          future: futureBuilder(),
          builder: (_, __) => Container(),
        ),
      ],
    ),
  );

  Future<void> futureBuilder() async {
    await Future.delayed(const Duration(milliseconds: 1));
    futureSideEffect++;
  }

  Future<void> memoizedBuilder(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 1));
    memoizedSideEffect++;
  }
}


void main() {
  testWidgets('FutureBuilder recomputes multiple times, FutureValueBuilder does not recompute', (tester) async {
    await tester.pumpWidget(UnderTest());
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    final state = tester.state<_UnderTestState>(find.byType(UnderTest));
    expect(state.memoizedSideEffect, 1);
    expect(state.futureSideEffect, 2);
  });

  testWidgets('gives expected value with SynchronousFuture', (tester) async {
    final future = SynchronousFuture('flutter');
    await tester.pumpWidget(FutureValueBuilder<String>(
      future: (_) => future,
      builder: (context, value, child) {
        expect(value, 'flutter');
        expect(child, isNull);

        return const Placeholder();
      },
    ));
  });

  testWidgets('gracefully handles transition from null future', (tester) async {
    final key = GlobalKey();
    await tester.pumpWidget(FutureValueBuilder(
      key: key,
      future: (context) => null,
      builder: valueText,
      emptyBuilder: emptyFutureValueText,
    ));

    expect(find.text('empty text'), findsOneWidget);

    final completer = Completer<String>();
    await tester.pumpWidget(FutureValueBuilder(
      key: key,
      future: (_) => completer.future,
      builder: valueText,
      emptyBuilder: emptyFutureValueText,
    ));

    expect(find.text('empty text'), findsOneWidget);
  });

  testWidgets('gracefully handles transition to null future', (tester) async {
    final key = GlobalKey();
    final completer = Completer<String>();

    await tester.pumpWidget(FutureValueBuilder(
      key: key,
      future: (_) => completer.future,
      builder: valueText,
      emptyBuilder: emptyFutureValueText,
    ));
    expect(find.text('empty text'), findsOneWidget);

    await tester.pumpWidget(FutureValueBuilder(
      key: key,
      future: (_) => null,
      builder: valueText,
      emptyBuilder: emptyFutureValueText,
    ));
    expect(find.text('empty text'), findsOneWidget);

    completer.complete('hello');

    await eventFiring(tester);
    expect(find.text('empty text'), findsOneWidget);
  });

  testWidgets('gracefully handles transition to other future', (tester) async {
    final key = GlobalKey();
    final completerA = Completer<String>();
    final completerB = Completer<String>();

    await tester.pumpWidget(FutureValueBuilder(
      key: key,
      future: (_) => completerA.future,
      builder: valueText,
      emptyBuilder: emptyFutureValueText,
    ));
    expect(find.text('empty text'), findsOneWidget);

    await tester.pumpWidget(FutureValueBuilder(
      key: key,
      future: (_) => completerB.future,
      builder: valueText,
      emptyBuilder: emptyFutureValueText,
    ));
    expect(find.text('empty text'), findsOneWidget);

    completerB.complete('B');
    completerA.complete('A');
    await eventFiring(tester);
    expect(find.text('B'), findsOneWidget);
  });

  testWidgets('tracks life-cycle of Future to success', (tester) async {
    final completer = Completer<String>();

    await tester.pumpWidget(FutureValueBuilder(future: (_) => completer.future, builder: valueText, emptyBuilder: emptyFutureValueText));
    expect(find.text('empty text'), findsOneWidget);

    completer.complete('hello');
    await eventFiring(tester);
    expect(find.text('hello'), findsOneWidget);
  });

  testWidgets('tracks life-cycle of Future to error', (tester) async {
    final completer = Completer<String>();

    await tester.pumpWidget(FutureValueBuilder(
      future: (_) => completer.future,
      builder: valueText,
      errorBuilder: errorText,
      emptyBuilder: emptyFutureValueText,
    ));
    expect(find.text('empty text'), findsOneWidget);

    completer.completeError('bad', StackTrace.fromString('trace'));
    await eventFiring(tester);
    expect(find.text(('bad', StackTrace.fromString('trace')).toString()), findsOneWidget);
  });

  testWidgets('runs the builder using given initial value', (tester) async {
    final key = GlobalKey();
    await tester.pumpWidget(FutureValueBuilder.value(
      key: key,
      future: (_) => null,
      initial: 'I',
      builder: valueText,
    ));
    expect(find.text('I'), findsOneWidget);
  });

  testWidgets('ignores initial value when reconfiguring', (tester) async {
    final key = GlobalKey();
    await tester.pumpWidget(FutureValueBuilder.value(
      key: key,
      future: (_) => null,
      initial: 'I',
      builder: valueText,
    ));
    expect(find.text('I'), findsOneWidget);

    final completer = Completer<String>();
    await tester.pumpWidget(FutureValueBuilder.value(
      key: key,
      future: (_) => completer.future,
      initial: 'Ignored',
      builder: valueText,
    ));
    await eventFiring(tester);
    expect(find.text('I'), findsOneWidget);

    completer.complete('value');
    await eventFiring(tester);
    expect(find.text('value'), findsOneWidget);
  });

  testWidgets('differentiate between empty and T when T is nullable', (tester) async {
    await tester.pumpWidget(FutureValueBuilder<String?>(
      future: (_) async {
        await Future.delayed(const Duration(seconds: 5));
        return null;
      },
      builder: (_, __, child) => const Text('V', textDirection: TextDirection.ltr),
      emptyBuilder: (_, __, child) => const Text('E', textDirection: TextDirection.ltr),
    ));

    await eventFiring(tester);
    expect(find.text('E'), findsOneWidget);

    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(find.text('V'), findsOneWidget);
  });

  testWidgets('shows child', (tester) async {
    final key = GlobalKey();
    await tester.pumpWidget(FutureValueBuilder.value(
      key: key,
      future: (_) => null,
      initial: 'I',
      builder: (_, __, child) => child!,
      child: const Text('hello', textDirection: TextDirection.ltr),
    ));

    expect(find.text('hello'), findsOneWidget);
  });
}
