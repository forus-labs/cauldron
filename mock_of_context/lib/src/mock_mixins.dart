import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:out_of_context/out_of_context.dart';

import 'mock_mixins.mocks.dart'; // ignore: always_use_package_imports

/// A stub for [Navigation].
class StubNavigation extends Fake implements Navigation {}

/// A stub for [NavigationMixin].
mixin StubNavigationMixin on NavigationMixin {

  @override
  // ignore: overridden_fields
  final StubNavigation navigation = StubNavigation();

}

/// A stub for [ScaffoldState].
class StubScaffoldState extends Fake implements ScaffoldState {

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) => super.toString();

}

/// A stub for [ScaffoldMixin].
mixin StubScaffoldMixin on ScaffoldMixin {

  @override
  // ignore: overridden_fields
  final StubScaffoldState scaffold = StubScaffoldState();

}

/// A stub for [ChangeNotifier] that delegates all [ChangeNotifier] methods to [notifier].
mixin StubNotifierMixin on ChangeNotifier {

  /// A mock [ChangeNotifier] to which all [ChangeNotifier] methods are delegated.
  final MockChangeNotifier notifier = MockChangeNotifier();

  @override
  void addListener(VoidCallback listener) => notifier.addListener(listener);

  @override
  void removeListener(VoidCallback listener) => notifier.removeListener(listener);

  @override
  void notifyListeners() => notifier.notifyListeners();

  @override
  // ignore: must_call_super
  void dispose() => notifier.dispose();

}