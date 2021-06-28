import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter/widgets.dart';
import 'package:out_of_context/out_of_context.dart';

class StubNavigationMixin with NavigationMixin {}

class StubNavigation extends Navigation {

  @override
  final NavigatorState state = StubState();

}

class StubState extends Fake implements NavigatorState {

  @override
  Future<T?> pushNamed<T>(String route, {Object? arguments}) => Future.value(null);

  @override
  Future<T?> pushReplacementNamed<T, TO>(String routeName, {TO? result, Object? arguments}) => Future.value(null);

  @override
  Future<T?> pushNamedAndRemoveUntil<T>(String newRouteName, RoutePredicate predicate, {Object? arguments,}) => Future.value(null);

  @override
  Future<T?> push<T>(Route<T> route) => Future.value(null);

  @override
  Future<T?> pushReplacement<T, R>(Route<T> route, {R? result}) => Future.value(null);

  @override
  Future<T?> pushAndRemoveUntil<T>(Route<T> route, RoutePredicate predicate) => Future.value(null);

  @override
  void replace<T>({required Route<dynamic> oldRoute, required Route<T> newRoute}) {}

  @override
  void replaceRouteBelow<T>({required Route<dynamic> anchorRoute, required Route<T> newRoute}) {}

  @override
  bool canPop() => true;

  @override
  Future<bool> maybePop<T>([T? result]) => Future.value(true);

  @override
  void pop<T>([T? result]) {}

  @override
  void popUntil(RoutePredicate predicate) {}

  @override
  Future<T?> popAndPushNamed<T, R>(String route, {R? result, Object? arguments}) => Future.value(null);

  @override
  void removeRoute(Route<dynamic> route) {}

  @override
  void removeRouteBelow(Route<dynamic> anchor) {}

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) => super.toString();

}

class StubRoute extends Route<dynamic> {}

class T extends Object {}

class R extends Object {}

void main() {

  group('Navigation', () {
    test('navigation', () => expect(StubNavigationMixin().navigation, isNotNull));
  });
// TODO; https://github.com/dart-lang/mockito/issues/438
//   group('Navigation', () {
//     final navigation = StubNavigation();
//     final state = navigation.state;
//
//     final arguments = T();
//     final R result = R();
//     final route = StubRoute();
//     final old = StubRoute();
//     bool predicate(Route<dynamic> route) => true;
//
//     test('pushNamed', () {
//       expect(navigation.pushNamed('route', arguments: arguments), isNull);
//     });
//
//     test('pushReplacementNamed', () {
//       navigation.pushReplacementNamed('route', result: result, arguments: arguments);
//       verify(state.pushReplacementNamed('route', result: result, arguments: arguments));
//     });
//
//     test('pushNamedAndRemoveUntil', () {
//       navigation.pushNamedAndRemoveUntil('route', predicate, arguments: arguments);
//       verify(state.pushNamedAndRemoveUntil('route', predicate, arguments: arguments));
//     });
//
//     test('push', () {
//       navigation.push(route);
//       verify(state.push(route));
//     });
//
//     test('pushReplacement', () {
//       navigation.pushReplacement(route, result: result);
//       verify(state.pushReplacement(route, result: result));
//     });
//
//     test('pushAndRemoveUntil', () {
//       navigation.pushAndRemoveUntil(route, predicate);
//       verify(state.pushAndRemoveUntil(route, predicate));
//     });
//
//
//     test('replace', () {
//       navigation.replace(old: old, route: route);
//       verify(state.replace(oldRoute: old, newRoute: route));
//     });
//
//     test('replaceRouteBelow', () {
//       navigation.replaceRouteBelow(anchor: old, route: route);
//       verify(state.replaceRouteBelow(anchorRoute: old, newRoute: route));
//     });
//
//
//     test('canPop', () {
//       navigation.canPop();
//       verify(state.canPop());
//     });
//
//     test('maybePop', () {
//       navigation.maybePop();
//       verify(state.maybePop());
//     });
//
//
//     test('pop', () {
//       navigation.pop();
//       verify(state.pop());
//     });
//
//     test('popUntil', () {
//       navigation.popUntil(predicate);
//       verify(state.popUntil(predicate));
//     });
//
//     test('popUntil', () {
//       navigation.popUntil(predicate);
//       verify(state.popUntil(predicate));
//     });
//
//     test('popAndPushNamed', () {
//       navigation.popAndPushNamed('route', result: result, arguments: arguments);
//       verify(state.popAndPushNamed('route', result: result, arguments: arguments));
//     });
//
//
//     test('removeRoute', () {
//       navigation.removeRoute(route);
//       verify(state.removeRoute(route));
//     });
//
//     test('removeRouteBelow', () {
//       navigation.removeRouteBelow(route);
//       verify(state.removeRouteBelow(route));
//     });
//
//   });
//
}