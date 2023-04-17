import 'package:sugar/time.dart';

/// Represents a timezone in the IANA timezone database with a single, fixed offset.
///
/// ### Implementation details:
/// Timezones with varying offset are handled by [DynamicTimezone]. This simplifies offset look-up & improves performance.
class FixedTimezone implements TimezoneRules {

  final String _name;
  final Offset _offset;
  final String _abbreviation;
  final bool _dst;

  /// Creates a [FixedTimezone].
  const FixedTimezone(this._name, this._offset, this._abbreviation, {bool dst = false}): _dst = dst;

  @override
  EpochMilliseconds convert(EpochMilliseconds local) => local + _offset.toMilliseconds();


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is FixedTimezone && runtimeType == other.runtimeType && _name == other._name && _offset == other._offset;

  @override
  int get hashCode => _name.hashCode ^ _offset.hashCode;

  @override
  String toString() => _name;

}
