part of 'future_builder.dart';

/// Shows a dialog that relies on an asynchronous computation.
///
/// A non-dismissible [ModalBarrier] that contains the dialog returned by [emptyBuilder] is shown until the [future] has
/// completed.
///
/// After the [future] has completed:
/// * If [future] completes successfully and a [builder] is given, the dialog returned by [builder] is shown.
/// * If [future] completes with an error and a [errorBuilder] is given, the dialog returned by [errorBuilder] is shown.
/// * It otherwise automatically dismisses the [ModalBarrier].
///
/// The result of the given [future] is always returned.
///
/// Internally, this function relies on [showAdaptiveDialog].
///
/// ## Working with [showFutureValueDialog]:
///
/// To show a dialog that is automatically dismissed after the [future] is completed:
/// ```dart
/// FloatingActionButton(
///   onPressed: () => showFutureValueDialog(
///     context: context,
///     future: () async {
///       await Future.delayed(const Duration(seconds: 5));
///       return '';
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
///   onPressed: () => showFutureValueDialog(
///     context: context,
///     future: () async {
///       await Future.delayed(const Duration(seconds: 5);
///       return '';
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
///     future: () async {
///       await Future.delayed(const Duration(seconds: 5);
///       throw StateError('Error')
///     },
///     errorBuilder: (context, _, __) => FloatingActionButton(
///       onPressed: () => Navigator.of(context).pop(),
///       child: Text('Dismiss'),
///     ),
///     emptyBuilder: (context, _, __) => const Text('Please wait 5s'),
///   ),
///   child: const Text('Has error dialog'),
/// );
/// ```
Future<T> showFutureValueDialog<T>({
  required BuildContext context,
  required Future<T> Function() future,
  ValueWidgetBuilder<T>? builder,
  ValueWidgetBuilder<(Object error, StackTrace stackTrace)>? errorBuilder,
  ValueWidgetBuilder<Future<T>?>? emptyBuilder,
  Widget? child,
}) async {
  final result = future();
  await showAdaptiveDialog(
    context: context,
    useRootNavigator: false,
    barrierDismissible: false,
    builder: (context) => FutureValueDialog._(
      future: (_) => result,
      builder: builder ?? _FutureBuilder.defaultBuilder,
      errorBuilder: errorBuilder ?? _FutureBuilder.defaultBuilder,
      emptyBuilder: (context, future, child) => WillPopScope(
        onWillPop: () async => false,
        child: emptyBuilder?.call(context, future!, child) ?? const SizedBox(),
      ),
      child: child,
    ),
  );

  return result;
}


/// A [FutureValueDialog]. See [showFutureValueDialog] for more details.
final class FutureValueDialog<T> extends _FutureValueBuilder<T> {
  const FutureValueDialog._({
    required super.future,
    required super.builder,
    super.errorBuilder,
    super.emptyBuilder,
    super.child,
  });

  @override
  FutureValueDialogState<T> createState() => FutureValueDialogState<T>();
}

/// A [FutureValueDialog]'s state.
final class FutureValueDialogState<T> extends _FutureValueBuilderState<T> {
  @override
  void _subscribe(Future<T> future, Object callbackIdentity) {
    future.then<void>((value) {
      if (_activeCallbackIdentity != callbackIdentity) {
        return;
      }

      if (widget.builder == _FutureBuilder.defaultBuilder) {
        Navigator.of(context).pop();

      } else {
        setState(() => _snapshot = _wrap(value));
      }

    }, onError: (error, trace) {
      if (_activeCallbackIdentity != callbackIdentity) {
        return;
      }

      if (widget.errorBuilder == _FutureBuilder.defaultBuilder) {
        Navigator.of(context).pop();

      } else {
        setState(() => _snapshot = (error, trace));
      }
    });
  }
}
