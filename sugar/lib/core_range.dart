/// Utilities for representing and manipulating a range of values in a domain.
///
/// A [Range] is a convex (contiguous) portion of a domain. It may be finitely constrained, i.e. `0 <= x < 5`,
/// or extend to infinity, i.e. `x > 3`.
///
/// ### Types of ranges
/// Each end of a range may be either bound or unbounded. If bounded, a minimum or maximum value is associated with a
/// range's end. Furthermore, a bounded range's end is either _closed_ (includes the value), or _open_ (excludes the value).
/// For example, a closed-open range can be denoted as `0 <= x < 5`.
///
/// The following table describes the types of ranges supported by this library.
///
/// | Notation  | Range                 | Type/Constructor      |
/// | --------- | --------------------- | --------------------- |
/// | `(a..+∞)` | `{ x \| a < x }`       | [Min]                 |
/// | `[a..+∞)` | `{ x \| a <= x }`      | [Min]                 |
/// | `(a..b)`  | `{ x \| a < x < b }`   | [Interval.open]       |
/// | `(a..b]`  | `{ x \| a < x <= b }`  | [Interval.openClosed] |
/// | `[a..b]`  | `{ x \| a <= x <= b }` | [Interval.closed]     |
/// | `[a..b)`  | `{ x \| a < x <= b }`  | [Interval.closedOpen] |
/// | `(-∞..b)` | `{ x \| x < b }`       | [Max]                 |
/// | `(-∞..b]` | `{ x \| x <= b }`      | [Max]                 |
///
/// In addition, the following ranges are valid:
/// * singleton ranges - `[a..a]`
/// * empty ranges - `[a..a)` and `(a..a]`
///
/// Ranges with open bounds and, equal minimum and maximum values, i.e. `(a..b)` are *not* valid.
library sugar.core.range;

import 'package:sugar/src/core/range/range.dart';
import 'package:sugar/src/core/range/interval.dart';
import 'package:sugar/src/core/range/max.dart';
import 'package:sugar/src/core/range/min.dart';

export 'src/core/range/interval.dart';
export 'src/core/range/max.dart';
export 'src/core/range/min.dart';
export 'src/core/range/range.dart' hide Besides, Intersects;
