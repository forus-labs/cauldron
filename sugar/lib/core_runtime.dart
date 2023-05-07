/// {@category Core}
///
/// Platform agnostic utilities for retrieving information about the current platform.
///
/// A [Runtime] provides functions for retrieving the current platform's information. Unlike `dart:io` `Platform`,
/// `Runtime` works on both native and web. The information includes the operating system name & version on native, and
/// the browser information on web. The browser information may not be accurate since it is derived from the `User-Agent`
/// header.
///
/// ```dart
/// // Assuming that the current platform is Android.
/// print(const Runtime().android); true
/// print(const Runtime().web); false
/// ```
///
/// A [FakeRuntime] is also provided for testing.
///
/// ```dart
/// print(const FakeRuntime(PlatformType.android).android); true
/// print(const FakeRuntime(PlatformType.android).web); false
/// ```
library sugar.core.runtime;

import 'package:sugar/src/core/runtime/abstract_runtime.dart';
import 'package:sugar/src/core/runtime/fake_runtime.dart';

export 'src/core/runtime/abstract_runtime.dart'
  if (dart.library.io) 'package:sugar/src/core/runtime/native_runtime.dart'
  if (dart.library.html) 'package:sugar/src/core/runtime/web_runtime.dart';
export 'src/core/runtime/fake_runtime.dart';
