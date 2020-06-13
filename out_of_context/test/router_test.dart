import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter/widgets.dart';
import 'package:out_of_context/out_of_context.dart';


class Stub with RouterMixin {}

class StubRouter extends Router {

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

  group('RouterMixin', () {

    test('router', () => expect(Stub().router, isNotNull));

  });

  group('Router', () {

    final router = StubRouter();
    final state = router.state;

    final arguments = T();
    final R result = R();
    final route = StubRoute();
    final old = StubRoute();
    bool predicate(Route<dynamic> route) => true;


    test('pushNamed', () {
      router.pushNamed('route', arguments: arguments);
      verify(state.pushNamed('route', arguments: arguments));
    });

    test('pushReplacementNamed', () {
      router.pushReplacementNamed('route', result: result, arguments: arguments);
      verify(state.pushReplacementNamed('route', result: result, arguments: arguments));
    });

    test('pushNamedAndRemoveUntil', () {
      router.pushNamedAndRemoveUntil('route', predicate, arguments: arguments);
      verify(state.pushNamedAndRemoveUntil('route', predicate, arguments: arguments));
    });

    test('push', () {
      router.push(route);
      verify(state.push(route));
    });

    test('pushReplacement', () {
      router.pushReplacement(route, result: result);
      verify(state.pushReplacement(route, result: result));
    });

    test('pushAndRemoveUntil', () {
      router.pushAndRemoveUntil(route, predicate);
      verify(state.pushAndRemoveUntil(route, predicate));
    });


    test('replace', () {
      router.replace(old: old, route: route);
      verify(state.replace(oldRoute: old, newRoute: route));
    });

    test('replaceRouteBelow', () {
      router.replaceRouteBelow(anchor: old, route: route);
      verify(state.replaceRouteBelow(anchorRoute: old, newRoute: route));
    });


    test('canPop', () {
      router.canPop();
      verify(state.canPop());
    });

    test('maybePop', () {
      router.maybePop();
      verify(state.maybePop());
    });


    test('pop', () {
      router.pop();
      verify(state.pop());
    });

    test('popUntil', () {
      router.popUntil(predicate);
      verify(state.popUntil(predicate));
    });

    test('popUntil', () {
      router.popUntil(predicate);
      verify(state.popUntil(predicate));
    });

    test('popAndPushNamed', () {
      router.popAndPushNamed('route', result: result, arguments: arguments);
      verify(state.popAndPushNamed('route', result: result, arguments: arguments));
    });


    test('removeRoute', () {
      router.removeRoute(route);
      verify(state.removeRoute(route));
    });

    test('removeRouteBelow', () {
      router.removeRouteBelow(route);
      verify(state.removeRouteBelow(route));
    });

  });

}