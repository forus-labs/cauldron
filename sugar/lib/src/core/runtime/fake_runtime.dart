import 'package:meta/meta.dart';
import 'package:sugar/core_runtime.dart';

/// Creates a [FakeRuntime] for testing purposes.
@visibleForTesting
class FakeRuntime implements Runtime {

  @override final PlatformType type;
  @override final String platform;

  /// Creates a [FakeRuntime].
  const FakeRuntime([this.type = PlatformType.unknown, this.platform = 'unknown']);

  @override
  @useResult bool get android => type == PlatformType.android;

  @override
  @useResult bool get fuchsia => type == PlatformType.fuchsia;

  @override
  @useResult bool get ios => type == PlatformType.ios;

  @override
  @useResult bool get linux => type == PlatformType.linux;

  @override
  @useResult bool get macos => type == PlatformType.macos;

  @override
  @useResult bool get windows => type == PlatformType.windows;

  @override
  @useResult bool get web => type == PlatformType.web;

}
