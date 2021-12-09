import 'package:meta/meta.dart';
import 'package:sugar/collection.dart';

/// A skeleton to simplify implementation of symmetrical equality.
mixin Equality {

  @override
  bool operator == (dynamic other) => identical(this, other) || (runtimeType == other.runtimeType && fields.equals(other.fields)); // ignore: avoid_dynamic_calls

  @override
  int get hashCode => Object.hashAll(fields);

  @override
  String toString() => '$runtimeType(${fields.join(', ')})';

  /// The fields used to determine equality.
  @protected List<dynamic> get fields;

}
