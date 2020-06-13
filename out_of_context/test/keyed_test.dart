import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter/widgets.dart';
import 'package:out_of_context/src/keyed.dart';


class MockState extends Mock implements NavigatorState {

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) => super.toString();

}

// ignore: must_be_immutable
class MockKey extends Mock implements GlobalKey<NavigatorState> {}


class Stub extends Keyed<NavigatorState> {

  @override
  final GlobalKey<NavigatorState> key;

  Stub(this.key);

}


void main() {

  test('state', () {
    final state = MockState();

    final key = MockKey();
    when(key.currentState).thenReturn(state);

    final keyed = Stub(key);


    expect(keyed.state, state);

  });

  test('key', () => expect(const Keyed<NavigatorState>().key, isA<GlobalKey<NavigatorState>>()));

}