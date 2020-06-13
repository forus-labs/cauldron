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