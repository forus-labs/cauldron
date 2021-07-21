import 'dart:math';

/// Represents a capped exponential back-off in milliseconds with jittering.
///
/// The jittered back-off is always between half of the maximum possible timeout
/// for the current number of failed tries and the maximum possible timeout.
///
/// It is possible for the debounce value to overflow. [Debounce] handles on integer
/// overflows on a best-effort basis.
class Debounce {

  static final Random _random = Random();

  /// The initial value.
  final int initial;
  /// The capped duration that
  final int cap;
  int _expiry = 0;
  int _tries = 0;

  /// Creates a [Debounce] with the given initial value and cap. Both the initial
  /// value and cap should be milliseconds greater than 0.
  Debounce({required this.initial, required this.cap}):
      assert(initial <= cap, 'Initial value ($initial) should be <= cap ($cap)'),
      assert(initial > 0, 'Initial value ($initial) should be > 0'),
      assert(cap <= 8589934592, 'Cap ($cap) should be <= (2^32) * 2');

  /// Signals that all future operations until a certain time should be cancelled.
  void debounce() {
    _tries++;
    final half = timeout ~/ 2;
    _expiry = DateTime.now().millisecondsSinceEpoch + _random.nextInt(max(1, half)) + half;
  }

  /// Clears this [Debounce].
  void clear() => _tries = 0;

  /// Returns whether this [Debounce] is still pending.
  bool get pending => DateTime.now().millisecondsSinceEpoch < _expiry;

  /// Returns the maximum possible timeout (in milliseconds) for the current number of failed tries.
  int get timeout {
    final period = pow(initial, _tries) as int;
    return period.isNegative ? cap : min(period, cap);
  }

  /// Returns the number of failed tries.
  int get tries => _tries;

}