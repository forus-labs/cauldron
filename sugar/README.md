# Sugar - Standard Library Extension
[![Pub Dev](https://img.shields.io/pub/v/sugar)](https://pub.dev/packages/sugar)
[![Codecov](https://codecov.io/gh/forus-labs/cauldron/branch/master/graph/badge.svg)](https://codecov.io/gh/forus-labs/cauldron)
[![Documentation](https://img.shields.io/badge/documentation-latest-brightgreen.svg)](https://pub.dev/documentation/sugar/latest/)

Sugar is an extension to Dart's standard library. 

It provides the following (and much more!):
* Date-time and timezone API inspired by [`java.time`](https://docs.oracle.com/en/java/javase/17/docs/api/java.base/java/time/package-summary.html).
* Monads such as `Result<S,F>`.
* Syntax sugar for aggregating & manipulating collections.
* Types for representing and working with ranges & intervals.

It consolidates several micro-packages that provide bits and pieces of date-time & timezone utilities into a single package.

## Why Sugar's date-time API over other packages?

* Sugar is able to detect the platform's timezone, `ZonedDateTime.now()` synchronously. Other packages such as `timezone` don't. `flutter_native_timezone` detects the timezone asynchronously while [`DateTime.timeZoneName`](https://api.dart.dev/stable/dart-core/DateTime/timeZoneName.html) 
  returns an ambiguous abbreviation that can refer to multiple timezones. Sugar provide a TZDB timezone identifier such as `Asia/Singapore`. 
  See [List of timezone abbreviations](https://en.wikipedia.org/wiki/List_of_time_zone_abbreviations).

* Sugar is less hassle to set up. You don't need to fiddle with assets. Simply create a [`ZonedDateTime`](https://pub.dev/documentation/sugar/latest/sugar.time/sugar.time-library.html).

* Sugar has (in theory) lower initialization cost. Other packages often parse the timezone information from binary files at runtime. 
  We rely on code generation to eliminate IO during initialization completely. 

* Sugar has a better memory footprint. Other packages often load the entire TZ database into memory. We rely on lazy initialization 
  to load only timezones actually used.

* Sugar offers more than just `ZonedDateTime`. It aims to be a one-stop for your date-time needs. It offers classes such 
  as `LocalTime` & `Period`, and utilities such as retrieving the ordinal week of the year.


## Getting Started

Run the following command:
```shell
dart pub add sugar
```

Alternatively, add Sugar as a dependency in your pubspec:
```yaml
dependencies:
  sugar: ^4.0.0
```

Import the library:
```dart
import 'package:sugar/sugar.dart';
```

Check out the [documentation](https://pub.dev/documentation/sugar/latest/) to get started.

## Updating timezones

This section is for maintainers. It describes how to update the embedded IANA database. It assumes that you are on macOS/Linux.
The current version of the IANA database is 2025a.

```shell
$ chmod +x tool/refresh.sh
$ tool/refresh.sh
```
