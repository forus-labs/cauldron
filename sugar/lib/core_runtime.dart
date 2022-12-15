library sugar.core.runtime;

export 'package:sugar/src/core/runtimes/fake_runtime.dart';
export 'package:sugar/src/core/runtimes/runtime.dart'
if (dart.library.io) 'package:sugar/src/core/runtimes/vm_runtime.dart'
if (dart.library.html) 'package:sugar/src/core/runtimes/web_runtime.dart';