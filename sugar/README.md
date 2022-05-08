# Sugar - Syntax Sugar for Dart
[![Sugar Build](https://github.com/forus-labs/cauldron/workflows/Sugar%20Build/badge.svg)](https://github.com/forus-labs/cauldron/actions?query=workflow%3A%22Sugar+Build%22)
[![Pub Dev](https://img.shields.io/pub/v/sugar)](https://pub.dev/packages/sugar)
[![Documentation](https://img.shields.io/badge/documentation-latest-brightgreen.svg)](https://pub.dev/documentation/sugar/latest/)

Sugar doesn't hold some grandiose vision that radically changes programming. It just contains utilities that improve our quality of life.

**Please view the [stable brunch](https://github.com/forus-labs/cauldron/tree/stable/sugar/) for a production version.**

```yaml
dependencies:
  sugar: ^2.4.0
```
#### Core

* Extensions to compose functions fluently.
* Higher order functions for composing functions
* Monads (i.e. `Result<T, E>`, `Union<L, R>`)
* Utilities to manage debouncing
* Utilities to simplify implementation of `==` and other comparisons
* Utilities for maths, numerics and strings

#### Collection

* More `Iterable` functions
* Utilities for comparing the contents of `Collection`s
* Tuples (`Pair`, `Triple` and `Quad`)

#### Time

* Distinct local and UTC date-time types
* Distinct date and time types
* Utilities for conversion between time units and rounding date-times
* Serialization and deserialization of weekdays

