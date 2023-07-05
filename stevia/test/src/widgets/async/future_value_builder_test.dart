import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stevia/stevia.dart';

import 'async.dart';

void main() {
  testWidgets('gives expected snapshot with SynchronousFuture', (tester) async {
    final future = SynchronousFuture('flutter');
    await tester.pumpWidget(FutureValueBuilder<String>(
      future: future,
      builder: (context, snapshot, child) {
        switch (snapshot) {
          case ValueSnapshot(:final state, :final value):
            expect(state, ConnectionState.done);
            expect(value, 'flutter');
            expect(child, isNull);
            return const Placeholder();

          default:
            fail('Unexpected snapshot');
        }
      },
    ));
  });

  testWidgets('gracefully handles transition from null future', (tester) async {
    final key = GlobalKey();
    await tester.pumpWidget(FutureValueBuilder(
      key: key,
      future: null,
      builder: snapshotText,
    ));

    expect(find.text(EmptySnapshot(ConnectionState.none).toString()), findsOneWidget);

    final completer = Completer<String>();
    await tester.pumpWidget(FutureValueBuilder(
      key: key,
      future: completer.future,
      builder: snapshotText,
    ));
    expect(find.text(EmptySnapshot(ConnectionState.waiting).toString()), findsOneWidget);
  });

  testWidgets('gracefully handles transition to null future', (tester) async {
    final key = GlobalKey();
    final completer = Completer<String>();

    await tester.pumpWidget(FutureValueBuilder(
      key: key,
      future: completer.future,
      builder: snapshotText,
    ));
    expect(find.text(EmptySnapshot(ConnectionState.waiting).toString()), findsOneWidget);

    await tester.pumpWidget(FutureValueBuilder(
      key: key,
      future: null,
      builder: snapshotText,
    ));
    expect(find.text(EmptySnapshot(ConnectionState.none).toString()), findsOneWidget);

    completer.complete('hello');

    await eventFiring(tester);
    expect(find.text(EmptySnapshot(ConnectionState.none).toString()), findsOneWidget);
  });

  testWidgets('gracefully handles transition to other future', (tester) async {
    final key = GlobalKey();
    final completerA = Completer<String>();
    final completerB = Completer<String>();

    await tester.pumpWidget(FutureValueBuilder(
      key: key,
      future: completerA.future,
      builder: snapshotText,
    ));
    expect(find.text(EmptySnapshot(ConnectionState.waiting).toString()), findsOneWidget);

    await tester.pumpWidget(FutureValueBuilder(
      key: key,
      future: completerB.future,
      builder: snapshotText,
    ));
    expect(find.text(EmptySnapshot(ConnectionState.waiting).toString()), findsOneWidget);

    completerB.complete('B');
    completerA.complete('A');
    await eventFiring(tester);
    expect(find.text(const ValueSnapshot(ConnectionState.done, 'B').toString()), findsOneWidget);
  });

  testWidgets('tracks life-cycle of Future to success', (tester) async {
    final completer = Completer<String>();

    await tester.pumpWidget(FutureValueBuilder(future: completer.future, builder: snapshotText));
    expect(find.text(EmptySnapshot(ConnectionState.waiting).toString()), findsOneWidget);

    completer.complete('hello');
    await eventFiring(tester);
    expect(find.text(const ValueSnapshot(ConnectionState.done, 'hello').toString()), findsOneWidget);
  });

  testWidgets('tracks life-cycle of Future to error', (tester) async {
    final completer = Completer<String>();

    await tester.pumpWidget(FutureValueBuilder(future: completer.future, builder: snapshotText));
    expect(find.text(EmptySnapshot(ConnectionState.waiting).toString()), findsOneWidget);

    completer.completeError('bad', StackTrace.fromString('trace'));
    await eventFiring(tester);
    expect(
      find.text(ErrorSnapshot(ConnectionState.done, 'bad', StackTrace.fromString('trace')).toString()),
      findsOneWidget,
    );
  });

  testWidgets('runs the builder using given initial value', (tester) async {
    final key = GlobalKey();
    await tester.pumpWidget(FutureValueBuilder.value(
      key: key,
      future: null,
      initial: 'I',
      builder: snapshotText,
    ));
    expect(find.text(const ValueSnapshot(ConnectionState.none, 'I').toString()), findsOneWidget);
  });

  testWidgets('ignores initial value when reconfiguring', (tester) async {
    final key = GlobalKey();
    await tester.pumpWidget(FutureValueBuilder.value(
      key: key,
      future: null,
      initial: 'I',
      builder: snapshotText,
    ));
    expect(find.text(const ValueSnapshot(ConnectionState.none, 'I').toString()), findsOneWidget);

    final completer = Completer<String>();
    await tester.pumpWidget(FutureValueBuilder.value(
      key: key,
      future: completer.future,
      initial: 'Ignored',
      builder: snapshotText,
    ));
    expect(find.text(const ValueSnapshot(ConnectionState.waiting, 'I').toString()), findsOneWidget);
  });

  testWidgets('shows child', (tester) async {
    final key = GlobalKey();
    await tester.pumpWidget(FutureValueBuilder.value(
      key: key,
      future: null,
      initial: 'I',
      builder: (_, __, child) => child!,
      child: const Text('hello', textDirection: TextDirection.ltr),
    ));

    expect(find.text('hello'), findsOneWidget);
  });
}
