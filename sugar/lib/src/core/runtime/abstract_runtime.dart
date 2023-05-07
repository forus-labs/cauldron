// ignore_for_file: public_member_api_docs

import 'package:meta/meta.dart';

/// Provides a platform agnostic way to retrieve information about the platform.
class Runtime {

  /// Creates a [Runtime].
  const Runtime();

  /// The current platform.
  ///
  /// The browser information may not be accurate since it relies on the `User-Agent` header.
  ///
  /// For example:
  /// * Chrome - `5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/108.0.5359.100 Safari/537.36`
  /// * Windows - `"Windows 10 Pro" 10.0 (Build 19043)`
  @useResult external String get platform;

  /// The current platform type.
  ///
  /// See [PlatformType].
  @useResult external PlatformType get type;

  /// Whether the current runtime type is `android`.
  @useResult external bool get android;

  /// Whether the current runtime type is `fuchsia`.
  @useResult external bool get fuchsia;

  /// Whether the current runtime type is `ios`.
  @useResult external bool get ios;

  /// Whether the current runtime type is `linux`.
  @useResult external bool get linux;

  /// Whether the current runtime type is `macos`.
  @useResult external bool get macos;

  /// Whether the current runtime type is `windows`.
  @useResult external bool get windows;

  /// Whether the current runtime type is `web`.
  @useResult external bool get web;

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
