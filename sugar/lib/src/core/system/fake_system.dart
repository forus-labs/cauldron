import 'package:meta/meta.dart';

import 'package:sugar/core_system.dart';

/// Creates a [FakeSystem] for testing.
@visibleForTesting
class FakeSystem implements System {
  @override
  final PlatformType type;
  @override
  final String platform;

  /// Creates a [FakeSystem].
  const FakeSystem([this.type = PlatformType.unknown, this.platform = 'unknown']);

  @override
  @useResult
  bool get android => type == PlatformType.android;

  @override
  @useResult
  bool get fuchsia => type == PlatformType.fuchsia;

  @override
  @useResult
  bool get ios => type == PlatformType.ios;

  @override
  @useResult
  bool get linux => type == PlatformType.linux;

  @override
  @useResult
  bool get macos => type == PlatformType.macos;

  @override
  @useResult
  bool get windows => type == PlatformType.windows;

  @override
  @useResult
  bool get web => type == PlatformType.web;
}
