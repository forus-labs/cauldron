import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';

import 'package:out_of_context/out_of_context.dart';


/// A mock for [Router].
class MockRouter extends Mock implements Router {}

/// A mock for [RouterMixin]
mixin MockRouterMixin on RouterMixin {

  /// Returns a mocked [Router].
  @override
  // ignore: overridden_fields
  final MockRouter router = MockRouter();

}


/// A mock for [ScaffoldState].
class MockScaffoldState extends Mock implements ScaffoldState {

  /// Returns value of the `super.toString`.
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) => super.toString();

}

/// A mock for [ScaffoldMixin].
mixin MockScaffoldMixin on ScaffoldMixin {

  /// Returns a mocked [ScaffoldState].
  @override
  // ignore: overridden_fields
  final MockScaffoldState scaffold = MockScaffoldState();

}


/// A mock for [ChangeNotifier].
class MockNotifier extends Mock implements ChangeNotifier {}

/// A mock for [ChangeNotifier] that delegates all [ChangeNotifier] methods to [notifier].
mixin MockNotifierMixin on ChangeNotifier {

  /// A mock [ChangeNotifier] to which all [ChangeNotifier] methods are delegated.
  final MockNotifier notifier = MockNotifier();

  /// Delegates execution to [notifier].
  @override
  void addListener(VoidCallback listener) => notifier.addListener(listener);

  /// Delegates execution to [notifier].
  @override
  void removeListener(VoidCallback listener) => notifier.removeListener(listener);

  /// Delegates execution to [notifier].
  @override
  void notifyListeners() => notifier.notifyListeners();

  /// Delegates execution to [notifier].
  @override
  // ignore: must_call_super
  void dispose() => notifier.dispose();

}