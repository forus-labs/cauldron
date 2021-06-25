import 'package:flutter/widgets.dart';

import 'package:out_of_context/out_of_context.dart';


mixin DispatcherMixin {

  @visibleForTesting
  @protected final Dispatcher dispatcher = const Dispatcher();

}


class Dispatcher extends Keyed<NavigatorState> {

  const Dispatcher();

  
  Future<T> pushNamed<T>(String route, {Object arguments}) => state.pushNamed(route, arguments: arguments);

  Future<T> pushReplacementNamed<T, R>(String route, {R result, Object arguments}) => state.pushReplacementNamed(route, result: result, arguments: arguments);

  Future<T> pushNamedAndRemoveUntil<T>(String route, RoutePredicate predicate, {Object arguments}) => state.pushNamedAndRemoveUntil(route, predicate, arguments: arguments);

  Future<T> push<T>(Route<T> route) => state.push(route);

  Future<T> pushReplacement<T, R>(Route<T> route, {R result}) => state.pushReplacement(route, result: result);

  Future<T> pushAndRemoveUntil<T>(Route<T> route, RoutePredicate predicate) => state.pushAndRemoveUntil(route, predicate);


  void replace<T>({@required Route<dynamic> old, @required Route<T> route}) => state.replace(oldRoute: old, newRoute: route);

  void replaceRouteBelow<T>({@required Route<dynamic> anchor, @required Route<T> route}) => state.replaceRouteBelow(anchorRoute: anchor, newRoute: route);


  bool canPop() => state.canPop();

  Future<bool> maybePop<T>({T result}) => state.maybePop();


  void pop<T>({T result}) => state.pop(result);

  void popUntil(RoutePredicate predicate) => state.popUntil(predicate);

  Future<T> popAndPushNamed<T, R>(String route, {R result, Object arguments}) => state.popAndPushNamed(route, result: result, arguments: arguments);


  void removeRoute(Route<dynamic> route) => state.removeRoute(route);

  void removeRouteBelow(Route<dynamic> anchor) => state.removeRouteBelow(anchor);

}