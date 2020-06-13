import 'package:flutter/widgets.dart';


/// A class that contains a [GlobalKey] of the type, [T].
class Keyed<T extends State> {

  /// Creates a [Keyed].
  const Keyed();

  /// The current state of [key].
  @visibleForTesting
  @protected T get state => key.currentState;

  /// A [GlobalKey] for the type, [T].
  @visibleForTesting
  @protected GlobalKey<T> get key => GlobalKey<T>();

}