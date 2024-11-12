## 4.0.0 (Next)

## `sugar.collection`
- Add `Lists.toggleAll(...)`
- Add `SplayTreeMaps.firstValueAfter(...)`
- Add `SplayTreeMaps.lastValueBefore(...)`

## `sugar.core`
- Add `System.currentDateTime`
- Add `System.epochMilliseconds`
- Add `System.epochMicroseconds`
- **Breaking** - Change `Runtime` to `System` 
- **Breaking** - Remove `Maybe` extension.
- Remove `Iterables.indexed` since it already exists in Dart 3

## `sugar.crdt`
- Add `StringIndex`
- Add `Sil`

## `sugar.math`
- Add `NullableNumbers`
- Add `NullableIntegers`
- Add `NullableDoubles`
- **Breaking** Change `double.approximately(...)` to `double.around(...)`

## `sugar.time`
- Add optional `DateUnit` parameter to `LocalDate.now(...)`
- Add optional `TemporalUnit` parameter to `LocalDateTime.now(...)`
- Add optional `TimeUnit` parameter to `LocalTime.now(...)`
- Add optional `TimeUnit` parameter to `OffsetTime.now(...)`
- Change `LocalDate.now(...)` to be stubbable
- Change `LocalDateTime.now(...)` to be stubbable
- Change `LocalTime.now(...)` to be stubbable
- Change `OffsetTime.now(...)` to be stubbable
- Change IANA database from `2023c` to `2024b`
- Fix `Etc/*` timezones not returning correct string representation

## 3.1.0 (19/06/2023)

## `sugar.collection`
- Add `Sets.toggle(...)`
- Change `Iterables.indexed()` to `Iterables.indexed` to be consistent with `List.indexed`

## `sugar.core`
- Add `NotTested.thirdPartIntegration()`
- Change `Disposable` from a mixin to an abstract interface class
- Fix `Strings.toCamelCase()` throwing a `StateError` on empty strings

## `sugar.math`
- Add `Random.nextWeightedBool(...)`

### `sugar.time.interop`
- Add `Dates.leapYearMonths`
- Add `Dates.nonLeapYearMonths`
- ADd `DateTimes.fromDaysSinceEpoch(...)`
- Add `DateTimes.toLocalDate()`
- Add `DateTimes.toLocalDateTime()`
- Add `DateTimes.toLocalTime()`
- Add `DateTimes.toOffsetTime()`
- Add `DateTimes.toZonedDateTime()`

## 3.0.0+1 (15/05/2023)

Update `README.md`

## 3.0.0 (14/05/2023)

This release is a complete rework of the library, capitalizing on the real-life experiences gained over the past 2 years.

* Date-time and timezone API inspired by [`java.time`](https://docs.oracle.com/en/java/javase/17/docs/api/java.base/java/time/package-summary.html).
* Monads such as `Result<S,F>` & `Maybe<T>`.
* Syntax sugar for aggregating & manipulating collections.
* Types for representing and working with ranges & intervals.


## 2.4.1 (02/12/2022)

This release fixes `Equality.equals(...)` accepting a `dynamic` instead of `Object`.

## 2.4.0 (09/12/2021)

This release bumps the minimum supported Dart version to 2.15

## 2.3.3 (08/12/2021)

This release adds an accidentally omitted method.

- Add `Weekdays.unparse(Iterable<bool>)`

## 2.3.2 (07/12/2021)

This release adds a few additional convince methods.

- Add `Integers.from(bool)`
- Add `Integers.toBool()`
- Add `Weekdays.parse(int)`

## 2.3.1 (19/11/2021)

This release focuses on improving documentation and preparing for Dart 2.15.

- Add `disposable.dart`
- Change `crypto.dart` to `cryptography.dart`

## 2.3.0 (10/09/2021)

This release adds new higher-order functions for composing functions. In addition, the library now minimally requires Dart 2.14.

- Add `Call` type definition
- Add `Calls` extension that contain higher-order functions for composing `Call`s
- Add `Consumer` type definition
- Add `Consumers` extension that contain higher-order functions for composing `Consumer`s
- Add `Mapper` type definition
- Add `Mappers` extension that contain higher-order functions for composing `Mapper`s
- Add `Predicate` type definition
- Add `Predicates` extension that contain higher-order functions for composing `Predicate`s
- Add `Supplier` type definition
- Add `Suppliers` extension that contain higher-order functions for composing `Supplier`s
- Change `Lists.repeat(int)` extension to `Lists.operator *(int)`.
- Remove `hash(Iterable<dynamic>)` - function has been superseded by `Object.hash(...)` in `dart:core`.

## 2.2.0 (21/07/2021)

- Add `Debounce`

## 2.1.1 (17/07/2021)

- Add `List<T>.repeat(T)`
- Change `List<T>.separate(T)` to `List<T>.alternate(T)`

## 2.1.0 (30/06/2021)

This release adds new annotations & cryptological functions.

- Add `@PlatformDependent`
- Add `@Subset`
- Add `@Throws`
- Add `@annotation`
- Add `@throws`
- Add `HashExtensions`
- Add `nonce(...)`
- Change `Result.present` to `Result.successful`
- Change `Result.notPresent` to `Result.failure`
- Change `Result.ifPresent(...)` tp `Result.ifSuccessful(...)`
- Change `Result.ifNotPresent(...)` tp `Result.ifFailure(...)`

## 2.0.1 - (29/06/2021)

Downgrade `meta` from `1.4.0` to `.1.3.0` to enable compatibility with Flutter

## 2.0.0 - We have awoken! (25/06/2021)

This release focuses on supporting null safety.

## 1.0.0 - Initial Launch! 🚀 (06/10/2020)

- Add collection library
- Add core library
- Add time library
