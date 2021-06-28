import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:out_of_context/out_of_context.dart';
import 'package:mock_of_context/mock_of_context.dart';


class StubNavigationType with NavigationMixin, StubNavigationMixin {}

class StubScaffold with ScaffoldMixin, StubScaffoldMixin {}

class StubNotifier extends ChangeNotifier with StubNotifierMixin {}

void main() {

  group('StubNavigationMixin', () {

    test('router', () => expect(StubNavigationType().navigation, isA<StubNavigation>()));

  });

  group('StubScaffoldState', () {

    test('toString', () => expect(StubScaffoldState().toString(), isNotNull));

  });

  group('StubScaffoldMixin', () {

    test('scaffold', () => expect(StubScaffold().scaffold, isA<StubScaffoldState>()));

  });

  group('StubNotifierMixin', () {

    late StubNotifier notifier;
    void listen() {}

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