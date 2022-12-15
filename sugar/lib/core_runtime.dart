/// Provides platform agnostic utilities for retrieving information about the current platform.
///
/// This library also provides a [FakeRuntime] for testing purposes.
library sugar.core.runtime;

import 'package:sugar/src/core/runtimes/fake_runtime.dart';

export 'package:sugar/src/core/runtimes/fake_runtime.dart';
export 'package:sugar/src/core/runtimes/runtime.dart'
if (dart.library.io) 'package:sugar/src/core/runtimes/vm_runtime.dart'
if (dart.library.html) 'package:sugar/src/core/runtimes/web_runtime.dart';