/// Platform agnostic utilities for retrieving information about the current platform across both native and web.
/// This is an alternative to `dart:io`'s `Platform` class that only works on native.
///
/// A [Runtime] provides utilities for retrieving information about the current platform. This includes the current
/// operating system name & version if called on Dart native, and the current web browser on Dart web. Information about
/// the current web browser version may not be accurate since it relies on the `User-Agent` header.
///
/// A [FakeRuntime] is also provided for testing purposes.
library sugar.core.runtime;

import 'package:sugar/src/core/runtime/abstract_runtime.dart';
import 'package:sugar/src/core/runtime/fake_runtime.dart';

export 'src/core/runtime/abstract_runtime.dart'
  if (dart.library.io) 'package:sugar/src/core/runtime/native_runtime.dart'
  if (dart.library.html) 'package:sugar/src/core/runtime/web_runtime.dart';
export 'src/core/runtime/fake_runtime.dart';
