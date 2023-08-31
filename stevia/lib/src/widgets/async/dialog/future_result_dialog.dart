import 'package:flutter/material.dart';
import 'package:stevia/stevia.dart';
import 'package:sugar/sugar.dart';

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
  ValueWidgetBuilder<Future<Result<S, F>>>? emptyBuilder,
  Widget? child,
}) async {
  final result = future();
  await showAdaptiveDialog(
    context: context,
    useRootNavigator: false,
    barrierDismissible: false,
    builder: (context) => FutureResultDialog._(
      future: result,
      builder: builder,
      failureBuilder: failureBuilder,
      emptyBuilder: emptyBuilder,
      child: child,
    ),
  );

  return result;
}


/// A [FutureResultDialog]. See [showFutureValueDialog] for more details.
class FutureResultDialog<S extends Object, F extends Object> extends StatelessWidget {

  /// The asynchronous computation.
  final Future<Result<S, F>> future;
  /// The build strategy currently used by this builder when an initial value or [Success] produced by [future] is available.
  ///
  /// This builder must only return a widget and should not have any side effects as it may be called multiple times.
  final ValueWidgetBuilder<S>? builder;
  /// The build strategy currently used by this builder when [future] produces a [Failure].
  ///
  /// This builder must only return a widget and should not have any side effects as it may be called multiple times.
  final ValueWidgetBuilder<F>? failureBuilder;
  /// The build strategy currently used by this builder when no [S] or [F] is available.
  ///
  /// This builder must only return a widget and should not have any side effects as it may be called multiple times.
  final ValueWidgetBuilder<Future<Result<S, F>>>? emptyBuilder;
  /// A future-independent widget which is passed back to the [builder].
  ///
  /// This argument is optional and can be null if the entire widget subtree the [builder] builds depends on the value
  /// of the future. For example, in the case where the future is a [String] and the [builder] returns a [Text] widget
  /// with the current [String] value, there would be no useful [child].
  final Widget? child;

  const FutureResultDialog._({
    required this.future,
    this.builder,
    this.failureBuilder,
    this.emptyBuilder,
    this.child,
  });

  @override
  Widget build(BuildContext context) => FutureResultBuilder(
    future: (_) => future,
    builder: builder ?? _defaultBuilder,
    failureBuilder: failureBuilder ?? _defaultBuilder,
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
