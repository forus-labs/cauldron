// ignore_for_file: public_member_api_docs

import 'dart:io';

/// Provides information about the current runtime.
///
/// This class provides a platform agnostic way to retrieve information about the platform.
class Runtime {

  /// Creates [Runtime].
  const Runtime();

  /// The current platform. For example, `"Windows 10 Pro" 10.0 (Build 19043)`.
  ///
  /// Returns `unknown` if the platform is unknown.
  String get platform => Platform.operatingSystemVersion;

  /// The current platform type.
  ///
  /// See [PlatformType].
  PlatformType get type => PlatformType._cache ??= PlatformType._current;

  /// Whether the current runtime type is `android`.
  bool get android => Platform.isAndroid;

  /// Whether the current runtime type is `fuchsia`.
  bool get fuchsia => Platform.isFuchsia;

  /// Whether the current runtime type is `ios`.
  bool get ios => Platform.isIOS;

  /// Whether the current runtime type is `linux`.
  bool get linux => Platform.isLinux;

  /// Whether the current runtime type is `macos`.
  bool get macos => Platform.isMacOS;

  /// Whether the current runtime type is `windows`.
  bool get windows => Platform.isWindows;

  /// Whether the current runtime type is `web`.
  bool get web => false;

}

/// The runtime's type.
enum PlatformType {
  android,
  fuchsia,
  ios,
  linux,
  macos,
  windows,
  web,
  unknown;

  // This assumes that the current platform cannot be changed mid-way through the programme's lifetime.
  static PlatformType? _cache;
  static PlatformType get _current {
    if (Platform.isAndroid) {
      return android;

    } else if (Platform.isFuchsia) {
      return fuchsia;

    } else if (Platform.isIOS) {
      return ios;

    } else if (Platform.isLinux) {
      return linux;

    } else if (Platform.isMacOS) {
      return macos;

    } else if (Platform.isWindows) {
      return windows;

    } else {
      return unknown;
    }
  }
}
