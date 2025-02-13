/// Provides functions for working with nullable [num]s, specifically their operator overloads which do not work with
/// the null-aware operator.
///
/// ## Note:
/// Chaining functions provided by this extension is not recommended in performance sensitive contexts due to the
/// repeated null checks with each function call.
extension NullableNumbers on num? {
  /// Returns the sum of this and [other], or `null` if either is `null`.
  ///
  /// ```dart
  /// num? foo(num? a, num? b) => a + b;
  ///
  /// foo(1, null); // null
  /// foo(1, 2); // 3
  /// ```
  num? operator +(num? other) => (this == null || other == null) ? null : this! + other;

  /// Returns the difference of this and [other], or `null` if either is `null`.
  ///
  /// ```dart
  /// num? foo(num? a, num? b) => a - b;
  ///
  /// foo(1, null); // null
  /// foo(1, 2); // -1
  /// ```
  num? operator -(num? other) => (this == null || other == null) ? null : this! - other;

  /// Returns the product of this and [other], or `null` if either is `null`.
  ///
  /// ```dart
  /// num? foo(num? a, num? b) => a * b;
  ///
  /// foo(1, null); // null
  /// foo(1, 2); // 2
  /// ```
  num? operator *(num? other) => (this == null || other == null) ? null : this! * other;

  /// Returns the remainder of this divided by [other], or `null` if either is `null`.
  ///
  /// ```dart
  /// num? foo(num? a, num? b) => a % b;
  ///
  /// foo(1, null); // null
  /// foo(1, 2); // 1
  /// ```
  num? operator %(num? other) => (this == null || other == null) ? null : this! % other;

  /// Returns the quotient of this divided by [other], or `null` if either is `null`.
  ///
  /// ```dart
  /// num? foo(num? a, num? b) => a / b;
  ///
  /// foo(1, null); // null
  /// foo(1, 2); // 0.5
  /// ```
  num? operator /(num? other) => (this == null || other == null) ? null : this! / other;

  /// Returns the integer quotient of this divided by [other], or `null` if either is `null`.
  ///
  /// ```dart
  /// num? foo(num? a, num? b) => a ~/ b;
  ///
  /// foo(1, null); // null
  /// foo(1, 2); // 0
  /// ```
  int? operator ~/(num? other) => (this == null || other == null) ? null : this! ~/ other;

  /// Returns the negation of this, or `null` if this is `null`.
  ///
  /// ```dart
  /// num? foo(num? a) => -a;
  ///
  /// foo(null); // null
  /// foo(1); // -1
  /// ```
  num? operator -() => this == null ? null : -this!;

  /// Returns whether this is less than [other], or `null` if either is `null`.
  ///
  /// ```dart
  /// num? foo(num? a, num? b) => a < b;
  ///
  /// foo(1, null); // null
  /// foo(1, 2); // true
  /// ```
  bool? operator <(num? other) => (this == null || other == null) ? null : this! < other;

  /// Returns whether this is less than or equal than [other], or `null` if either is `null`.
  ///
  /// ```dart
  /// num? foo(num? a, num? b) => a <= b;
  ///
  /// foo(1, null); // null
  /// foo(1, 1); // true
  /// ```
  bool? operator <=(num? other) => (this == null || other == null) ? null : this! <= other;

  /// Returns whether this is greater than [other], or `null` if either is `null`.
  ///
  /// ```dart
  /// num? foo(num? a, num? b) => a > b;
  ///
  /// foo(1, null); // null
  /// foo(1, 2); // false
  /// ```
  bool? operator >(num? other) => (this == null || other == null) ? null : this! > other;

  /// Returns whether this is greater than or equal to [other], or `null` if either is `null`.
  ///
  /// ```dart
  /// num? foo(num? a, num? b) => a >= b;
  ///
  /// foo(1, null); // null
  /// foo(1, 2); // true
  /// ```
  bool? operator >=(num? other) => (this == null || other == null) ? null : this! >= other;
}

/// Provides functions for working with nullable [int]s, specifically their operator overloads which do not work with
/// the null-aware operator.
///
/// ## Note:
/// Chaining functions provided by this extension is not recommended in performance sensitive contexts due to the
/// repeated null checks with each function call.
extension NullableIntegers on int? {
  /// Returns the bitwise AND of this and [other], or `null` if either is `null`.
  ///
  /// ```dart
  /// int? foo(int? a, int? b) => a & b;
  ///
  /// foo(1, null); // null
  /// foo(1, 2); // 0
  /// ```
  int? operator &(int? other) => (this == null || other == null) ? null : this! & other;

  /// Returns the bitwise OR of this and [other], or `null` if either is `null`.
  ///
  /// ```dart
  /// int? foo(int? a, int? b) => a | b;
  ///
  /// foo(1, null); // null
  /// foo(1, 2); // 3
  /// ```
  int? operator |(int? other) => (this == null || other == null) ? null : this! | other;

  /// Returns the bitwise XOR of this and [other], or `null` if either is `null`.
  ///
  /// ```dart
  /// int? foo(int? a, int? b) => a ^ b;
  ///
  /// foo(1, null); // null
  /// foo(3, 5); // 6
  /// ```
  int? operator ^(int? other) => (this == null || other == null) ? null : this! ^ other;

  /// Returns the bitwise NOT of this, or `null` if this is `null`.
  ///
  /// ```dart
  /// int? foo(int? a) => ~a;
  ///
  /// foo(null); // null
  /// foo(1); // -2
  /// ```
  int? operator ~() => this == null ? null : ~this!;

  /// Shifts the bits of this integer to the left by [shiftAmount], or returns `null` if either is `null`.
  ///
  /// Shifting to the left makes the number larger, effectively multiplying the number by `pow(2, shiftAmount)`.
  ///
  /// There is no limit on the size of the result. It may be relevant to limit intermediate values by using the "and"
  /// operator with a suitable mask.
  ///
  /// ## Contract:
  /// Throws an error if [shiftAmount] is negative.
  ///
  /// ## Example:
  /// ```dart
  /// print((3 << 1).toRadixString(2)); // 0011 -> 0110
  /// print((9 << 2).toRadixString(2)); // 1001 -> 100100
  /// print((10 << 3).toRadixString(2)); // 1010 -> 1010000
  /// ```
  int? operator <<(int? shiftAmount) => (this == null || shiftAmount == null) ? null : this! << shiftAmount;

  /// Shifts the bits of this integer to the right by [shiftAmount], or returns `null` if either is `null`.
  ///
  /// Shifting to the right makes the number smaller and drops the least significant bits, effectively doing an integer
  /// division by `pow(2, shiftAmount)`.
  ///
  /// ## Contract:
  /// Throws an error if [shiftAmount] is negative.
  ///
  /// ## Example:
  /// ```dart
  /// print((3 >> 1).toRadixString(2)); // 0011 -> 0001
  /// print((9 >> 2).toRadixString(2)); // 1001 -> 0010
  /// print((10 >> 3).toRadixString(2)); // 1010 -> 0001
  /// print((-6 >> 2).toRadixString); // 111...1010 -> 111...1110 == -2
  /// print((-85 >> 3).toRadixString); // 111...10101011 -> 111...11110101 == -11
  /// ```
  int? operator >>(int? shiftAmount) => (this == null || shiftAmount == null) ? null : this! >> shiftAmount;

  /// Bitwise unsigned right shift by [shiftAmount] bits.
  ///
  /// The least significant [shiftAmount] bits are dropped, the remaining bits (if any) are shifted down, and zero-bits
  /// are shifted in as the new most significant bits.
  ///
  /// ## Contract:
  /// Throws an error if [shiftAmount] is negative.
  ///
  /// ## Example:
  /// ```dart
  /// print((3 >>> 1).toRadixString(2)); // 0011 -> 0001
  /// print((9 >>> 2).toRadixString(2)); // 1001 -> 0010
  /// print(((-9) >>> 2).toRadixString(2)); // 111...1011 -> 001...1110 (> 0)
  /// ```
  int? operator >>>(int? shiftAmount) => (this == null || shiftAmount == null) ? null : this! >> shiftAmount;

  /// Returns the sum of this and [other], or `null` if either is `null`.
  ///
  /// ```dart
  /// int? foo(int? a, int? b) => a + b;
  ///
  /// foo(1, null); // null
  /// foo(1, 2); // 3
  /// ```
  int? operator +(int? other) => (this == null || other == null) ? null : this! + other;

  /// Returns the difference of this and [other], or `null` if either is `null`.
  ///
  /// ```dart
  /// int? foo(int? a, int? b) => a - b;
  ///
  /// foo(1, null); // null
  /// foo(1, 2); // -1
  /// ```
  int? operator -(int? other) => (this == null || other == null) ? null : this! - other;

  /// Returns the product of this and [other], or `null` if either is `null`.
  ///
  /// ```dart
  /// int? foo(int? a, int? b) => a * b;
  ///
  /// foo(1, null); // null
  /// foo(1, 2); // 2
  /// ```
  int? operator *(int? other) => (this == null || other == null) ? null : this! * other;

  /// Returns the remainder of this divided by [other], or `null` if either is `null`.
  ///
  /// ```dart
  /// int? foo(int? a, int? b) => a % b;
  ///
  /// foo(1, null); // null
  /// foo(1, 2); // 1
  /// ```
  int? operator %(int? other) => (this == null || other == null) ? null : this! % other;

  /// Returns the negation of this, or `null` if this is `null`.
  ///
  /// ```dart
  /// int? foo(int? a) => -a;
  ///
  /// foo(null); // null
  /// foo(1); // -1
  /// ```
  int? operator -() => this == null ? null : -this!;
}

/// Provides functions for working with nullable [double]s, specifically their operator overloads which do not work with
/// the null-aware operator.
///
/// ## Note:
/// Chaining functions provided by this extension is not recommended in performance sensitive contexts due to the
/// repeated null checks with each function call.
extension NullableDoubles on double? {
  /// Returns the sum of this and [other], or `null` if either is `null`.
  ///
  /// ```dart
  /// double? foo(double? a, double? b) => a + b;
  ///
  /// foo(1.0, null); // null
  /// foo(1.0, 2.0); // 3.0
  /// ```
  double? operator +(double? other) => (this == null || other == null) ? null : this! + other;

  /// Returns the difference of this and [other], or `null` if either is `null`.
  ///
  /// ```dart
  /// double? foo(double? a, double? b) => a - b;
  ///
  /// foo(1.0, null); // null
  /// foo(1.0, 2.0); // -1.0
  /// ```
  double? operator -(double? other) => (this == null || other == null) ? null : this! - other;

  /// Returns the product of this and [other], or `null` if either is `null`.
  ///
  /// ```dart
  /// double? foo(double? a, double? b) => a * b;
  ///
  /// foo(1.0, null); // null
  /// foo(1.0, 2.0); // 2.0
  /// ```
  double? operator *(double? other) => (this == null || other == null) ? null : this! * other;

  /// Returns the remainder of this divided by [other], or `null` if either is `null`.
  ///
  /// ```dart
  /// double? foo(double? a, double? b) => a % b;
  ///
  /// foo(1.0, null); // null
  /// foo(1.0, 2.0); // 1.0
  /// ```
  double? operator %(double? other) => (this == null || other == null) ? null : this! % other;

  /// Returns the quotient of this divided by [other], or `null` if either is `null`.
  ///
  /// ```dart
  /// double? foo(double? a, double? b) => a / b;
  ///
  /// foo(1.0, null); // null
  /// foo(1.0, 2.0); // 0.5
  /// ```
  double? operator /(double? other) => (this == null || other == null) ? null : this! / other;

  /// Returns the integer quotient of this divided by [other], or `null` if either is `null`.
  ///
  /// ```dart
  /// double? foo(double? a, double? b) => a ~/ b;
  ///
  /// foo(1.0, null); // null
  /// foo(1.0, 2.0); // 0
  /// ```
  int? operator ~/(double? other) => (this == null || other == null) ? null : this! ~/ other;

  /// Returns the negation of this, or `null` if this is `null`.
  ///
  /// ```dart
  /// double? foo(double? a) => -a;
  ///
  /// foo(null); // null
  /// foo(1.0); // -1.0
  /// ```
  double? operator -() => this == null ? null : -this!;
}
