// ignore_for_file: public_member_api_docs

import 'package:meta/meta.dart';

/// Provides a platform agnostic way to retrieve information about the system.
class System {

  /// The system's current date-time that can be modified for testing.
  ///
  /// ## Contract
  /// The returned [DateTime] may be in either local or UTC timezone.
  ///
  /// ## Example
  /// ```dart
  /// void main() {
  ///   test('current date-time', () {
  ///     System.currentDateTime = () => DateTime.utc(2023, 7, 9, 10, 30);
  ///     expect(System.epochMilliseconds, 1688898600000);
  ///   });
  /// }
  /// ```
  @useResult static DateTime Function() currentDateTime = DateTime.now;

  /// The current milliseconds since Unix epoch that can be modified for testing by setting [currentDateTime].
  ///
  /// ```dart
  /// void main() {
  ///   test('current epoch milliseconds', () {
  ///     System.currentDateTime = () => DateTime.utc(2023, 7, 9, 10, 30);
  ///     expect(System.epochMilliseconds, 1688898600000);
  ///   });
  /// }
  /// ```
  @useResult static int get epochMilliseconds => currentDateTime().millisecondsSinceEpoch;

  /// The current microseconds since Unix epoch that can be modified for testing by setting [currentDateTime].
  ///
  /// ```dart
  /// void main() {
  ///   test('current epoch microseconds', () {
  ///     System.currentDateTime = () => DateTime.utc(2023, 7, 9, 10, 30);
  ///     expect(System.epochMilliseconds, 1688898600000000);
  ///   });
  /// }
  /// ```
  @useResult static int get epochMicroseconds => currentDateTime().microsecondsSinceEpoch;


  /// Creates a [System].
  const System();

  /// The current platform.
  ///
  /// The browser information may not be accurate since it relies on the `User-Agent` header.
  ///
  /// For example:
  /// * Chrome - `5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/108.0.5359.100 Safari/537.36`
  /// * Windows - `"Windows 10 Pro" 10.0 (Build 19043)`
  @useResult String get platform => '';

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
