# Sugar - Standard Library Extension
[![CI/CD](https://github.com/forus-labs/cauldron/workflows/Sugar/badge.svg)](https://github.com/forus-labs/cauldron/actions?query=workflow%3A%22Sugar)
[![Codecov](https://codecov.io/gh/forus-labs/cauldron/branch/master/graph/badge.svg)](https://codecov.io/gh/forus-labs/cauldron)
[![Pub Dev](https://img.shields.io/pub/v/sugar)](https://pub.dev/packages/sugar)
[![Documentation](https://img.shields.io/badge/documentation-latest-brightgreen.svg)](https://pub.dev/documentation/sugar/latest/)

Sugar is an extension to Dart's standard library. 

It provides the following (and much more!):
* Date-time and timezone API inspired by [`java.time`](https://docs.oracle.com/en/java/javase/17/docs/api/java.base/java/time/package-summary.html).
* Monads such as `Result<S,F>` & `Maybe<T>`.
* Syntax sugar for aggregating & manipulating collections.
* Types for representing and working with ranges & intervals.


## Getting Started

Run the following command:
```shell
dart pub add sugar
```

Alternatively, add Sugar as a dependency in your pubspec:
```yaml
dependencies:
  sugar: ^ 3.0.0
```

Import the library:
```dart
import 'package:sugar/sugar.dart';
```

Check out the [documentation](https://pub.dev/documentation/sugar/latest/) to get started.
