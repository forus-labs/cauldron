import 'package:flutter/material.dart';
import 'package:sugar/core.dart';

part 'future_result_builder.dart';
part 'future_result_dialog.dart';
part 'future_value_builder.dart';
part 'future_value_dialog.dart';

/// The base implementation for all builders that rely on a asynchronous computation that returns a [Future].
///
/// When creating a new [FutureBuilder], you should prefer either the [_FutureValueBuilder] or [_FutureResultBuilder]
/// subclasses.
abstract base class _FutureBuilder<T, U> extends StatefulWidget {

  static Widget defaultBuilder(BuildContext context, Object? value, Widget? child) => const SizedBox();

  /// A function that starts an asynchronous computation to which this builder is currently connected.
  final Future<T>? Function(BuildContext) future;

  /// The build strategy currently used by this builder when no error or [T] is available.
  ///
  /// Always returns an empty [SizedBox] by default.
  ///
  /// This builder must only return a widget and should not have any side effects as it may be called multiple times.
  final ValueWidgetBuilder<Future<T>?> emptyBuilder;

  /// A future-independent widget which is passed back to the builders.
  ///
  /// This argument is optional and can be null if the entire widget subtree the builders build depends on the value
  /// of the future. For example, in the case where the future is a [String] and the builders return a [Text] widget
  /// with the current [String] value, there would be no useful [child].
  final Widget? child;

  final (U,)? _initial;

  const _FutureBuilder({
    required this.future,
    this.emptyBuilder = defaultBuilder,
    this.child,
    super.key,
  }): _initial = null;

  const _FutureBuilder.value({
    required this.future,
    required U initial,
    this.child,
    super.key,
  }): emptyBuilder = defaultBuilder, _initial = (initial,);

}

/// The base state for all builders that rely on a asynchronous computation that returns a [Future].
///
/// When creating a new [FutureBuilder], you should prefer either the [_FutureValueBuilderState] or [_FutureResultBuilderState]
/// subclasses.
abstract base class _FutureBuilderState<Wrapped, Snapshot, Value, Builder extends _FutureBuilder<Wrapped, Value>> extends State<Builder> {
  /// An object that identifies the currently active callbacks. Used to avoid
  /// calling setState from stale callbacks, e.g. after disposal of this state,
  /// or after widget reconfiguration to a new Future.
  Object? _activeCallbackIdentity;
  Future<Wrapped>? _future;
  Snapshot? _snapshot;

  @override
  void initState() {
    super.initState();

    _future = widget.future(context);
    if (widget._initial case (final initial,)) {
      _snapshot = _wrap(initial);
    }

    if (_future case final future when future != null) {
      final callbackIdentity = Object();
      _activeCallbackIdentity = callbackIdentity;
      _subscribe(future, callbackIdentity);
    }
  }

  @override
  void didUpdateWidget(Builder old) {
    super.didUpdateWidget(old);
    if (old.future == widget.future) {
      return;
    }

    _future = widget.future(context);
    _activeCallbackIdentity = null;

    if (_future case final future when future != null) {
      final callbackIdentity = Object();
      _activeCallbackIdentity = callbackIdentity;
      _subscribe(future, callbackIdentity);
    }
  }

  Snapshot _wrap(Value initial);

  void _subscribe(Future<Wrapped> future, Object callbackIdentity);


  @override
  void dispose() {
    _activeCallbackIdentity = null;
    super.dispose();
  }

}


abstract base class _FutureValueBuilder<T> extends _FutureBuilder<T, T> {

  /// The build strategy currently used by this builder when an initial value or value produced by [future] is available.
  ///
  /// Always returns an empty [SizedBox] by default.
  ///
  /// This builder must only return a widget and should not have any side effects as it may be called multiple times.
  final ValueWidgetBuilder<T> builder;

  /// The build strategy currently used by this builder when [future] produces an error.
  ///
  /// Always returns an empty [SizedBox] by default.
  ///
  /// This builder must only return a widget and should not have any side effects as it may be called multiple times.
  final ValueWidgetBuilder<(Object error, StackTrace stackTrace)> errorBuilder;

  const _FutureValueBuilder({
    required super.future,
    required this.builder,
    this.errorBuilder = _FutureBuilder.defaultBuilder,
    super.emptyBuilder,
    super.child,
    super.key,
  }): super();

  const _FutureValueBuilder.value({
    required super.future,
    required super.initial,
    required this.builder,
    this.errorBuilder = _FutureBuilder.defaultBuilder,
    super.child,
    super.key,
  }): super.value();

}

abstract base class _FutureValueBuilderState<T> extends _FutureBuilderState<T, Object, T, _FutureValueBuilder<T>> {

  // [T] is wrapped in a record to differentiate between void and null when [T] is nullable.
  @override
  (T,) _wrap(T initial) => (initial,);

  @override
  Widget build(BuildContext context) => switch (_snapshot) {
    (final T value,) => widget.builder(context, value, widget.child),
    (final Object error, final StackTrace trace) => widget.errorBuilder(context, (error, trace), widget.child),
    _ => widget.emptyBuilder(context, _future, widget.child),
  };

}


abstract base class _FutureResultBuilder<S extends Object, F extends Object> extends _FutureBuilder<Result<S, F>, S> {

  /// The build strategy currently used by this builder when an initial value or [Success] produced by [future] is available.
  ///
  /// Always returns an empty [SizedBox] by default.
  ///
  /// This builder must only return a widget and should not have any side effects as it may be called multiple times.
  final ValueWidgetBuilder<S> builder;

  /// The build strategy currently used by this builder when [future] returns a [Failure].
  ///
  /// Always returns an empty [SizedBox] by default.
  ///
  /// This builder must only return a widget and should not have any side effects as it may be called multiple times.
  final ValueWidgetBuilder<F> failureBuilder;

  const _FutureResultBuilder({
    required super.future,
    required this.builder,
    this.failureBuilder = _FutureBuilder.defaultBuilder,
    super.emptyBuilder,
    super.child,
    super.key,
  }): super();

  const _FutureResultBuilder.value({
    required super.future,
    required super.initial,
    required this.builder,
    this.failureBuilder = _FutureBuilder.defaultBuilder,
    super.child,
    super.key,
  }): super.value();

}

abstract base class _FutureResultBuilderState<S extends Object, F extends Object> extends _FutureBuilderState<Result<S, F>, Result<S, F>, S, _FutureResultBuilder<S, F>> {

  @override
  Result<S, F> _wrap(S initial) => Success(initial);

  @override
  Widget build(BuildContext context) => switch (_snapshot) {
    Success(:final S success) => widget.builder(context, success, widget.child),
    Failure(:final F failure) =>  widget.failureBuilder(context, failure, widget.child),
    null => widget.emptyBuilder(context, _future, widget.child),
  };

}
