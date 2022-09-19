import 'dart:async';

import 'package:semaphore/semaphore.dart';
import 'package:sugar/core.dart';

// maybe a debounce function? under async

    
    
class Mutex {
  
  static VoidCallback callback(FutureOr<void> Function() callback, [VoidCallback otherwise]) {
    var mutex = false;
    return () async {
      if (!mutex) {
        try {
          mutex = true;
          final future = callback();
          if (future is Future<void>) {
            await future;
          }

        } finally {
          mutex = false;
        }
      }
    };
  }
  
}
