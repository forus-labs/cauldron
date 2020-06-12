import 'package:flutter/widgets.dart';


abstract class Keyed<T extends State> {

  const Keyed();

  @visibleForTesting
  @protected T get state => key.currentState;

  @visibleForTesting
  @protected GlobalKey<T> get key => GlobalKey<T>();

}