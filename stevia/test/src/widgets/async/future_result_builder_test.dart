import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stevia/stevia.dart';
import 'package:sugar/sugar.dart';

import 'async.dart';

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
        FutureResultBuilder(
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

  Future<Result<String, String>> memoizedBuilder(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 1));
    memoizedSideEffect++;
    return const Success('success');
  }
}


void main() {
  testWidgets('FutureBuilder recomputes multiple times, FutureResultBuilder does not recompute', (tester) async {
    await tester.pumpWidget(UnderTest());
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    final state = tester.state<_UnderTestState>(find.byType(UnderTest));
    expect(state.memoizedSideEffect, 1);
    expect(state.futureSideEffect, 2);
  });

  testWidgets('gives expected value with SynchronousFuture', (tester) async {
    final future = SynchronousFuture(const Success('flutter'));
    await tester.pumpWidget(FutureResultBuilder(
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
    await tester.pumpWidget(FutureResultBuilder(
      key: key,
      future: (context) => null,
      builder: valueText,
      emptyBuilder: emptyFutureResultText,
    ));

    expect(find.text('empty text'), findsOneWidget);

    final completer = Completer<Result<String, String>>();
    await tester.pumpWidget(FutureResultBuilder(
      key: key,
      future: (_) => completer.future,
      builder: valueText,
      emptyBuilder: emptyFutureResultText,
    ));

    expect(find.text('empty text'), findsOneWidget);
  });

  testWidgets('gracefully handles transition to null future', (tester) async {
    final key = GlobalKey();
    final completer = Completer<Result<String, String>>();

    await tester.pumpWidget(FutureResultBuilder(
      key: key,
      future: (_) => completer.future,
      builder: valueText,
      emptyBuilder: emptyFutureResultText,
    ));
    expect(find.text('empty text'), findsOneWidget);

    await tester.pumpWidget(FutureResultBuilder(
      key: key,
      future: (_) => null,
      builder: valueText,
      emptyBuilder: emptyFutureResultText,
    ));
    expect(find.text('empty text'), findsOneWidget);

    completer.complete(const Success('hello'));

    await eventFiring(tester);
    expect(find.text('empty text'), findsOneWidget);
  });

  testWidgets('gracefully handles transition to other future', (tester) async {
    final key = GlobalKey();
    final completerA = Completer<Result<String, String>>();
    final completerB = Completer<Result<String, String>>();

    await tester.pumpWidget(FutureResultBuilder(
      key: key,
      future: (_) => completerA.future,
      builder: valueText,
      emptyBuilder: emptyFutureResultText,
    ));
    expect(find.text('empty text'), findsOneWidget);

    await tester.pumpWidget(FutureResultBuilder(
      key: key,
      future: (_) => completerB.future,
      builder: valueText,
      emptyBuilder: emptyFutureResultText,
    ));
    expect(find.text('empty text'), findsOneWidget);

    completerB.complete(const Success('B'));
    completerA.complete(const Success('A'));
    await eventFiring(tester);
    expect(find.text('B'), findsOneWidget);
  });

  testWidgets('tracks life-cycle of Future to success', (tester) async {
    final completer = Completer<Result<String, String>>();

    await tester.pumpWidget(FutureResultBuilder(future: (_) => completer.future, builder: valueText, emptyBuilder: emptyFutureResultText));
    expect(find.text('empty text'), findsOneWidget);

    completer.complete(const Success('hello'));
    await eventFiring(tester);
    expect(find.text('hello'), findsOneWidget);
  });

  testWidgets('tracks life-cycle of Future to error', (tester) async {
    final completer = Completer<Result<String, String>>();

    await tester.pumpWidget(FutureResultBuilder(
      future: (_) => completer.future,
      builder: valueText,
      failureBuilder: errorText,
      emptyBuilder: emptyFutureResultText,
    ));
    expect(find.text('empty text'), findsOneWidget);

    completer.complete(const Failure('bad'));
    await eventFiring(tester);
    expect(find.text('bad'), findsOneWidget);
  });

  testWidgets('runs the builder using given initial value', (tester) async {
    final key = GlobalKey();
    await tester.pumpWidget(FutureResultBuilder.value(
      key: key,
      future: (_) => null,
      initial: 'I',
      builder: valueText,
    ));
    expect(find.text('I'), findsOneWidget);
  });

  // For some reason the two FutureResultBuilders are not considered equal if the type parameters are not specified.
  testWidgets('ignores initial value when reconfiguring', (tester) async {
    final key = GlobalKey();
    await tester.pumpWidget(FutureResultBuilder<String, String>.value(
      key: key,
      future: (_) => null,
      initial: 'I',
      builder: valueText,
    ));
    expect(find.text('I'), findsOneWidget);

    final completer = Completer<Result<String, String>>();
    await tester.pumpWidget(FutureResultBuilder<String, String>.value(
      key: key,
      future: (_) => completer.future,
      initial: 'Ignored',
      builder: valueText,
    ));

    await eventFiring(tester);
    expect(find.text('Ignored'), findsNothing);
    expect(find.text('I'), findsOneWidget);

    completer.complete(const Success('value'));
    await eventFiring(tester);
    expect(find.text('value'), findsOneWidget);
  });

  testWidgets('shows child', (tester) async {
    final key = GlobalKey();
    await tester.pumpWidget(FutureResultBuilder.value(
      key: key,
      future: (_) => null,
      initial: 'I',
      builder: (_, __, child) => child!,
      child: const Text('hello', textDirection: TextDirection.ltr),
    ));

    expect(find.text('hello'), findsOneWidget);
  });
}
