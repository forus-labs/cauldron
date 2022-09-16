## Idempotent functions

```dart
/// Provides functions for transforming other functions into idempotent functions.
extension Idempotent on Never {

  /// Transforms the given [callback] into an idempotent function.
  @useResult
  static VoidCallback callback(VoidCallback callback) {
    var called = false;
    return () {
      if (called) {
        return;
      }

      try {
        callback();
      } finally {
        called = true;
      }
    };
  }

}
```

This type of function was extremely easy to misuse, especially with the `onPressed` parameter of numerous widgets in Flutter.
In Flutter, the callback can be reused across multiple rebuilds. This causes the widget to not work as expected after the first call.