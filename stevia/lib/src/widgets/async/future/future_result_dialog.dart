part of 'future_builder.dart';

/// A specialized [showFutureValueDialog] that shows a dialog that relies on an asynchronous computation which returns a
/// [Result].
///
/// A non-dismissible [ModalBarrier] that contains the dialog returned by [emptyBuilder] is shown until the [future] has
/// completed.
///
/// After the [future] has completed:
/// * If [future] returns [Success] and a [builder] is given, the dialog returned by [builder] is shown.
/// * If [future] returns [Failure] and a [failureBuilder] is given, the dialog returned by [failureBuilder] is shown.
/// * It otherwise automatically dismisses the [ModalBarrier].
///
/// The result of the given [future] is always returned. It is assumed that [future] will never throw an error. Doing so
/// will result in undefined behaviour.
///
/// ## Working with [showsFutureResultDialog]:
///
/// To show a dialog that is automatically dismissed after the [future] is completed:
/// ```dart
/// FloatingActionButton(
///   onPressed: () => showsFutureResultDialog(
///     context: context,
///     future: () async {
///       await Future.delayed(const Duration(seconds: 5));
///       return const Success('');
///     },
///     emptyBuilder: (context, _, __) => const Text('This text will disappear after 5s.'),
///   ),
///   child: const Text('No dialog'),
/// );
/// ```
///
/// To show a dialog that appears after the [future] has successfully completed:
/// ```dart
/// FloatingActionButton(
///   onPressed: () => showsFutureResultDialog(
///     context: context,
///     future: () async {
///       await Future.delayed(const Duration(seconds: 5);
///       return const Success('');
///     },
///     builder: (context, _, __) => FloatingActionButton(
///       onPressed: () => Navigator.of(context).pop(),
///       child: Text('Dismiss'),
///     ),
///     emptyBuilder: (context, _, __) => const Text('Please wait 5s'),
///   ),
///   child: const Text('Has value dialog'),
/// );
/// ```
///
/// To show a dialog that appears after the [future] has completed with an error:
/// ```dart
/// FloatingActionButton(
///   onPressed: () => showFutureValueDialog(
///     context: context,
///     future: (context) async {
///       await Future.delayed(const Duration(seconds: 5);
///       return const Failure('');
///     },
///     failureBuilder: (context, _, __) => FloatingActionButton(
///       onPressed: () => Navigator.of(context).pop(),
///       child: Text('Dismiss'),
///     ),
///     emptyBuilder: (context, _, __) => const Text('Please wait 5s'),
///   ),
///   child: const Text('Has error dialog'),
/// );
/// ```
Future<Result<S, F>> showFutureResultDialog<S extends Object, F extends Object>({
  required BuildContext context,
  required Future<Result<S, F>> Function() future,
  ValueWidgetBuilder<S>? builder,
  ValueWidgetBuilder<F>? failureBuilder,
  ValueWidgetBuilder<Future<Result<S, F>>?>? emptyBuilder,
  Widget? child,
}) async {
  final result = future();
  await showAdaptiveDialog(
    context: context,
    useRootNavigator: false,
    barrierDismissible: false,
    builder: (context) => FutureResultDialog._(
      future: (_) => result,
      builder: builder ?? _FutureBuilder.defaultBuilder,
      failureBuilder: failureBuilder ?? _FutureBuilder.defaultBuilder,
      emptyBuilder: (context, future, child) => WillPopScope(
        onWillPop: () async => false,
        child: emptyBuilder?.call(context, future, child) ?? const SizedBox(),
      ),
      child: child,
    ),
  );

  return result;
}


/// A [FutureResultDialog]. See [showFutureValueDialog] for more details.
final class FutureResultDialog<S extends Object, F extends Object> extends _FutureResultBuilder<S, F> {
  const FutureResultDialog._({
    required super.future,
    required super.builder,
    super.failureBuilder,
    super.emptyBuilder,
    super.child,
  });

  @override
  FutureResultDialogState<S, F> createState() => FutureResultDialogState<S, F>();
}

/// A [FutureResultDialog]'s state.
final class FutureResultDialogState<S extends Object, F extends Object> extends _FutureResultBuilderState<S, F> {
  @override
  void _subscribe(Future<Result<S, F>> future, Object callbackIdentity) {
    future.then<void>((value) {
      if (_activeCallbackIdentity != callbackIdentity) {
        return;
      }

      switch (value) {
        case Success _ when widget.builder == _FutureBuilder.defaultBuilder: Navigator.of(context).pop();
        case Failure _ when widget.failureBuilder == _FutureBuilder.defaultBuilder: Navigator.of(context).pop();
        default: setState(() => _snapshot = value);
      }
    });
  }
}
