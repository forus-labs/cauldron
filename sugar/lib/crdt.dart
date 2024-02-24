/// {@category collection}
///
/// Utilities for building and working with CRDTs (Conflict-free Replicated Data Types).
///
/// This includes:
/// * [Sil], a sequence CRDT for unique elements.
library sugar.crdt;

import 'package:sugar/crdt.dart';

export 'src/crdt/sil.dart';
export 'src/crdt/string_index.dart';
