import 'package:flutter/widgets.dart';

import 'package:out_of_context/out_of_context.dart';


/// A mixin that provides a [Dispatcher].
mixin DispatcherMixin {

  /// A [Dispatcher].
  @visibleForTesting
  @protected final Dispatcher dispatcher = const Dispatcher();

}


/// A wrapper for [Navigator] that does not require a [BuildContext].
class Dispatcher extends Keyed<NavigatorState> {

  /// Creates a [Dispatcher]
  const Dispatcher();


  /// Forwards execution to [Navigator.pushNamed].
  Future<T> pushNamed<T>(String route, {Object arguments}) => state.pushNamed(route, arguments: arguments);

  /// Forwards execution to [Navigator.pushReplacementNamed].
  Future<T> pushReplacementNamed<T, R>(String route, {R result, Object arguments}) => state.pushReplacementNamed(route, result: result, arguments: arguments);

  /// Forwards execution to [Navigator.pushNamedAndRemoveUntil].
  Future<T> pushNamedAndRemoveUntil<T>(String route, RoutePredicate predicate, {Object arguments}) => state.pushNamedAndRemoveUntil(route, predicate, arguments: arguments);

  /// Forwards execution to [Navigator.push].
  Future<T> push<T>(Route<T> route) => state.push(route);

  /// Forwards execution to [Navigator.pushReplacement].
  Future<T> pushReplacement<T, R>(Route<T> route, {R result}) => state.pushReplacement(route, result: result);

  /// Forwards execution to [Navigator.pushAndRemoveUntil].
  Future<T> pushAndRemoveUntil<T>(Route<T> route, RoutePredicate predicate) => state.pushAndRemoveUntil(route, predicate);


  /// Forwards execution to [Navigator.replace].
  void replace<T>({@required Route<dynamic> old, @required Route<T> route}) => state.replace(oldRoute: old, newRoute: route);

  /// Forwards execution to [Navigator.replaceRouteBelow].
  void replaceRouteBelow<T>({@required Route<dynamic> anchor, @required Route<T> route}) => state.replaceRouteBelow(anchorRoute: anchor, newRoute: route);


  /// Forwards execution to [Navigator.canPop].
  bool canPop() => state.canPop();

  /// Forwards execution to [Navigator.maybePop].
  Future<bool> maybePop<T>({T result}) => state.maybePop();


  /// Forwards execution to [Navigator.pop].
  void pop<T>({T result}) => state.pop(result);

  /// Forwards execution to [Navigator.popUntil].
  void popUntil(RoutePredicate predicate) => state.popUntil(predicate);

  /// Forwards execution to [Navigator.popAndPushNamed].
  Future<T> popAndPushNamed<T, R>(String route, {R result, Object arguments}) => state.popAndPushNamed(route, result: result, arguments: arguments);


  /// Forwards execution to [Navigator.removeRoute].
  void removeRoute(Route<dynamic> route) => state.removeRoute(route);

  /// Forwards execution to [Navigator.removeRouteBelow].
  void removeRouteBelow(Route<dynamic> anchor) => state.removeRouteBelow(anchor);

}