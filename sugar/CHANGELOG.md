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
>>>>>>> master

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