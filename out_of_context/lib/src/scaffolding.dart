import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

@visibleForTesting
// ignore: public_member_api_docs, type_annotate_public_apis
var scaffoldGlobalKey = GlobalKey<ScaffoldState>();

/// A mixin that provides a [ScaffoldState] without a [BuildContext].
mixin ScaffoldMixin {

  /// A [ScaffoldState].
  @visibleForTesting
  @protected ScaffoldState? get scaffold => scaffoldGlobalKey.currentState;

}
