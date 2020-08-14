import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:out_of_context/out_of_context.dart';

import 'package:mock_of_context/mock_of_context.dart';


class StubRouter with RouterMixin, MockRouterMixin {}

class StubScaffold with ScaffoldMixin, MockScaffoldMixin {}

class StubNotifier extends ChangeNotifier with MockNotifierMixin {}


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

  group('MockNotifierMixin', () {

    StubNotifier notifier;
    void listen() {};

    setUp(() => notifier = StubNotifier());

    test('addListener', () {
      notifier.addListener(listen);
      verify(notifier.notifier.addListener(listen));
    });

    test('removeListener', () {
      notifier.removeListener(listen);
      verify(notifier.notifier.removeListener(listen));
    });

    test('notifyListeners', () {
      notifier.notifyListeners();
      verify(notifier.notifier.notifyListeners());
    });

    test('dispose', () {
      notifier.dispose();
      verify(notifier.notifier.dispose());
    });

  });

}