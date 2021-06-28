import 'package:flutter/material.dart';
import 'package:out_of_context/out_of_context.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'scaffolding_test.mocks.dart';

class StubScaffoldMixin with ScaffoldMixin {}

@GenerateMocks([], customMocks: [MockSpec<GlobalKey<ScaffoldState>>()])
void main() {

  test('scaffold', () {
    final key = MockGlobalKey();
    when(key.currentState).thenReturn(ScaffoldState());

    scaffoldGlobalKey = key;

    expect(StubScaffoldMixin().scaffold, isNotNull);
  });

}