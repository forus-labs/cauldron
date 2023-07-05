import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stevia/stevia.dart';

import 'async.dart';

void main() {
  testWidgets('when completing with data', (tester) async {
    final completer = Completer<String>();
    
    await tester.pumpWidget(Column(children: [
      FutureValueBuilder(future: completer.future, builder: snapshotText),
      StreamValueBuilder(stream: completer.future.asStream(), builder: snapshotText),
    ]));
    expect(find.text(EmptySnapshot(ConnectionState.waiting).toString()), findsNWidgets(2));
    
    completer.complete('hello');
    await eventFiring(tester);
    expect(find.text(const ValueSnapshot(ConnectionState.done, 'hello').toString()), findsNWidgets(2));
  });
  
  testWidgets('when completing with error and with empty stack trace', (tester) async {
    final completer = Completer<String>();

    await tester.pumpWidget(Column(children: [
      FutureValueBuilder(future: completer.future, builder: snapshotText),
      StreamValueBuilder(stream: completer.future.asStream(), builder: snapshotText),
    ]));
    expect(find.text(EmptySnapshot(ConnectionState.waiting).toString()), findsNWidgets(2));

    completer.completeError('bad', StackTrace.empty);
    await eventFiring(tester);
    expect(find.text(const ErrorSnapshot(ConnectionState.done, 'bad').toString()), findsNWidgets(2));
  });

  testWidgets('when completing with error and with stack trace', (tester) async {
    final completer = Completer<String>();

    await tester.pumpWidget(Column(children: [
      FutureValueBuilder(future: completer.future, builder: snapshotText),
      StreamValueBuilder(stream: completer.future.asStream(), builder: snapshotText),
    ]));

    expect(find.text(EmptySnapshot(ConnectionState.waiting).toString()), findsNWidgets(2));
    completer.completeError('bad', StackTrace.fromString('trace'));

    await eventFiring(tester);
    expect(find.text(ErrorSnapshot(ConnectionState.done, 'bad', StackTrace.fromString('trace')).toString()), findsNWidgets(2));
  });

  testWidgets('when Future is null', (tester) async {
    await tester.pumpWidget(const Column(children: [
      FutureValueBuilder(future: null, builder: snapshotText),
      StreamValueBuilder(stream: null, builder: snapshotText),
    ]));

    expect(find.text(EmptySnapshot(ConnectionState.none).toString()), findsNWidgets(2));
  });

  testWidgets('when initialData is used with null Future and Stream', (tester) async {
    // ignore: prefer_const_constructors, prefer_const_literals_to_create_immutables
    await tester.pumpWidget(Column(children: [
      FutureValueBuilder.value(future: null, initial: 'I', builder: snapshotText), // ignore: prefer_const_constructors
      StreamValueBuilder.value(stream: null, initial: 'I', builder: snapshotText), // ignore: prefer_const_constructors
    ]));

    expect(find.text(const ValueSnapshot(ConnectionState.none, 'I').toString()), findsNWidgets(2));
  });

  testWidgets('when using initialData and completing with data', (tester) async {
    final completer = Completer<String>();
    await tester.pumpWidget(Column(children: [
      FutureValueBuilder.value(future: completer.future, initial: 'I', builder: snapshotText), // ignore: prefer_const_constructors
      StreamValueBuilder.value(stream: completer.future.asStream(), initial: 'I', builder: snapshotText), // ignore: prefer_const_constructors
    ]));
    expect(find.text(const ValueSnapshot(ConnectionState.waiting, 'I').toString()), findsNWidgets(2));

    completer.complete('hello');
    await eventFiring(tester);
    expect(find.text(const ValueSnapshot(ConnectionState.done, 'hello').toString()), findsNWidgets(2));
  });
}
