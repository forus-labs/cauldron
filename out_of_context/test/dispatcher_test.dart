import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter/widgets.dart';
import 'package:out_of_context/out_of_context.dart';


class Stub with DispatcherMixin {}

class StubDispatcher extends Dispatcher {

  @override
  final NavigatorState state = MockState();

}


class MockState extends Mock implements NavigatorState {

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) => super.toString();

}

class StubRoute extends Route<dynamic> {}

class T extends Object {}

class R extends Object {}


void main() {

  group('Dispatcher', () {

    test('dispatcher', () => expect(Stub().dispatcher, isNotNull));

  });

  group('Dispatcher', () {

    final dispatcher = StubDispatcher();
    final state = dispatcher.state;

    final arguments = T();
    final R result = R();
    final route = StubRoute();
    final old = StubRoute();
    bool predicate(Route<dynamic> route) => true;


    test('pushNamed', () {
      dispatcher.pushNamed('route', arguments: arguments);
      verify(state.pushNamed('route', arguments: arguments));
    });

    test('pushReplacementNamed', () {
      dispatcher.pushReplacementNamed('route', result: result, arguments: arguments);
      verify(state.pushReplacementNamed('route', result: result, arguments: arguments));
    });

    test('pushNamedAndRemoveUntil', () {
      dispatcher.pushNamedAndRemoveUntil('route', predicate, arguments: arguments);
      verify(state.pushNamedAndRemoveUntil('route', predicate, arguments: arguments));
    });

    test('push', () {
      dispatcher.push(route);
      verify(state.push(route));
    });

    test('pushReplacement', () {
      dispatcher.pushReplacement(route, result: result);
      verify(state.pushReplacement(route, result: result));
    });

    test('pushAndRemoveUntil', () {
      dispatcher.pushAndRemoveUntil(route, predicate);
      verify(state.pushAndRemoveUntil(route, predicate));
    });


    test('replace', () {
      dispatcher.replace(old: old, route: route);
      verify(state.replace(oldRoute: old, newRoute: route));
    });

    test('replaceRouteBelow', () {
      dispatcher.replaceRouteBelow(anchor: old, route: route);
      verify(state.replaceRouteBelow(anchorRoute: old, newRoute: route));
    });


    test('canPop', () {
      dispatcher.canPop();
      verify(state.canPop());
    });

    test('maybePop', () {
      dispatcher.maybePop();
      verify(state.maybePop());
    });


    test('pop', () {
      dispatcher.pop();
      verify(state.pop());
    });

    test('popUntil', () {
      dispatcher.popUntil(predicate);
      verify(state.popUntil(predicate));
    });

    test('popUntil', () {
      dispatcher.popUntil(predicate);
      verify(state.popUntil(predicate));
    });

    test('popAndPushNamed', () {
      dispatcher.popAndPushNamed('route', result: result, arguments: arguments);
      verify(state.popAndPushNamed('route', result: result, arguments: arguments));
    });


    test('removeRoute', () {
      dispatcher.removeRoute(route);
      verify(state.removeRoute(route));
    });

    test('removeRouteBelow', () {
      dispatcher.removeRouteBelow(route);
      verify(state.removeRouteBelow(route));
    });

  });

}