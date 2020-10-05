import 'package:meta/meta.dart';

import 'package:sugar/collection.dart';
import 'package:sugar/core.dart';

/// A skeleton to simplify implementation of symmetrical equality.
mixin Equality {

  @override
  bool operator == (dynamic other) => identical(this, other) || (runtimeType == other.runtimeType && fields.equals(other.fields));

  @override
  int get hashCode => hash(fields);


  @override
  String toString() => '$runtimeType(${fields.join(', ')})';


  /// The fields used to determine equality.
  @protected List<dynamic> get fields;

}