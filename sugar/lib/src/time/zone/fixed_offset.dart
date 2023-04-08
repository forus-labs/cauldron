import 'package:sugar/src/time/offset.dart';
import 'package:sugar/src/time/convert.dart';
import 'package:sugar/time_zone.dart';

/// A [Timezone] that represents a fixed offset from UTC/Greenwich. It is immutable and should be treated as a value-type.
class FixedOffset implements Timezone {

  final Offset _offset;

  /// Creates a [FixedOffset].
  FixedOffset(this._offset);

  @override
  Offset offset({required EpochSeconds at}) => _offset;

  @override
  bool operator ==(Object other) => identical(this, other) || other is FixedOffset && runtimeType == other.runtimeType && _offset == other._offset;

  @override
  int get hashCode => _offset.hashCode;

  /// Returns its offset ID, a minor variation of an ISO-8601 formatted offset string, described in  [Offset.toString].
  ///
  /// ```dart
  /// const timezone = FixedOffset(Offset());
  /// print(timezone.toString()); // 'Z'
  /// ```
  @override
  String toString() => _offset.toString();

}
