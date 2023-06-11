# Sugar - Standard Library Extension
[![Sugar](https://github.com/forus-labs/cauldron/actions/workflows/sugar.yaml/badge.svg)](https://github.com/forus-labs/cauldron/actions/workflows/sugar.yaml)
[![Codecov](https://codecov.io/gh/forus-labs/cauldron/branch/master/graph/badge.svg)](https://codecov.io/gh/forus-labs/cauldron)
[![Pub Dev](https://img.shields.io/pub/v/sugar)](https://pub.dev/packages/sugar)
[![Documentation](https://img.shields.io/badge/documentation-latest-brightgreen.svg)](https://pub.dev/documentation/sugar/latest/)

Sugar is an extension to Dart's standard library. 

It provides the following (and much more!):
* Date-time and timezone API inspired by [`java.time`](https://docs.oracle.com/en/java/javase/17/docs/api/java.base/java/time/package-summary.html).
* Monads such as `Result<S,F>` & `Maybe<T>`.
* Syntax sugar for aggregating & manipulating collections.
* Types for representing and working with ranges & intervals.

It consolidates several micro-packages that provide bits and pieces of date-time & timezone utilities into a single package.

## Why Sugar's date-time API over other packages?

* Sugar is able to detect the platform's timezone, `ZonedDateTime.now()`. Other packages such as `timezone` and even Dart's standard library don't. 
  [`DateTime.timeZoneName`](https://api.dart.dev/stable/dart-core/DateTime/timeZoneName.html) returns an ambiguous abbreviation that can refer to multiple timezones. 
  Sugar provide a TZ database timezone identifier such as `Asia/Singapore`.
  See [List of timezone abbreviations](https://en.wikipedia.org/wiki/List_of_time_zone_abbreviations).

* Sugar is less hassle to set up. You don't need to fiddle with assets or asynchronously initialize the library. Simply create a [`ZonedDateTime`](https://pub.dev/documentation/sugar/latest/sugar.time/sugar.time-library.html).

* Sugar has (in theory) zero initialization cost & a better memory footprint. Other packages often parse the timezone information from binary files at runtime. 
  We rely on code generation to eliminate IO completely. Other packages often load the entire TZ database into memory. 
  We rely on lazy initialization to load only timezones you use, reducing memory footprint. 

* Sugar handles DST transitions similar to other packages such as Java, Python & C#. Other packages such as `timezone` don't. 
  This can be an issue when interacting between a back-end written in one of those languages and a front-end written in Dart.

* Sugar offers more than just `ZonedDateTime`. It offers classes such as `LocalTime` & `Period`, and utilities such as retrieving the ordinal week of the year.


## Getting Started

Run the following command:
```shell
dart pub add sugar
```

Alternatively, add Sugar as a dependency in your pubspec:
```yaml
dependencies:
  sugar: ^3.0.0
```

Import the library:
```dart
import 'package:sugar/sugar.dart';
```

Check out the [documentation](https://pub.dev/documentation/sugar/latest/) to get started.
