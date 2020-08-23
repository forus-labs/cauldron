mixin Relational<T extends Relational<T>> implements Comparable<T> {

  @override
  bool operator == (dynamic other) => other is T && compareTo(other) == 0;

  bool operator < (T other) => compareTo(other) < 0;

  bool operator > (T other) => other < this;

  bool operator <= (T other) => !(this > other);

  bool operator >= (T other) => !(this < other);

  @override
  int get hashCode => hash;

  int get hash;

}
