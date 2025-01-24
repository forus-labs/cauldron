/// {@category Core}
///
/// Platform agnostic utilities for retrieving information about the current platform and microseconds since Unix epoch.
///
/// A [System] provides functions for retrieving the current platform's information. Unlike `dart:io` `Platform`,
/// `Runtime` works on both native and web. The information includes the operating system name & version on native, and
/// the browser information on web. The browser information may not be accurate since it is derived from the `User-Agent`
/// header.
///
/// To retrieve the current platform:
/// ```dart
/// // Assuming that the current platform is Android.
/// print(const System().android); true
/// print(const System().web); false
/// ```
///
/// To retrieve the current microseconds since Unix epoch:
/// ```dart
/// // Assuming that the current microseconds since Unix epoch is 1000.
/// print(System.epochMicroseconds); // 1000
/// ```
///
/// A [FakeSystem] is also provided for testing.
///
/// ```dart
/// print(const FakeSystem(PlatformType.android).android); true
/// print(const FakeSystem(PlatformType.android).web); false
/// ```
library;

import 'package:sugar/src/core/system/abstract_system.dart';
import 'package:sugar/src/core/system/fake_system.dart';

export 'src/core/system/abstract_system.dart'
  if (dart.library.io) 'package:sugar/src/core/system/native_system.dart'
  if (dart.library.js_interop) 'package:sugar/src/core/system/web_system.dart';
export 'src/core/system/fake_system.dart';
