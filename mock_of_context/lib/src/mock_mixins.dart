import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';

import 'package:out_of_context/out_of_context.dart';


class MockDispatcher extends Mock implements Dispatcher {}

mixin MockDispatcherMixin on DispatcherMixin {

  @override
  // ignore: overridden_fields
  final MockDispatcher dispatcher = MockDispatcher();

}


class MockScaffoldState extends Mock implements ScaffoldState {

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) => super.toString();

}

mixin MockScaffoldMixin on ScaffoldMixin {

  @override
  // ignore: overridden_fields
  final MockScaffoldState scaffold = MockScaffoldState();

}


class MockNotifier extends Mock implements ChangeNotifier {}

mixin MockNotifierMixin on ChangeNotifier {

  final MockNotifier notifier = MockNotifier();

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