import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';

import 'package:out_of_context/out_of_context.dart';


class MockRouter extends Mock implements Router {}


mixin MockRouterMixin on RouterMixin {

  @override
  // ignore: overridden_fields
  final MockRouter router = MockRouter();

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