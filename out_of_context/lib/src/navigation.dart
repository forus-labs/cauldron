import 'package:flutter/widgets.dart';
import 'package:out_of_context/out_of_context.dart';

/// A mixin that provides a [Navigation].
mixin NavigationMixin {

  /// A [Navigation].
  @visibleForTesting
  @protected final Navigation navigation = const Navigation();

}

/// A wrapper for [Navigator] that does not require a [BuildContext].
class Navigation extends Keyed<NavigatorState> {

  /// Creates a [Navigation].
  const Navigation();

  /// Forwards execution to [Navigator.pushNamed].
  Future<T?> pushNamed<T>(String route, {Object? arguments}) async => state?.pushNamed(route, arguments: arguments);

  /// Forwards execution to [Navigator.pushReplacementNamed].
  Future<T?> pushReplacementNamed<T, R>(String route, {R? result, Object? arguments}) async => state?.pushReplacementNamed(route, result: result, arguments: arguments);

  /// Forwards execution to [Navigator.pushNamedAndRemoveUntil].
  Future<T?> pushNamedAndRemoveUntil<T>(String route, RoutePredicate predicate, {Object? arguments}) async => state?.pushNamedAndRemoveUntil(route, predicate, arguments: arguments);

  /// Forwards execution to [Navigator.push].
  Future<T?> push<T>(Route<T> route) async => state?.push(route);

  /// Forwards execution to [Navigator.pushReplacement].
  Future<T?> pushReplacement<T, R>(Route<T> route, {R? result}) async => state?.pushReplacement(route, result: result);

  /// Forwards execution to [Navigator.pushAndRemoveUntil].
  Future<T?> pushAndRemoveUntil<T>(Route<T> route, RoutePredicate predicate) async => state?.pushAndRemoveUntil(route, predicate);


  /// Forwards execution to [Navigator.replace].
  void replace<T>({required Route<dynamic> old, required Route<T> route}) => state?.replace(oldRoute: old, newRoute: route);

  /// Forwards execution to [Navigator.replaceRouteBelow].
  void replaceRouteBelow<T>({required Route<dynamic> anchor, required Route<T> route}) => state?.replaceRouteBelow(anchorRoute: anchor, newRoute: route);


  /// Forwards execution to [Navigator.canPop].
  bool canPop() => state?.canPop() ?? false;

  /// Forwards execution to [Navigator.maybePop].
  Future<bool> maybePop<T>([T? result]) async => await state?.maybePop(result) ?? false;


  /// Forwards execution to [Navigator.pop].
  void pop<T>([T? result]) => state?.pop(result);

  /// Forwards execution to [Navigator.popUntil].
  void popUntil(RoutePredicate predicate) => state?.popUntil(predicate);

  /// Forwards execution to [Navigator.popAndPushNamed].
  Future<T?> popAndPushNamed<T, R>(String route, {R? result, Object? arguments}) async => state?.popAndPushNamed(route, result: result, arguments: arguments);


  /// Forwards execution to [Navigator.removeRoute].
  void removeRoute(Route<dynamic> route) => state?.removeRoute(route);

  /// Forwards execution to [Navigator.removeRouteBelow].
  void removeRouteBelow(Route<dynamic> anchor) => state?.removeRouteBelow(anchor);

}