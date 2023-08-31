import 'package:flutter/material.dart';
import 'package:sugar/core.dart';

part 'future_result_builder.dart';
part 'future_value_builder.dart';

abstract base class _FutureBuilderBase<T, U> extends StatefulWidget {

  /// A function that starts an asynchronous computation to which this builder is currently connected.
  final Future<T>? Function(BuildContext) future;

  /// The build strategy currently used by this builder when no error or [T] is available.
  ///
  /// This builder must only return a widget and should not have any side effects as it may be called multiple times.
  final ValueWidgetBuilder<Future<T>?>? emptyBuilder;

  /// A future-independent widget which is passed back to the builders.
  ///
  /// This argument is optional and can be null if the entire widget subtree the builders build depends on the value
  /// of the future. For example, in the case where the future is a [String] and the builders return a [Text] widget
  /// with the current [String] value, there would be no useful [child].
  final Widget? child;

  final (U,)? _initial;

  const _FutureBuilderBase({
    required this.future,
    this.emptyBuilder,
    this.child,
    super.key,
  }): _initial = null;

  const _FutureBuilderBase.value({
    required this.future,
    required U initial,
    this.child,
    super.key,
  }): emptyBuilder = null, _initial = (initial,);

}

abstract base class _FutureBuilderBaseState<Builder extends _FutureBuilderBase<T, U>, T, U> extends State<Builder> {
  /// An object that identifies the currently active callbacks. Used to avoid
  /// calling setState from stale callbacks, e.g. after disposal of this state,
  /// or after widget reconfiguration to a new Future.
  Object? _activeCallbackIdentity;
  Future<T>? _future;
  Object? _snapshot;

  @override
  void didUpdateWidget(covariant Builder old) {
    super.didUpdateWidget(old);
    if (old.future == widget.future) {
      return;
    }

    _future = widget.future(context);
    _activeCallbackIdentity = null;
    _subscribe();
  }

  void _subscribe();

  @override
  void dispose() {
    _activeCallbackIdentity = null;
    super.dispose();
  }
}
