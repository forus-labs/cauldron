import 'package:meta/meta.dart';
import 'package:sugar/core_runtime.dart';

/// Creates a [FakeRuntime] used for testing purposes.
@visibleForTesting
class FakeRuntime implements Runtime {

  @override final RuntimeType type;
  @override final String platform;

  /// Creates a [FakeRuntime].
  const FakeRuntime([this.type = RuntimeType.unknown, this.platform = 'unknown']);

  @override
  bool get android => type == RuntimeType.android;

  @override
  bool get fuchsia => type == RuntimeType.fuchsia;

  @override
  bool get ios => type == RuntimeType.ios;

  @override
  bool get linux => type == RuntimeType.linux;

  @override
  bool get macos => type == RuntimeType.macos;

  @override
  bool get windows => type == RuntimeType.windows;

  @override
  bool get web => type == RuntimeType.web;

}
