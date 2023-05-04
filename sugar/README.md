# Sugar - Syntax Sugar for Dart
[![Pub Dev](https://img.shields.io/pub/v/sugar)](https://pub.dev/packages/sugar)
[![Codecov](https://codecov.io/gh/forus-labs/cauldron/branch/master/graph/badge.svg)](https://codecov.io/gh/forus-labs/cauldron)
[![CI/CD](https://github.com/forus-labs/cauldron/workflows/Sugar%20Build/badge.svg)](https://github.com/forus-labs/cauldron/actions?query=workflow%3A%22Sugar+Build%22)
[![Documentation](https://img.shields.io/badge/documentation-latest-brightgreen.svg)](https://pub.dev/documentation/sugar/latest/)

Sugar is an extension to Dart's standard library. It provides the following (and much more!):
* Date-time & timezone library inspired by Java's [`java.time`](https://docs.oracle.com/en/java/javase/17/docs/api/java.base/java/time/package-summary.html) package.
* Monads such as `Result<S,F>` & `Maybe<T>`.
* Syntax sugar for aggregating & manipulating collections.
* Types for representing and working with ranges & intervals.


## Getting Started

With Dart:
```shell
dart pub add sugar 
```

With Flutter:
```shell
flutter pub add sugar 
```

This will add the following to your package's pubspec.yaml:
```yaml
dependencies:
  sugar: ^3.0.0
```

Now in your Dart code, you can use:
```dart
import 'package:sugar/sugar.dart';
```

Check out the [documentation](https://pub.dev/documentation/sugar/latest/) to get started!
