part of 'future_builder.dart';

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
/// ```
///
/// ## Working with `FutureValueBuilder`:
/// To create a `FutureValueBuilder`:
/// ```dart
/// FutureValueBuilder(
///   future: () => computeAsync(),
///   builder: (context, value, child) => Text(value),
///   errorBuilder: (context, error, child) => Text('Error: $error'), // optional
///   emptyBuilder: (context, future, child) => CircularProgressIndicator(), // optional
/// )
/// ```
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
/// [builder], [errorBuilder] and [emptyBuilder] also accept a [child] widget that is independent of the asynchronous computation.
/// You should use it to provide child widgets that don't depend on the [future]'s result.
///
/// ```dart
/// FutureValueBuilder(
///   future: () => computeAsync(),
///   builder: (context, value, child) => Row(children: [
///     Text(value),
///     child!,
///   ]),
///   child: Text('child widget'),
/// )
/// ```
final class FutureValueBuilder<T> extends _FutureValueBuilder<T> {
  /// Creates an [FutureValueBuilder] with no initial value.
  const FutureValueBuilder({
    required super.future,
    required super.builder,
    super.errorBuilder,
    super.emptyBuilder,
    super.child,
    super.key,
  }): super();

  /// Creates an [FutureValueBuilder] with an initial value.
  const FutureValueBuilder.value({
    required super.future,
    required super.initial,
    required super.builder,
    super.errorBuilder,
    super.child,
    super.key,
  }): super.value();

  @override
  FutureValueBuilderState<T> createState() => FutureValueBuilderState<T>();
}

/// A [FutureValueBuilder]'s state.
final class FutureValueBuilderState<T> extends _FutureValueBuilderState<T> {
  @override
  void _subscribe(Future<T> future, Object callbackIdentity) {
    future.then<void>((value) {
      if (_activeCallbackIdentity == callbackIdentity) {
        setState(() => _snapshot = _wrap(value));
      }
    }, onError: (error, stackTrace) {
      if (_activeCallbackIdentity == callbackIdentity) {
        setState(() => _snapshot = (error, stackTrace));
      }
    });
  }
}
