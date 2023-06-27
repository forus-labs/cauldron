import 'package:flutter/widgets.dart';
import 'package:sugar/sugar.dart';

/// A [FutureBuilder] that memoizes a given [Future].
///
/// This prevents the [Future] from being accidentally recomputed each time the widget is rebuilt.
///
/// ## Motivation
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
/// A [MemoizedFutureBuilder] prevents this by memoizing the result of the async computing function in subsequent rebuilds:
/// ```dart
/// class Example extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) => MemoizedFutureBuilder(
///     future: () => computeAsync(), // Computed once when Example is created
///     builder: (_, __) => Container(),
///   );
/// }
/// ```
class MemoizedFutureBuilder<T> extends StatefulWidget {
  /// The memoized [Future].
  final Supply<Future<T>> future;
  /// The builder.
  final AsyncWidgetBuilder<T> builder;
  /// The initial data which is returned until the [future] has completed.
  final T? initialData;

  /// Creates a [MemoizedFutureBuilder].
  const MemoizedFutureBuilder({
    required this.future,
    required this.builder,
    this.initialData,
    super.key,
  });

  @override
  State<MemoizedFutureBuilder<T>> createState() => _MemoizedFutureBuilderState();
}

class _MemoizedFutureBuilderState<T> extends State<MemoizedFutureBuilder<T>> {
  late Future<T> future;

  @override
  void initState() {
    super.initState();
    future = widget.future();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
    future: future,
    builder: widget.builder,
    initialData: widget.initialData,
    key: widget.key,
  );
}
