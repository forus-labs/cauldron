import 'dart:async';

import 'package:flutter/widgets.dart';

/// A widget that builds itself based on the latest snapshot of interaction with a [Stream].
///
/// A [StreamValueBuilder] is an alternative to the in-built [StreamBuilder]. It contains numerous improvements over the
/// in-built [StreamBuilder]:
/// * Simplified usage
/// * Easy differentiation between a "nullable value" and "no value yet"
/// * Ability to pass a child to the builder function
/// * No implicit conversion of a non-nullable [T] to [T?]
///
/// ## Working with `StreamValueBuilder`:
/// To create a `StreamValueBuilder`:
/// ```dart
/// StreamValueBuilder(
///   stream: Stream.fromIterable(['Hello', 'World']),
///   builder: (context, value, child) => Text(value),
///   errorBuilder: (context, error, child) => Text('Error: $error'), // optional
///   emptyBuilder: (context, child) => CircularProgressIndicator(), // optional
/// )
/// ```
///
/// You can also set an initial value:
/// ```dart
/// StreamValueBuilder.value(
///   stream: Stream.fromIterable(['Hello', 'World']),
///   initial: 'Initial',
///   builder: (context, value, child) => Text(value),
///   errorBuilder: (context, error, child) => Text('Error: $error'), // optional
/// )
/// ```
///
/// [builder], [errorBuilder] and [emptyBuilder] also accept a [child] widget that is independent of the asynchronous computation:
/// ```dart
/// StreamValueBuilder(
///   stream: Stream.fromIterable(['Hello', 'World']),
///   builder: (context, value, child) => Row(children: [
///     Text(value),
///     child!,
///   ]),
///   child: Text('child widget'),
/// )
/// ```
///
/// You should use it to provide child widgets that don't depend on the [stream]'s result.
class StreamValueBuilder<T> extends StatefulWidget {

  /// The asynchronous computation to which this builder is currently connected.
  final Stream<T>? stream;

  /// The build strategy currently used by this builder when an initial value or value produced by [stream] is available.
  ///
  /// This builder must only return a widget and should not have any side effects as it may be called multiple times.
  final ValueWidgetBuilder<T> builder;

  /// The build strategy currently used by this builder when [stream] produces an error.
  ///
  /// This builder must only return a widget and should not have any side effects as it may be called multiple times.
  final ValueWidgetBuilder<(Object error, StackTrace stackTrace)>? errorBuilder;

  /// The build strategy currently used by this builder when no error or [T] is available.
  ///
  /// This builder must only return a widget and should not have any side effects as it may be called multiple times.
  final TransitionBuilder? emptyBuilder;

  /// A [stream]-independent widget which is passed back to the [builder].
  ///
  /// This argument is optional and can be null if the entire widget subtree the [builder] builds depends on the value
  /// of the [stream]. For example, in the case where the [stream] returns a [String] and the [builder] returns a [Text] widget
  /// with the current [String] value, there would be no useful [child].
  final Widget? child;

  final (T,)? _initial;

  /// Creates a [StreamValueBuilder] with no initial value.
  const StreamValueBuilder({
    required this.stream,
    required this.builder,
    this.errorBuilder,
    this.emptyBuilder,
    this.child,
    super.key,
  }): _initial = null;

  /// Creates a [StreamValueBuilder] with an initial value.
  const StreamValueBuilder.value({
    required this.stream,
    required T initial,
    required this.builder,
    this.errorBuilder,
    this.emptyBuilder,
    this.child,
    super.key,
  }): _initial = (initial,);

  @override
  State<StreamValueBuilder<T>> createState() => _StreamValueBuilderState();
}

/// This implementation is ported from [StreamBuilderBase].
class _StreamValueBuilderState<T> extends State<StreamValueBuilder<T>> {
  StreamSubscription<T>? _subscription; // ignore: cancel_subscriptions
  Object? _snapshot;

  @override
  void initState() {
    super.initState();
    if (widget._initial case (final initial,)) {
      _snapshot = (initial,);
    }
    _subscribe();
  }

  @override
  void didUpdateWidget(StreamValueBuilder<T> old) {
    super.didUpdateWidget(old);
    if (old.stream != widget.stream) {
      if (_subscription != null) {
        _unsubscribe();
      }
      _subscribe();
    }
  }

  @override
  Widget build(BuildContext context) => switch (_snapshot) {
    // This is wrapped in a record to differentiate between void and null when T is nullable.
    (final T value,) => widget.builder(context, value, widget.child),
    (final Object error, final StackTrace trace) => widget.errorBuilder?.call(context, (error, trace), widget.child) ?? const SizedBox(),
    _ => widget.emptyBuilder?.call(context, widget.child) ?? const SizedBox(),
  };

  void _subscribe() {
    if (widget.stream case final stream when stream != null) {
      _subscription = stream.listen((value) {
        setState(() {
          _snapshot = (value,);
        });
      }, onError: (error, stackTrace) {
        setState(() {
          _snapshot = (error, stackTrace);
        });
      });
    }
  }

  void _unsubscribe() {
    if (_subscription != null) {
      _subscription!.cancel();
      _subscription = null;
    }
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }
}
