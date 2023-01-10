// ignore_for_file: public_member_api_docs

import 'package:meta/meta.dart';

/// Provides a platform agnostic way to retrieve information about the platform at runtime.
class Runtime {

  /// Creates [Runtime].
  const Runtime();

  /// The current platform. For example, `"Windows 10 Pro" 10.0 (Build 19043)` on Windows, or
  /// `5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/108.0.5359.100 Safari/537.36`
  /// on Chrome.
  ///
  /// Note: Information about the current web browser version may not be accurate since it relies on the `User-Agent` header.
  ///
  /// Returns `unknown` if the platform is unknown.
  @useResult String get platform => 'unknown';

  /// The current platform type.
  ///
  /// See [PlatformType].
  @useResult PlatformType get type => PlatformType.unknown;

  /// Whether the current runtime type is `android`.
  @useResult bool get android => false;

  /// Whether the current runtime type is `fuchsia`.
  @useResult bool get fuchsia => false;

  /// Whether the current runtime type is `ios`.
  @useResult bool get ios => false;

  /// Whether the current runtime type is `linux`.
  @useResult bool get linux => false;

  /// Whether the current runtime type is `macos`.
  @useResult bool get macos => false;

  /// Whether the current runtime type is `windows`.
  @useResult bool get windows => false;

  /// Whether the current runtime type is `web`.
  @useResult bool get web => false;

}

/// The platform's type.
enum PlatformType {
  android,
  fuchsia,
  ios,
  linux,
  macos,
  windows,
  web,
  unknown,
}
