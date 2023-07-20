import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:stevia/widgets.dart';

part 'future_value_builder.dart';
part 'memoized_future_value_builder.dart';

/// A widget that builds itself based on the latest snapshot of interaction with a [Future].
///
/// A [FutureValueBuilderBase] is an alternative to the in-built [FutureBuilder]. It contains numerous improvements over the
/// in-built [FutureBuilder]:
///
/// * Easy differentiation between a "nullable value" and "no value yet"
/// * Ability to pass a child to the builder function
/// * No implicit conversion of a non-nullable [T] to [T?]
@internal abstract base class FutureValueBuilderBase<T> extends StatefulWidget {

  /// The build strategy currently used by this builder.
  ///
  /// The builder is provided with a [Snapshot] whose[Snapshot.state] property will be one of the following values:
  ///
  ///  * [ConnectionState.none]: future is null. It is a [ValueSnapshot] if a initial value is provided and there was
  ///    no previously completed future.
  ///
  ///  * [ConnectionState.waiting]: future is not null, but has not yet completed. It is a [ValueSnapshot] if a initial
  ///    value is provided and there was no previously completed future.
  ///
  ///  * [ConnectionState.done]: future is not null, and has completed. If the future completed successfully, it is a
  ///    [ValueSnapshot]. If it completed with an error, it is a [ErrorSnapshot].
  ///
  /// This builder must only return a widget and should not have any side effects as it may be called multiple times.
  final AsyncValueBuilder<T> builder;

  /// A future-independent widget which is passed back to the [builder].
  ///
  /// This argument is optional and can be null if the entire widget subtree the [builder] builds depends on the value
  /// of the future. For example, in the case where the future is a [String] and the [builder] returns a [Text] widget
  /// with the current [String] value, there would be no useful [child].
  final Widget? child;

  final (T,)? _initial;

  /// Creates an [FutureValueBuilder] with no initial value.
  const FutureValueBuilderBase({
    required this.builder,
    this.child,
    super.key,
  }): _initial = null;

  /// Creates an [FutureValueBuilder] with an initial value.
  const FutureValueBuilderBase.value({
    required T initial,
    required this.builder,
    this.child,
    super.key,
  }): _initial = (initial,);
}

/// This implementation is ported from [FutureBuilder].
@internal abstract base class FutureValueBuilderBaseState<T, W extends FutureValueBuilderBase<T>> extends State<W> {
  /// An object that identifies the currently active callbacks. Used to avoid
  /// calling setState from stale callbacks, e.g. after disposal of this state,
  /// or after widget reconfiguration to a new Future.
  Object? _activeCallbackIdentity;
  late Snapshot<T> _snapshot;

  @override
  void initState() {
    super.initState();
    if (widget._initial case (final initial,)) {
      _snapshot = ValueSnapshot(ConnectionState.none, initial);
    } else {
      _snapshot = EmptySnapshot(ConnectionState.none);
    }
    _subscribe();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _snapshot, widget.child);

  void _subscribe() {
    if (future case final future when future != null) {
      final callbackIdentity = Object();
      _activeCallbackIdentity = callbackIdentity;

      future.then<void>((value) {
        if (_activeCallbackIdentity == callbackIdentity) {
          setState(() => _snapshot = ValueSnapshot(ConnectionState.done, value));
        }
      }, onError: (error, stackTrace) {
        if (_activeCallbackIdentity == callbackIdentity) {
          setState(() => _snapshot = ErrorSnapshot(ConnectionState.done, error, stackTrace));
        }
      });

      // An implementation like `SynchronousFuture` may have already called the
      // .then closure. Do not overwrite it in that case.
      if (_snapshot.state != ConnectionState.done) {
        _snapshot = _snapshot.transition(to: ConnectionState.waiting);
      }
    }
  }

  /// The asynchronous computation to which this builder is currently connected.
  Future<T>? get future;

  @override
  void dispose() {
    _activeCallbackIdentity = null;
    super.dispose();
  }
}
