import 'package:meta/meta.dart';

import 'package:sugar/collection.dart';
import 'package:sugar/core.dart';

mixin Equality {

  @override
  bool operator == (dynamic other) => identical(this, other) || (other.subclassOf(this) && fields.equals(other.fields));

  @override
  int get hashCode => hash(fields);

  @override
  String toString() => '$runtimeType(${fields.join(', ')})';


  @protected List<dynamic> get fields;

}