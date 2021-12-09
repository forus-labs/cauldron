import 'package:meta/meta.dart';

/// Signifies that the implementing type holds resource (i.e. sockets, streams)
/// that need to be manually disposed.
///
/// Attempting to use an implementing instance after it has been disposed is undefined
/// behaviour.
///
/// This is in lieu of Dart refusing to provide a standardized [Disposable] interface
/// for the foreseeable future, https://github.com/dart-lang/sdk/issues/43490.
mixin Disposable {

  /// Disposes the resources held by an implementing type.
  @mustCallSuper
  void dispose();

}
