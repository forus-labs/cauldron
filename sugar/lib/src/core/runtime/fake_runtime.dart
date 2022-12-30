import 'package:meta/meta.dart';
import 'package:sugar/core_runtime.dart';

/// Creates a [FakeRuntime] used for testing purposes.
@visibleForTesting
class FakeRuntime implements Runtime {

  @override final PlatformType type;
  @override final String platform;

  /// Creates a [FakeRuntime].
  const FakeRuntime([this.type = PlatformType.unknown, this.platform = 'unknown']);

  @override
  bool get android => type == PlatformType.android;

  @override
  bool get fuchsia => type == PlatformType.fuchsia;

  @override
  bool get ios => type == PlatformType.ios;

  @override
  bool get linux => type == PlatformType.linux;

  @override
  bool get macos => type == PlatformType.macos;

  @override
  bool get windows => type == PlatformType.windows;

  @override
  bool get web => type == PlatformType.web;

}
