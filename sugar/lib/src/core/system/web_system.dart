import 'package:meta/meta.dart';
import 'package:web/web.dart';

// ignore_for_file: public_member_api_docs

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

  const System();

  String get platform => window.navigator.appVersion;

  PlatformType get type => PlatformType.web;

  bool get android => false;

  bool get fuchsia => false;

  bool get ios => false;

  bool get linux => false;

  bool get macos => false;

  bool get windows => false;

  bool get web => true;

}

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
