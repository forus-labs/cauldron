part of 'future_value_builder_base.dart';

/// A widget that builds itself based on the latest snapshot of interaction with a [Future].
///
/// A [FutureValueBuilder] is an alternative to the in-built [FutureBuilder]. It contains numerous improvements over the
/// in-built [FutureBuilder]:
/// * Easy differentiation between a "nullable value" and "no value yet"
/// * Ability to pass a child to the builder function
/// * No implicit conversion of a non-nullable [T] to [T?]
///
/// ## Managing the future
/// Similar to [FutureBuilder], the [future] must be obtained earlier, i.e. during [State.initState]. It must not be created
/// during [State.build] or [StatelessWidget.build] when creating the [FutureValueBuilder]. If the [future] is created at
/// the same time as the [FutureValueBuilder], then every time the [FutureValueBuilder]'s parent is rebuilt, the asynchronous
/// task will be restarted.
///
/// See [MemoizedFutureValueBuilder] for a [FutureValueBuilder] that memoizes its [future].
///
/// ## Working with `FutureValueBuilder`:
/// To create a `FutureValueBuilder`:
/// ```dart
/// FutureValueBuilder(
///   future: fetchCachedValue(),
///   builder: (context, snapshot, child) => switch (snapshot) {
///     ValueSnapshot(:final value) => Text(value),
///     ErrorSnapshot(:final error) => Text('Error: $error'),
///     EmptySnapshot _ => CircularProgressIndicator(),
///   },
/// )
///
/// You can also set an initial value:
/// ```dart
/// FutureValueBuilder.value(
///   future: fetchCachedValue(),
///   initial: 'Initial',
///   builder: (context, snapshot, child) => switch (snapshot) {
///     ValueSnapshot(:final value) => Text(value),  // 'Initial' then fetchCachedValue()
///     ErrorSnapshot(:final error) => Text('Error: $error'),
///     EmptySnapshot _ => CircularProgressIndicator(),
///   },
/// )
/// ```
///
/// The [builder] function also accepts a [child] widget that is independent of the asynchronous computation:
/// ```dart
/// FutureValueBuilder(
///   future: fetchCachedValue(),
///   builder: (context, snapshot, child) => switch (snapshot) {
///     ValueSnapshot(:final value) => Row(children: [
///       Text(value),
///       child!,
///     ]),
///     ErrorSnapshot(:final error) => Text('Error: $error'),
///     EmptySnapshot _ => CircularProgressIndicator(),
///   },
///   child: Text('child widget'),
/// )
/// ```
final class FutureValueBuilder<T> extends FutureValueBuilderBase<T> {
  /// The asynchronous computation to which this builder is currently connected.
  final Future<T>? future;

  /// Creates an [FutureValueBuilder] with no initial value.
  const FutureValueBuilder({
    required this.future,
    required super.builder,
    super.child,
    super.key,
  });

  /// Creates an [FutureValueBuilder] with an initial value.
  const FutureValueBuilder.value({
    required this.future,
    required super.initial,
    required super.builder,
    super.child,
    super.key,
  }): super.value();

  @override
  State<FutureValueBuilder<T>> createState() => _FutureValueBuilderState<T>();
}

final class _FutureValueBuilderState<T> extends FutureValueBuilderBaseState<T, FutureValueBuilder<T>> {
  @override
  void didUpdateWidget(FutureValueBuilder<T> old) {
    super.didUpdateWidget(old);
    if (old.future != widget.future) {
      if (_activeCallbackIdentity != null) {
        _activeCallbackIdentity = null;
        _snapshot = _snapshot.transition(to: ConnectionState.none);
      }
      _subscribe();
    }
  }

  @override
  Future<T>? get future => widget.future;
}
