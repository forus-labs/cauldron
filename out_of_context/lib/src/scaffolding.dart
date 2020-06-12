import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


final _scaffold = GlobalKey<ScaffoldState>();


mixin ScaffoldMixin {

  @protected ScaffoldState get scaffold => _scaffold.currentState;

}
