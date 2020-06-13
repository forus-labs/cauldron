import 'package:flutter_test/flutter_test.dart';
import 'package:mock_of_context/mock_of_context.dart';

import 'package:out_of_context/out_of_context.dart';


class StubRouter with RouterMixin, MockRouterMixin {}

class StubScaffold with ScaffoldMixin, MockScaffoldMixin {}


void main() {

  group('MockRouterMixin', () {

    test('router', () => expect(StubRouter().router, isA<MockRouter>()));

  });

  group('MockScaffoldState', () {

    test('toString', () => expect(MockScaffoldState().toString(), isNotNull));

  });

  group('MockScaffoldMixin', () {

    test('scaffold', () => expect(StubScaffold().scaffold, isA<MockScaffoldState>()));

  });

}