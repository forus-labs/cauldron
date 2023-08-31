part of 'future_builder_base.dart';

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
final class FutureValueBuilder<T> extends _FutureBuilderBase<T, T> {

  /// The build strategy currently used by this builder when an initial value or value produced by [future] is available.
  ///
  /// This builder must only return a widget and should not have any side effects as it may be called multiple times.
  final ValueWidgetBuilder<T> builder;

  /// The build strategy currently used by this builder when [future] produces an error.
  ///
  /// This builder must only return a widget and should not have any side effects as it may be called multiple times.
  final ValueWidgetBuilder<(Object error, StackTrace stackTrace)>? errorBuilder;

  /// Creates an [FutureValueBuilder] with no initial value.
  const FutureValueBuilder({
    required super.future,
    required this.builder,
    this.errorBuilder,
    super.emptyBuilder,
    super.child,
    super.key,
  }): super();

  /// Creates an [FutureValueBuilder] with an initial value.
  const FutureValueBuilder.value({
    required super.future,
    required super.initial,
    required this.builder,
    this.errorBuilder,
    super.child,
    super.key,
  }): super.value();

  @override
  State<FutureValueBuilder<T>> createState() => _FutureValueBuilderState();

}

final class _FutureValueBuilderState<T> extends _FutureBuilderBaseState<FutureValueBuilder<T>, T, T> {

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
  Widget build(BuildContext context) => switch (_snapshot) {
    final T value => widget.builder(context, value, widget.child),
    (final Object error, final StackTrace trace) => widget.errorBuilder?.call(context, (error, trace), widget.child) ?? const SizedBox(),
    _ => widget.emptyBuilder?.call(context, _future, widget.child) ?? const SizedBox(),
  };

}
