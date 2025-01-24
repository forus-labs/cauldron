/// {@category Collection}
///
/// Utilities for aggregating and sorting collections.
///
/// This includes:
/// * Grouping a collection's elements such as [Group.lists].
/// * Sorting a collection's elements such as [Order.ascending].
/// * Splitting a collection into parts such as [Split.window].
///
/// Most functions in this library produce a new collection rather than modify the collection in-place.
///
/// See `sugar.collection` for other non-aggregating collection utilities.
library;

import 'package:sugar/src/collection/aggregate/group_iterables.dart';
import 'package:sugar/src/collection/aggregate/order_iterables.dart';
import 'package:sugar/src/collection/aggregate/split_iterables.dart';

export 'src/collection/aggregate/aggregate_iterables.dart';
export 'src/collection/aggregate/group_iterables.dart';
export 'src/collection/aggregate/order_iterables.dart';
export 'src/collection/aggregate/split_iterables.dart';
