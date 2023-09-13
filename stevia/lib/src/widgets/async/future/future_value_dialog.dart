part of 'future_builder_base.dart';

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
      builder: builder,
      errorBuilder: errorBuilder,
      emptyBuilder: emptyBuilder,
      child: child,
    ),
  );

  return result;
}


/// A [FutureValueDialog]. See [showFutureValueDialog] for more details.
final class FutureValueDialog<T> extends _FutureBuilderBase<T, T> {

  /// The build strategy currently used by this builder when an initial value or value produced by [future] is available.
  ///
  /// This builder must only return a widget and should not have any side effects as it may be called multiple times.
  final ValueWidgetBuilder<T>? builder;
  /// The build strategy currently used by this builder when [future] produces an error.
  ///
  /// This builder must only return a widget and should not have any side effects as it may be called multiple times.
  final ValueWidgetBuilder<(Object error, StackTrace stackTrace)>? errorBuilder;

  const FutureValueDialog._({
    required super.future,
    this.builder,
    this.errorBuilder,
    super.emptyBuilder,
    super.child,
  });

  @override
  State<FutureValueDialog<T>> createState() => _FutureValueDialogState<T>();

}

final class _FutureValueDialogState<T> extends _FutureBuilderBaseState<FutureValueDialog<T>, T, T> {

  @override
  Object _wrap(T initial) => (initial,);

  @override
  void _subscribe(Future<T> future, Object callbackIdentity) {
    future.then<void>((value) {
      if (_activeCallbackIdentity != callbackIdentity) {
        return;
      }

      if (widget.builder != null) {
        setState(() => _snapshot = (value,));

      } else {
        Navigator.of(context).pop();
      }

    }, onError: (error, stackTrace) {
      if (_activeCallbackIdentity != callbackIdentity) {
        return;
      }

      if (widget.builder != null) {
        setState(() => _snapshot = (error, stackTrace));

      } else {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) => switch (_snapshot) {
    (final T value,) => widget.builder?.call(context, value, widget.child) ?? const SizedBox(),
    (final Object error, final StackTrace trace) => widget.errorBuilder?.call(context, (error, trace), widget.child) ?? const SizedBox(),
    _ => widget.emptyBuilder?.call(context, _future, widget.child) ?? const SizedBox(),
  };

}
