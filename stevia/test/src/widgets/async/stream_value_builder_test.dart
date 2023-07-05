import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stevia/stevia.dart';

import 'async.dart';

// ignore_for_file: close_sinks

void main() {
  testWidgets('gracefully handles transition from null stream', (tester) async {
    final key = GlobalKey();
    await tester.pumpWidget(StreamValueBuilder(key: key, stream: null, builder: snapshotText));
    expect(find.text(EmptySnapshot(ConnectionState.none).toString()), findsOneWidget);

    final controller = StreamController<String>();
    await tester.pumpWidget(StreamValueBuilder(key: key, stream: controller.stream, builder: snapshotText));
    expect(find.text(EmptySnapshot(ConnectionState.waiting).toString()), findsOneWidget);
  });

  testWidgets('gracefully handles transition to null stream', (tester) async {
    final key = GlobalKey();
    final controller = StreamController<String>();

    await tester.pumpWidget(StreamValueBuilder(key: key, stream: controller.stream, builder: snapshotText));
    expect(find.text(EmptySnapshot(ConnectionState.waiting).toString()), findsOneWidget);

    await tester.pumpWidget(StreamValueBuilder(key: key, stream: null, builder: snapshotText));
    expect(find.text(EmptySnapshot(ConnectionState.none).toString()), findsOneWidget);
  });

  testWidgets('gracefully handles transition to other stream', (tester) async {
    final key = GlobalKey();
    final controllerA = StreamController<String>();
    final controllerB = StreamController<String>();

    await tester.pumpWidget(StreamValueBuilder(key: key, stream: controllerA.stream, builder: snapshotText));
    expect(find.text(EmptySnapshot(ConnectionState.waiting).toString()), findsOneWidget);

    await tester.pumpWidget(StreamValueBuilder(key: key, stream: controllerB.stream, builder: snapshotText));
    controllerB.add('B');
    controllerA.add('A');
    await eventFiring(tester);
    expect(find.text(const ValueSnapshot(ConnectionState.active, 'B').toString()), findsOneWidget);
  });

  testWidgets('tracks events and errors of stream until completion', (tester) async {
    final key = GlobalKey();
    final controller = StreamController<String>();

    await tester.pumpWidget(StreamValueBuilder(key: key, stream: controller.stream, builder: snapshotText));
    expect(find.text(EmptySnapshot(ConnectionState.waiting).toString()), findsOneWidget);

    controller..add('1')..add('2');
    await eventFiring(tester);
    expect(find.text(const ValueSnapshot(ConnectionState.active, '2').toString()), findsOneWidget);

    controller..add('3')..addError('bad', StackTrace.fromString('trace'));
    await eventFiring(tester);
    expect(find.text(ErrorSnapshot(ConnectionState.active, 'bad', StackTrace.fromString('trace')).toString()), findsOneWidget);

    controller.add('4');
    await controller.close();
    await eventFiring(tester);
    expect(find.text(const ValueSnapshot(ConnectionState.done, '4').toString()), findsOneWidget);
  });

  testWidgets('runs the builder using given initial value', (tester) async {
    final controller = StreamController<String>();
    await tester.pumpWidget(StreamValueBuilder.value(
      stream: controller.stream,
      initial: 'I',
      builder: snapshotText,
    ));
    expect(find.text(const ValueSnapshot(ConnectionState.waiting, 'I').toString()), findsOneWidget);
  });

  testWidgets('ignores initial when reconfiguring', (tester) async {
    final key = GlobalKey();
    await tester.pumpWidget(StreamValueBuilder.value(
      key: key,
      stream: null,
      initial: 'I',
      builder: snapshotText,
    ));
    expect(find.text(const ValueSnapshot(ConnectionState.none, 'I').toString()), findsOneWidget);

    final controller = StreamController<String>();
    await tester.pumpWidget(StreamValueBuilder.value(
      key: key,
      stream: controller.stream,
      initial: 'Ignored',
      builder: snapshotText,
    ));
    expect(find.text(const ValueSnapshot(ConnectionState.waiting, 'I').toString()), findsOneWidget);
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
