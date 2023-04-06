import 'package:meta/meta.dart';
import 'package:sugar/core.dart';

/// The range of integers on the VM  platform.
@internal final Interval<int> platformRange = Interval.closed(-9223372036854775808, 9223372036854775807);