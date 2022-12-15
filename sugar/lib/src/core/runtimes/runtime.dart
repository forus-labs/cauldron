// ignore_for_file: public_member_api_docs

/// Provides information about the current runtime.
///
/// This class provides a platform agnostic way to retrieve information about the platform.
class Runtime {

  /// Creates [Runtime].
  const Runtime();

  /// The current platform. For example, `"Windows 10 Pro" 10.0 (Build 19043)` on Windows, or
  /// `5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/108.0.5359.100 Safari/537.36`
  /// on Chrome.
  ///
  /// Returns `unknown` if the platform is unknown.
  String get platform => 'unknown';

  /// The current platform type.
  ///
  /// See [RuntimeType].
  RuntimeType get type => RuntimeType.unknown;

  /// Whether the current runtime type is `android`.
  bool get android => false;

  /// Whether the current runtime type is `fuchsia`.
  bool get fuchsia => false;

  /// Whether the current runtime type is `ios`.
  bool get ios => false;

  /// Whether the current runtime type is `linux`.
  bool get linux => false;

  /// Whether the current runtime type is `macos`.
  bool get macos => false;

  /// Whether the current runtime type is `windows`.
  bool get windows => false;

  /// Whether the current runtime type is `web`.
  bool get web => false;

}

/// The runtime's type.
enum RuntimeType {
  android,
  fuchsia,
  ios,
  linux,
  macos,
  windows,
  web,
  unknown,
}
