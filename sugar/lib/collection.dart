/// {@category Collection}
///
/// Non-aggregating utilities for working with Dart's collections.
///
/// This includes:
/// * Bulk operations such as [Lists.removeAll].
/// * Functions for creating a collection from another such as [Iterables.toUnmodifiableList].
/// * Functions for working nullable elements such as [NonNullableList.addIfNonNull].
/// * Move operations that move elements between collections such as [MovableList.move].
///
/// See `sugar.collection.aggregate` for aggregation related utilities.
library sugar.collection;

import 'package:sugar/src/collection/iterables.dart';
import 'package:sugar/src/collection/lists.dart';
import 'package:sugar/src/collection/move.dart';

export 'src/collection/algorithms.dart';
export 'src/collection/iterables.dart';
export 'src/collection/lists.dart';
export 'src/collection/maps.dart';
export 'src/collection/move.dart';
export 'src/collection/sets.dart';
