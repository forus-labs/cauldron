import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:stevia/widgets.dart';

/// A widget that builds itself based on the latest snapshot of interaction with a [Stream].
///
/// A [StreamValueBuilder] is an alternative to the in-built [StreamBuilder]. It contains numerous improvements over the
/// in-built [StreamBuilder]:
///
/// * Easy differentiation between a "nullable value" and "no value yet"
/// * Ability to pass a child to the builder function
/// * No implicit conversion of a non-nullable [T] to [T?]
///
/// ## Working with `StreamValueBuilder`:
/// To create a `FutureValueBuilder`:
/// ```dart
/// StreamValueBuilder(
///   stream: Stream.fromIterable(['Hello', 'World']),
///   builder: (context, snapshot, child) => switch (snapshot) {
///     ValueSnapshot(:final value) => Text(value), // 'Hello', 'World'
///     ErrorSnapshot(:final error) => Text('Error: $error'),
///     EmptySnapshot _ => CircularProgressIndicator(),
///   },
/// )
///
/// You can also set an initial value:
/// ```dart
/// StreamValueBuilder.value(
///   stream: Stream.fromIterable(['Hello', 'World']),
///   initial: 'Initial',
///   builder: (context, snapshot, child) => switch (snapshot) {
///     ValueSnapshot(:final value) => Text(value), // 'Initial', 'Hello', 'World'
///     ErrorSnapshot(:final error) => Text('Error: $error'),
///     EmptySnapshot _ => CircularProgressIndicator(),
///   },
/// )
/// ```
///
/// The [builder] function also accepts a [child] widget that is independent of the asynchronous computation:
/// ```dart
/// StreamValueBuilder(
///   stream: Stream.fromIterable(['Hello', 'World']),
///   builder: (context, snapshot, child) => switch (snapshot) {
///     ValueSnapshot(:final value) => Row(children: [
///       Text(value),
///       child!,
///     ]),
///     ErrorSnapshot(:final error) =>
///     EmptySnapshot _ => CircularProgressIndicator(),
///   },
///   child: Text('child widget'),
/// )
/// ```
final class StreamValueBuilder<T> extends StatefulWidget {

  /// The asynchronous computation to which this builder is currently connected.
  final Stream<T>? stream;

  /// The build strategy currently used by this builder.
  final AsyncValueBuilder<T> builder;

  /// A [stream]-independent widget which is passed back to the [builder].
  ///
  /// This argument is optional and can be null if the entire widget subtree the [builder] builds depends on the value
  /// of the [stream]. For example, in the case where the [stream] returns a [String] and the [builder] returns a [Text] widget
  /// with the current [String] value, there would be no useful [child].
  final Widget? child;

  final (T,)? _initial;

  /// Creates a [StreamValueBuilder] with no initial value.
  const StreamValueBuilder({required this.stream, required this.builder, this.child, super.key}): _initial = null;

  /// Creates a [StreamValueBuilder] with an initial value.
  const StreamValueBuilder.value({required this.stream, required T initial, required this.builder, this.child, super.key}):
    _initial = (initial,);

  @override
  State<StreamValueBuilder<T>> createState() => _StreamValueBuilderState();
}

/// This implementation is ported from [StreamBuilderBase].
class _StreamValueBuilderState<T> extends State<StreamValueBuilder<T>> {
  StreamSubscription<T>? _subscription; // ignore: cancel_subscriptions
  late Snapshot<T> _snapshot;

  @override
  void initState() {
    super.initState();
    final initial = widget._initial;
    _snapshot = initial == null ? EmptySnapshot(ConnectionState.none) : ValueSnapshot(ConnectionState.none, initial.$1);
    _subscribe();
  }

  @override
  void didUpdateWidget(StreamValueBuilder<T> old) {
    super.didUpdateWidget(old);
    if (old.stream != widget.stream) {
      if (_subscription != null) {
        _unsubscribe();
        _snapshot = _snapshot.transition(to: ConnectionState.none);
      }
      _subscribe();
    }
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _snapshot, widget.child);

  void _subscribe() {
    if (widget.stream case final stream when stream != null) {
      _subscription = stream.listen((value) {
        setState(() {
          _snapshot = ValueSnapshot(ConnectionState.active, value);
        });
      }, onError: (error, stackTrace) {
        setState(() {
          _snapshot = ErrorSnapshot(ConnectionState.active, error, stackTrace);
        });
      }, onDone: () {
        setState(() {
          _snapshot = _snapshot.transition(to: ConnectionState.done);
        });
      });

      _snapshot = _snapshot.transition(to: ConnectionState.waiting);
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
