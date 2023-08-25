import 'dart:async';

import 'package:flutter/widgets.dart';

/// A widget that builds itself based on the latest snapshot of interaction with a [Future].
///
/// A [FutureValueBuilder] is an alternative to the in-built [FutureBuilder]. It contains numerous improvements over the
/// in-built [FutureBuilder]:
/// * Simplified usage
/// * Easy differentiation between a "nullable value" and "no value yet"
/// * Memorizes a [Future], preventing the [Future] from being accidentally recomputed each time the widget is rebuilt.
/// * Ability to pass a child to the builder function
/// * No implicit conversion of a non-nullable [T] to [T?]
///
/// A common pitfall while using a [FutureBuilder] is recomputing a given [Future] each time:
/// ```dart
/// class Counterexample extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) => FutureBuilder(
///     future: computeAsync(), // Computed each time `Counterexample` is rebuilt
///     builder: (_, __) => Container(),
///   );
/// }
/// ```
///
/// Doing so is particularly dangerous if the async computing function is non-idempotent or contains side-effects. Not to
/// mention the impact on performance since most async computing functions are I/O bound.
///
/// A [FutureValueBuilder] prevents this by memoizing the result of the async computing function in subsequent rebuilds:
/// ```dart
/// class Example extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) => FutureValueBuilder(
///     future: () => computeAsync(), // Computed once when Example is created
///     builder: (_, __) => Container(),
///   );
/// }
///
/// ## Working with `FutureValueBuilder`:
/// To create a `FutureValueBuilder`:
/// ```dart
/// FutureValueBuilder(
///   future: () => computeAsync(),
///   builder: (context, value, child) => Text(value),
///   errorBuilder: (context, error, child) => Text('Error: $error'), // optional
///   emptyBuilder: (context, child) => CircularProgressIndicator(), // optional
/// )
///
/// You can also set an initial value:
/// ```dart
/// FutureValueBuilder.value(
///   future: () => computeAsync(),
///   initial: 'Initial',
///   builder: (context, value, child) => Text(value),
///   errorBuilder: (context, error, child) => Text('Error: $error'), // optional
/// )
/// ```
///
/// [builder], [errorBuilder] and [emptyBuilder] also accept a [child] widget that is independent of the asynchronous computation:
/// ```dart
/// FutureValueBuilder(
///   future: () => computeAsync(),,
///   builder: (context, value, child) => Row(children: [
///     Text(value),
///     child!,
///   ]),
///   child: Text('child widget'),
/// )
/// ```
///
/// You should use it to provide child widgets that don't depend on the [future]'s result.
class FutureValueBuilder<T> extends StatefulWidget {

  /// A function that starts an asynchronous computation to which this builder is currently connected.
  final Future<T>? Function(BuildContext) future;

  /// The build strategy currently used by this builder when an initial value or value produced by [future] is available.
  ///
  /// This builder must only return a widget and should not have any side effects as it may be called multiple times.
  final ValueWidgetBuilder<T> builder;

  /// The build strategy currently used by this builder when [future] produces an error.
  ///
  /// This builder must only return a widget and should not have any side effects as it may be called multiple times.
  final ValueWidgetBuilder<(Object error, StackTrace stackTrace)>? errorBuilder;

  /// The build strategy currently used by this builder when no error or [T] is available.
  ///
  /// This builder must only return a widget and should not have any side effects as it may be called multiple times.
  final TransitionBuilder? emptyBuilder;

  /// A future-independent widget which is passed back to the [builder].
  ///
  /// This argument is optional and can be null if the entire widget subtree the [builder] builds depends on the value
  /// of the future. For example, in the case where the future is a [String] and the [builder] returns a [Text] widget
  /// with the current [String] value, there would be no useful [child].
  final Widget? child;

  final (T,)? _initial;

  /// Creates an [FutureValueBuilder] with no initial value.
  const FutureValueBuilder({
    required this.future,
    required this.builder,
    this.errorBuilder,
    this.emptyBuilder,
    this.child,
    super.key,
  }): _initial = null;

  /// Creates an [FutureValueBuilder] with an initial value.
  const FutureValueBuilder.value({
    required this.future,
    required T initial,
    required this.builder,
    this.errorBuilder,
    this.child,
    super.key,
  }): emptyBuilder = null, _initial = (initial,);

  @override
  State<FutureValueBuilder<T>> createState() => _State();

}

class _State<T> extends State<FutureValueBuilder<T>> {
  /// An object that identifies the currently active callbacks. Used to avoid
  /// calling setState from stale callbacks, e.g. after disposal of this state,
  /// or after widget reconfiguration to a new Future.
  Object? _activeCallbackIdentity;
  Future<T>? _future;
  Object? _snapshot;

  @override
  void initState() {
    super.initState();

    _future = widget.future(context);
    if (widget._initial case (final initial,)) {
      _snapshot = initial;
    }

    _subscribe();
  }

  @override
  void didUpdateWidget(FutureValueBuilder<T> old) {
    super.didUpdateWidget(old);
    if (old.future == widget.future) {
      return;
    }

    _future = widget.future(context);
    _activeCallbackIdentity = null;
    _subscribe();
  }

  @override
  Widget build(BuildContext context) => switch (_snapshot) {
    final T value => widget.builder(context, value, widget.child),
    (final Object error, final StackTrace trace) => widget.errorBuilder?.call(context, (error, trace), widget.child) ?? const SizedBox(),
    _ => widget.emptyBuilder?.call(context, widget.child) ?? const SizedBox(),
  };

  void _subscribe() {
    if (_future case final future when future != null) {
      final callbackIdentity = Object();
      _activeCallbackIdentity = callbackIdentity;

      future.then<void>((value) {
        if (_activeCallbackIdentity == callbackIdentity) {
          setState(() => _snapshot = value);
        }
      }, onError: (error, stackTrace) {
        if (_activeCallbackIdentity == callbackIdentity) {
          setState(() => _snapshot = (error, stackTrace));
        }
      });
    }
  }

  @override
  void dispose() {
    _activeCallbackIdentity = null;
    super.dispose();
  }
}
