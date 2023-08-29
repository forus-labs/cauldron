import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stevia/stevia.dart';

import 'async.dart';

void main() {
  testWidgets('when completing with data', (tester) async {
    final completer = Completer<String>();
    
    await tester.pumpWidget(Column(children: [
      FutureValueBuilder(future: (_) => completer.future, builder: valueText, emptyBuilder: emptyFutureText),
      StreamValueBuilder(stream: completer.future.asStream(), builder: valueText, emptyBuilder: emptyStreamText),
    ]));
    expect(find.text('empty text'), findsNWidgets(2));
    
    completer.complete('hello');
    await eventFiring(tester);
    expect(find.text('hello'), findsNWidgets(2));
  });
  
  testWidgets('when completing with error and with empty stack trace', (tester) async {
    final completer = Completer<String>();

    await tester.pumpWidget(Column(children: [
      FutureValueBuilder(future: (_) => completer.future, builder: valueText, errorBuilder: errorText, emptyBuilder: emptyFutureText),
      StreamValueBuilder(stream: completer.future.asStream(), builder: valueText, errorBuilder: errorText, emptyBuilder: emptyStreamText),
    ]));
    expect(find.text('empty text'), findsNWidgets(2));

    completer.completeError('bad', StackTrace.empty);
    await eventFiring(tester);
    expect(find.text(('bad', StackTrace.empty).toString()), findsNWidgets(2));
  });

  testWidgets('when completing with error and with stack trace', (tester) async {
    final completer = Completer<String>();

    await tester.pumpWidget(Column(children: [
      FutureValueBuilder(future: (_) => completer.future, builder: valueText, errorBuilder: errorText, emptyBuilder: emptyFutureText),
      StreamValueBuilder(stream: completer.future.asStream(), builder: valueText, errorBuilder: errorText, emptyBuilder: emptyStreamText),
    ]));

    expect(find.text('empty text'), findsNWidgets(2));
    completer.completeError('bad', StackTrace.fromString('trace'));

    await eventFiring(tester);
    expect(find.text(('bad', StackTrace.fromString('trace')).toString()), findsNWidgets(2));
  });

  testWidgets('when Future is null', (tester) async {
    await tester.pumpWidget(Column(children: [
      FutureValueBuilder(future: (_) => null, builder: valueText, emptyBuilder: emptyFutureText),
      const StreamValueBuilder(stream: null, builder: valueText, emptyBuilder: emptyStreamText),
    ]));

    expect(find.text('empty text'), findsNWidgets(2));
  });

  testWidgets('when initialData is used with null Future and Stream', (tester) async {
    // ignore: prefer_const_constructors, prefer_const_literals_to_create_immutables
    await tester.pumpWidget(Column(children: [
      FutureValueBuilder.value(future: (_) => null, initial: 'I', builder: valueText), // ignore: prefer_const_constructors
      StreamValueBuilder.value(stream: null, initial: 'I', builder: valueText), // ignore: prefer_const_constructors
    ]));

    expect(find.text('I'), findsNWidgets(2));
  });

  testWidgets('when using initialData and completing with data', (tester) async {
    final completer = Completer<String>();
    await tester.pumpWidget(Column(children: [
      FutureValueBuilder.value(future: (_) => completer.future, initial: 'I', builder: valueText), // ignore: prefer_const_constructors
      StreamValueBuilder.value(stream: completer.future.asStream(), initial: 'I', builder: valueText), // ignore: prefer_const_constructors
    ]));
    expect(find.text('I'), findsNWidgets(2));

    completer.complete('hello');
    await eventFiring(tester);
    expect(find.text('hello'), findsNWidgets(2));
  });
}
