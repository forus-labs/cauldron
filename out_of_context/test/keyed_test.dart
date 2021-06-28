import 'package:flutter/widgets.dart';
import 'package:out_of_context/out_of_context.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'keyed_test.mocks.dart';

class StubKeyed extends Keyed<NavigatorState> {

  @override
  final GlobalKey<NavigatorState> key;

  StubKeyed(this.key);

}

class StubState extends Fake implements NavigatorState {

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) => super.toString();

}

@GenerateMocks([], customMocks: [MockSpec<GlobalKey<NavigatorState>>()])
void main() {

  test('state', () {
    final state = StubState();
    final key = MockGlobalKey();
    when(key.currentState).thenReturn(state);

    final keyed = StubKeyed(key);

    expect(keyed.state, state);
  });

  test('key', () => expect(const Keyed<NavigatorState>().key, isA<GlobalKey<NavigatorState>>()));

}