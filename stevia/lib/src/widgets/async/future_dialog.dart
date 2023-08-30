import 'package:flutter/material.dart';
import 'package:stevia/src/widgets/async/future_value_builder.dart';

/// Shows a dialog that relies on an asynchronous computation.
///
/// A non-dismissible [ModalBarrier] that contains the dialog returned by [emptyBuilder] is shown until the [future] has
/// completed.
///
/// After the [future] has completed:
/// * If [future] completed successfully and a [builder] is given, the dialog returned by [builder] is shown.
/// * If [future] completed with an error and a [errorBuilder] is given, the dialog returned by [errorBuilder] is shown.
/// * It otherwise automatically dismisses the [ModalBarrier].
///
///
/// ## Working with [showFutureDialog]:
///
/// To show a dialog that is automatically dismissed after the [future] is completed.
/// ```dart
/// FloatingActionButton(
///   onPressed: () => showFutureDialog(
///     context: context,
///     future: Future.delayed(const Duration(seconds: 5), () async => ''),
///     emptyBuilder: (context, _, __) => const Text('This barrier will disappear after 5.'),
///   ),
///   child: const Text('No dialog'),
/// ),
/// ```
Future<T> showFutureDialog<T>({
  required BuildContext context,
  required Future<T> future,
  ValueWidgetBuilder<T>? builder,
  ValueWidgetBuilder<(Object error, StackTrace stackTrace)>? errorBuilder,
  ValueWidgetBuilder<Future<T>>? emptyBuilder,
  Widget? child,
}) async {
  await showDialog(
    context: context,
    useRootNavigator: false,
    barrierDismissible: false,
    builder: (context) => FutureDialog(
      future: future,
      builder: builder,
      errorBuilder: errorBuilder,
      emptyBuilder: emptyBuilder,
      child: child,
    ),
  );
  return future;
}

/// A [FutureDialog]. See [showFutureDialog] for more details.
class FutureDialog<T> extends StatelessWidget {

  /// The asynchronous computation.
  final Future<T> future;
  /// The build strategy currently used by this builder when an initial value or value produced by [future] is available.
  ///
  /// This builder must only return a widget and should not have any side effects as it may be called multiple times.
  final ValueWidgetBuilder<T>? builder;
  /// The build strategy currently used by this builder when [future] produces an error.
  ///
  /// This builder must only return a widget and should not have any side effects as it may be called multiple times.
  final ValueWidgetBuilder<(Object error, StackTrace stackTrace)>? errorBuilder;
  /// The build strategy currently used by this builder when no error or [T] is available.
  ///
  /// This builder must only return a widget and should not have any side effects as it may be called multiple times.
  final ValueWidgetBuilder<Future<T>>? emptyBuilder;
  /// A future-independent widget which is passed back to the [builder].
  ///
  /// This argument is optional and can be null if the entire widget subtree the [builder] builds depends on the value
  /// of the future. For example, in the case where the future is a [String] and the [builder] returns a [Text] widget
  /// with the current [String] value, there would be no useful [child].
  final Widget? child;

  /// Creates a [FutureDialog].
  const FutureDialog({
    required this.future,
    this.builder,
    this.errorBuilder,
    this.emptyBuilder,
    this.child,
  });

  @override
  Widget build(BuildContext context) => FutureValueBuilder(
    future: (_) => future,
    builder: builder ?? _defaultBuilder,
    errorBuilder: errorBuilder ?? _defaultBuilder,
    emptyBuilder: (context, future, child) => WillPopScope(
      onWillPop: () async => false,
      child: emptyBuilder?.call(context, future!, child) ?? const SizedBox(),
    ),
    child: child,
  );

  Widget _defaultBuilder(BuildContext context, dynamic value, Widget? child) {
    WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.of(context).pop());
    return const SizedBox();
  }

}
