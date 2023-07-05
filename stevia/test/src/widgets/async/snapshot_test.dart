import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stevia/stevia.dart';

import 'async.dart';

void main() {
  group('EmptySnapshot', () {
    test('transition(...)', () {
      final snapshot = EmptySnapshot(ConnectionState.none);
      expect(snapshot.state, ConnectionState.none);
      expect(snapshot.transition(to: ConnectionState.done).state, ConnectionState.done);
    });

    for (final (other, expected) in [
      (EmptySnapshot<String>(ConnectionState.done), true),
      (EmptySnapshot<String>(ConnectionState.waiting), false),
      (EmptySnapshot<int>(ConnectionState.done), false),
      ('', false)
    ]) {
      test('== $other', () => expect(EmptySnapshot<String>(ConnectionState.done) == other, expected));
    }

    for (final (other, expected) in [
      (EmptySnapshot<String>(ConnectionState.done), true),
      (EmptySnapshot<String>(ConnectionState.waiting), false),
      (EmptySnapshot<int>(ConnectionState.done), true),
      ('', false)
    ]) {
      test('hashCode $other', () => expect(EmptySnapshot<String>(ConnectionState.done).hashCode == other.hashCode, expected));
    }

    test('toString()', () => expect(
      EmptySnapshot<String>(ConnectionState.waiting).toString(),
      'EmptySnapshot(state: ConnectionState.waiting)',
    ));
  });

  group('ValueSnapshot', () {
    test('transition(...)', () {
      const snapshot = ValueSnapshot(ConnectionState.none, 'some');
      final ValueSnapshot(:state, :value) = snapshot.transition(to: ConnectionState.done);

      expect(snapshot.state, ConnectionState.none);
      expect(snapshot.value, 'some');
      expect(state, ConnectionState.done);
      expect(value, 'some');
    });

    for (final (other, expected) in [
      (const ValueSnapshot<String>(ConnectionState.done, 'some'), true),
      (const ValueSnapshot<String>(ConnectionState.done, 'f'), false),
      (const ValueSnapshot<String>(ConnectionState.waiting, 'some'), false),
      (const ValueSnapshot<int>(ConnectionState.done, 1), false),
      ('', false)
    ]) {
      test('== $other', () => expect(const ValueSnapshot<String>(ConnectionState.done, 'some') == other, expected));

      test('hashCode $other', () => expect(
        const ValueSnapshot<String>(ConnectionState.done, 'some').hashCode == other.hashCode,
        expected,
      ));
    }

    test('toString()', () => expect(
      const ValueSnapshot(ConnectionState.waiting, 1).toString(),
      'ValueSnapshot(state: ConnectionState.waiting, value: 1)',
    ));
  });

  group('ErrorSnapshot', () {
    test('transition(...)', () {
      const snapshot = ErrorSnapshot(ConnectionState.none, 'some');
      final ErrorSnapshot(:state, :error, :stackTrace) = snapshot.transition(to: ConnectionState.done);

      expect(snapshot.state, ConnectionState.none);
      expect(snapshot.error, 'some');
      expect(snapshot.stackTrace, StackTrace.empty);
      expect(state, ConnectionState.done);
      expect(error, 'some');
      expect(stackTrace, StackTrace.empty);
    });

    for (final (other, expected) in [
      (const ErrorSnapshot<String>(ConnectionState.done, 'some'), true),
      (const ErrorSnapshot<String>(ConnectionState.done, 'f'), false),
      (const ErrorSnapshot<String>(ConnectionState.waiting, 'some'), false),
      (const ErrorSnapshot<int>(ConnectionState.done, 1), false),
      ('', false)
    ]) {
      test('== $other', () => expect(const ErrorSnapshot<String>(ConnectionState.done, 'some') == other, expected));

      test('hashCode $other', () => expect(
        const ErrorSnapshot<String>(ConnectionState.done, 'some').hashCode == other.hashCode,
        expected,
      ));
    }

    test('toString()', () => expect(
      const ErrorSnapshot(ConnectionState.waiting, 1).toString(),
      'ErrorSnapshot(state: ConnectionState.waiting, error: 1, stackTrace: )',
    ));
  });

  group('smoke tests', () {
    testWidgets('FutureValueBuilder', (tester) async {
      await tester.pumpWidget(FutureValueBuilder(
        future: Future.value('hello'),
        builder: snapshotText,
      ));

      await eventFiring(tester);
    });

    testWidgets('StreamValueBuilder', (tester) async {
      await tester.pumpWidget(StreamValueBuilder(
        stream: Stream.fromIterable(['hello', 'world']),
        builder: snapshotText,
      ));

      await eventFiring(tester);
    });
  });
}
