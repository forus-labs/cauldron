import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stevia/stevia.dart';

import 'async.dart';

// ignore_for_file: close_sinks

void main() {
  testWidgets('gracefully handles transition from null stream', (tester) async {
    final key = GlobalKey();
    await tester.pumpWidget(StreamValueBuilder(key: key, stream: null, builder: valueText, emptyBuilder: emptyStreamText));
    expect(find.text('empty text'), findsOneWidget);

    final controller = StreamController<String>();
    await tester.pumpWidget(StreamValueBuilder(key: key, stream: controller.stream, builder: valueText, emptyBuilder: emptyStreamText));
    expect(find.text('empty text'), findsOneWidget);
  });

  testWidgets('gracefully handles transition to null stream', (tester) async {
    final key = GlobalKey();
    final controller = StreamController<String>();

    await tester.pumpWidget(StreamValueBuilder(key: key, stream: controller.stream, builder: valueText, emptyBuilder: emptyStreamText));
    expect(find.text('empty text'), findsOneWidget);

    await tester.pumpWidget(StreamValueBuilder(key: key, stream: null, builder: valueText, emptyBuilder: emptyStreamText));
    expect(find.text('empty text'), findsOneWidget);
  });

  testWidgets('gracefully handles transition to other stream', (tester) async {
    final key = GlobalKey();
    final controllerA = StreamController<String>();
    final controllerB = StreamController<String>();

    await tester.pumpWidget(StreamValueBuilder(key: key, stream: controllerA.stream, builder: valueText, emptyBuilder: emptyStreamText));
    expect(find.text('empty text'), findsOneWidget);

    await tester.pumpWidget(StreamValueBuilder(key: key, stream: controllerB.stream, builder: valueText));
    controllerB.add('B');
    controllerA.add('A');
    await eventFiring(tester);
    expect(find.text('B'), findsOneWidget);
  });

  testWidgets('tracks events and errors of stream until completion', (tester) async {
    final key = GlobalKey();
    final controller = StreamController<String>();

    await tester.pumpWidget(StreamValueBuilder(key: key, stream: controller.stream, builder: valueText, errorBuilder: errorText, emptyBuilder: emptyStreamText));
    expect(find.text('empty text'), findsOneWidget);

    controller..add('1')..add('2');
    await eventFiring(tester);
    expect(find.text('2'), findsOneWidget);

    controller..add('3')..addError('bad', StackTrace.fromString('trace'));
    await eventFiring(tester);
    expect(find.text(('bad', StackTrace.fromString('trace')).toString()), findsOneWidget);

    controller.add('4');
    await controller.close();
    await eventFiring(tester);
    expect(find.text('4'), findsOneWidget);
  });

  testWidgets('runs the builder using given initial value', (tester) async {
    final controller = StreamController<String>();
    await tester.pumpWidget(StreamValueBuilder.value(
      stream: controller.stream,
      initial: 'I',
      builder: valueText,
    ));
    expect(find.text('I'), findsOneWidget);
  });

  testWidgets('ignores initial when reconfiguring', (tester) async {
    final key = GlobalKey();
    await tester.pumpWidget(StreamValueBuilder.value(
      key: key,
      stream: null,
      initial: 'I',
      builder: valueText,
    ));
    expect(find.text('I'), findsOneWidget);

    final controller = StreamController<String>();
    await tester.pumpWidget(StreamValueBuilder.value(
      key: key,
      stream: controller.stream,
      initial: 'Ignored',
      builder: valueText,
    ));
    expect(find.text('I'), findsOneWidget);
  });

  testWidgets('shows child', (tester) async {
    final key = GlobalKey();
    await tester.pumpWidget(StreamValueBuilder.value(
      key: key,
      stream: null,
      initial: 'I',
      builder: (_, __, child) => child!,
      child: const Text('hello', textDirection: TextDirection.ltr),
    ));

    expect(find.text('hello'), findsOneWidget);
  });
}
