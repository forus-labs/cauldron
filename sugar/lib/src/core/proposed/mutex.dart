import 'dart:async';

import 'package:sugar/sugar.dart';

class Mutex {

  static Callback callback(Callback callback) {
    var acquired = false;
    return () async {
      if (acquired) {
        return;
      }

      try {
        acquired = true;
        final result = callback();
        if (result is Future<dynamic>) {
          await result;
        }

      } finally {
        acquired = false;
      }
    };
  }

}

class A {

  final Mutex _mutex;

  Future<void> share() {
    _mutex.scope(() {

    });
  }

}
