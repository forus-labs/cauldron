import 'package:meta/meta.dart';

/// A [Disposable] holds resources such as sockets and streams that need to be manually disposed.
///
/// Using a [Disposable] after it has been disposed is undefined behaviour.
///
/// ## Motivation
/// This is in lieu of Dart not providing a standardized [Disposable] interface for the foreseeable future,
/// https://github.com/dart-lang/sdk/issues/43490.
mixin Disposable {

  /// Disposes the held resources.
  @mustCallSuper
  void dispose();

}
