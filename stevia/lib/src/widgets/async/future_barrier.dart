import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// Shows a non-dismissible [ModalBarrier] until the given [future] has completed. 
/// 
/// It optionally contains the widget returned by [builder].
/// 
/// ```dart
/// class SomeWidget extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) => Center(
///     child: FloatingActionButton(
///       onPressed: () => showFutureBarrier(
///           context: context,
///           future: Future.delayed(const Duration(seconds: 10)),
///           builder: (context) => Text('This barrier will disappear after 5.'),
///       ),
///       child: Text('Load'),
///     ),
///   );
/// }
/// ```
Future<void> showFutureBarrier({required BuildContext context, required Future<dynamic> future, WidgetBuilder? builder}) => showDialog(
  context: context,
  useRootNavigator: false,
  barrierDismissible: false,
  builder: (context) => FutureBarrier(
    future: future,
    builder: builder,
  ),
);

/// A [FutureBarrier]
@internal class FutureBarrier extends StatefulWidget {

  /// The asynchronous computation that is being awaited.
  final Future<dynamic> future;
  /// The builder used to build the contents.
  final WidgetBuilder? builder;

  /// Creates a [FutureBarrier].
  const FutureBarrier({required this.future, this.builder});

  @override
  State<FutureBarrier> createState() => _State();

}

class _State<T> extends State<FutureBarrier> {

  Object? _activeCallbackIdentity;
  bool done = false;

  @override
  void initState() {
    super.initState();
    _subscribe();
  }

  @override
  void didUpdateWidget(covariant FutureBarrier old) {
    super.didUpdateWidget(old);
    if (old.future != widget.future) {
      _subscribe();
    }
  }

  void _subscribe() {
    final callbackIdentity = Object();
    _activeCallbackIdentity = callbackIdentity;
    widget.future.then<void>((value) {
      if (_activeCallbackIdentity == callbackIdentity) {
        setState(() => done = true);
      }
    }, onError: (error, stackTrace) {
      if (_activeCallbackIdentity == callbackIdentity) {
        setState(() => done = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (done) {
      WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.of(context).pop());
    }

    return WillPopScope(
      onWillPop: () async => done,
      child: widget.builder?.call(context) ?? const SizedBox(),
    );
  }

}
