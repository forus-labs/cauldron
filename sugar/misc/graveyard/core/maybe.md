# Maybe

The `Maybe` monad was introduced in Sugar 3. It was designed before Dart 3 & pattern matching became publicly available.
After having used Dart 3 for a while, it has become clear that pattern matching is a superior alternative to the `Maybe`
monad extension that we provide. The current implementation piggybacks on the type system and doesn't introduce an explicit
type. It almost meant that it didn't provide much value.

For example, the following code snippet that uses `Maybe`:
```dart
String? foo(int? bar) { // int? is a Maybe(int) monad.
  return bar.where((e) => e == 1).map((e) => e.toString());
}
```

Can easily be replaced, with more clarity, using pattern matching:
```dart
String? foo(int? bar) => switch (bar) {
  final bar? when e == 1 => e.toString(),
  null => null,
};
```
