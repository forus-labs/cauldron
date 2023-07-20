part of 'future_value_builder_base.dart';

/// A [FutureValueBuilder] that memoizes a given [Future].
///
/// This prevents the [Future] from being accidentally recomputed each time the widget is rebuilt.
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
/// A [MemoizedFutureValueBuilder] prevents this by memoizing the result of the async computing function in subsequent rebuilds:
/// ```dart
/// class Example extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) => MemoizedFutureValueBuilder(
///     future: () => computeAsync(), // Computed once when Example is created
///     builder: (_, __) => Container(),
///   );
/// }
/// 
/// ## Working with `MemoizedFutureValueBuilder`:
/// To create a `MemoizedFutureValueBuilder`:
/// ```dart
/// MemoizedFutureValueBuilder(
///   future: () => computeAsync(),
///   builder: (context, snapshot, child) => switch (snapshot) {
///     ValueSnapshot(:final value) => Text(value),
///     ErrorSnapshot(:final error) => Text('Error: $error'),
///     EmptySnapshot _ => CircularProgressIndicator(),
///   },
/// )
///
/// You can also set an initial value:
/// ```dart
/// MemoizedFutureValueBuilder.value(
///   future: () => computeAsync(),
///   initial: 'Initial',
///   builder: (context, snapshot, child) => switch (snapshot) {
///     ValueSnapshot(:final value) => Text(value),  // 'Initial' then computeAsync()
///     ErrorSnapshot(:final error) => Text('Error: $error'),
///     EmptySnapshot _ => CircularProgressIndicator(),
///   },
/// )
/// ```
///
/// The [builder] function also accepts a [child] widget that is independent of the asynchronous computation:
/// ```dart
/// MemoizedFutureValueBuilder(
///   future: () => computeAsync(),,
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
///
/// You should use it to provide child widgets that don't depend on the `future`'s result.
final class MemoizedFutureValueBuilder<T> extends FutureValueBuilderBase<T> {
  /// A function that starts an asynchronous computation to which this builder is currently connected.
  final Future<T>? Function() future;

  /// Creates an [MemoizedFutureValueBuilder] with no initial value.
  const MemoizedFutureValueBuilder({
    required this.future,
    required super.builder,
    super.child,
    super.key,
  });

  /// Creates an [MemoizedFutureValueBuilder] with an initial value.
  const MemoizedFutureValueBuilder.value({
    required this.future,
    required super.initial,
    required super.builder,
    super.child,
    super.key,
  }): super.value();

  @override
  State<MemoizedFutureValueBuilder<T>> createState() => _MemoizedFutureValueBuilderState<T>();
}

final class _MemoizedFutureValueBuilderState<T> extends FutureValueBuilderBaseState<T, MemoizedFutureValueBuilder<T>> {
  @override
  late Future<T>? future;

  @override
  void initState() {
    future = widget.future();
    super.initState(); // We need to initialize everything else AFTER initializing the future.
  }
}
