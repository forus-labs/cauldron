part of 'future_builder.dart';

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
final class FutureResultBuilder<S extends Object, F extends Object> extends _FutureResultBuilder<S, F> {
  /// Creates an [FutureResultBuilder] with no initial value.
  const FutureResultBuilder({
    required super.future,
    required super.builder,
    super.failureBuilder,
    super.emptyBuilder,
    super.child,
    super.key,
  }): super();

  /// Creates an [FutureResultBuilder] with an initial value.
  const FutureResultBuilder.value({
    required super.future,
    required super.initial,
    required super.builder,
    super.failureBuilder,
    super.child,
    super.key,
  }): super.value();

  @override
  FutureResultBuilderState<S, F> createState() => FutureResultBuilderState();
}

/// A [FutureResultBuilder]'s state.
final class FutureResultBuilderState<S extends Object, F extends Object> extends _FutureResultBuilderState<S, F> {
  @override
  void _subscribe(Future<Result<S, F>> future, Object callbackIdentity) {
    future.then<void>((value) {
      if (_activeCallbackIdentity == callbackIdentity) {
        setState(() => _snapshot = value);
      }
    });
  }
}
