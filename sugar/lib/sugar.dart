/// {@category Sugar}
///
/// Aggregates and exports all other libraries.
///
/// All libraries are aggregated and exported so that they can be imported in a single line:
/// ```dart
/// import 'package:sugar/sugar.dart';
/// ````
///
/// It is recommended to treat this library as an index and browse through the individual libraries. Trying to understand
/// the package using this library can be overwhelming.
library sugar;

export 'collection.dart';
export 'collection_aggregate.dart';
export 'core.dart';
export 'core_range.dart';
export 'core_runtime.dart';
export 'math.dart';
export 'time.dart';
export 'time_interop.dart';
export 'time_zone.dart';
