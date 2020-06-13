import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


final _scaffold = GlobalKey<ScaffoldState>();


/// A mixin that provides a [ScaffoldState] without a [BuildContext].
mixin ScaffoldMixin {

  /// A [ScaffoldState].
  @visibleForTesting
  @protected ScaffoldState get scaffold => _scaffold.currentState;

}
