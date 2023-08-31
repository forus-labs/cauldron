part of 'future_builder_base.dart';

/// A specialized [FutureValueBuilder] that builds itself based on the latest snapshot of interaction with a [Future]
/// which returns a [Result].
///
/// [builder] is called if [future] returns a [Success] while [failureBuilder] is called if [future] returns a  [Failure].
/// It is assumed that [future] will never throw an error. Doing so will result in undefined behaviour.
/// 
/// See [FutureValueBuilder] for more information.
///
/// ## Working with `FutureResultBuilder`:
/// To create a `FutureResultBuilder`:
/// ```dart
/// FutureResultBuilder<String, String>(
///   future: () => computeAsync(),
///   builder: (context, success, child) => Text(value),
///   failureBuilder: (context, failure, child) => Text('Failure: failure'), // optional
///   emptyBuilder: (context, future, child) => CircularProgressIndicator(), // optional
/// )
/// ```
/// 
/// [builder], [failureBuilder] and [emptyBuilder] also accept a [child] widget that is independent of the asynchronous computation.
/// You should use it to provide child widgets that don't depend on the [future]'s result.
/// 
/// ```dart
/// FutureResultBuilder<String, String>(
///   future: () => computeAsync(),
///   builder: (context, value, child) => Row(children: [
/// Text(value),
/// child!,
///   ]),
///   child: Text('child widget'),
/// )
/// ```
/// 
/// You can also set an initial value:
/// ```dart
/// FutureResultBuilder<String, String>.value(
///   future: () => computeAsync(),
///   initial: 'Initial',
///   builder: (context, value, child) => Text(value),
///   failureBuilder: (context, failure, child) => Text('Failure: failure'), // optional
/// )
/// ```
/// ### Warning
/// For some reason, two `FutureResultBuilder`s created via [FutureResultBuilder.value] are not considered equal unless 
/// [S] and [F] are specified. This means the state is re-created instead of updated.
/// 
/// The following test-case will fail:
/// ```dart
/// final key = GlobalKey();
/// await tester.pumpWidget(FutureResultBuilder.value(
///   key: key,
///   future: (_) => null,
///   initial: 'I',
///   builder: valueText,
/// ));
/// expect(find.text('I'), findsOneWidget);
/// 
/// final completer = Completer<Result<String, String>>();
/// await tester.pumpWidget(FutureResultBuilder.value(
///   key: key,
///   future: (_) => completer.future,
///   initial: 'Ignored',
///   builder: valueText,
/// ));
/// 
/// await eventFiring(tester);
/// expect(find.text('Ignored'), findsNothing); // Fails! State is re-created instead of updated
/// expect(find.text('I'), findsOneWidget); // Fails! State is re-created instead of updated
/// 
/// completer.complete(const Success('value'));
/// await eventFiring(tester);
/// expect(find.text('value'), findsOneWidget);
/// ```
final class FutureResultBuilder<S extends Object, F extends Object> extends _FutureBuilderBase<Result<S, F>, S> {

  /// The build strategy currently used by this builder when an initial value or [Success] produced by [future] is available.
  ///
  /// This builder must only return a widget and should not have any side effects as it may be called multiple times.
  final ValueWidgetBuilder<S> builder;

  /// The build strategy currently used by this builder when [future] returns a [Failure].
  ///
  /// This builder must only return a widget and should not have any side effects as it may be called multiple times.
  final ValueWidgetBuilder<F>? failureBuilder;

  /// Creates an [FutureResultBuilder] with no initial value.
  const FutureResultBuilder({
    required super.future,
    required this.builder,
    this.failureBuilder,
    super.emptyBuilder,
    super.child,
    super.key,
  }): super();

  /// Creates an [FutureResultBuilder] with an initial value.
  const FutureResultBuilder.value({
    required super.future,
    required super.initial,
    required this.builder,
    this.failureBuilder,
    super.child,
    super.key,
  }): super.value();

  @override
  State<FutureResultBuilder<S, F>> createState() => _FutureResultBuilderState();

}

final class _FutureResultBuilderState<S extends Object, F extends Object> extends _FutureBuilderBaseState<FutureResultBuilder<S, F>, Result<S, F>, S> {

  @override
  void initState() {
    super.initState();

    _future = widget.future(context);
    if (widget._initial case (final initial,)) {
      _snapshot = Success(initial);
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
      });
    }
  }


  @override
  Widget build(BuildContext context) => switch (_snapshot) {
    Success(:final S success) => widget.builder(context, success, widget.child),
    Failure(:final F failure) =>  widget.failureBuilder?.call(context, failure, widget.child) ?? const SizedBox(),
    null => widget.emptyBuilder?.call(context, _future, widget.child) ?? const SizedBox(),
    final snapshot => throw StateError('Invalid snapshot: $snapshot'),
  };

}
