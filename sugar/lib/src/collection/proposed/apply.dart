extension ApplyIterables<E> on Iterable<E> {

  Apply<E, R> domain<R>(R Function(E) function) => Apply(this, function);

}

class Apply<E, R> {

  Iterable<E> iterable;
  R Function(E) function;

  Apply(this.iterable, this.function);

  Map<R, E> toMap() => { for (final e in iterable) function(e): e, };

}

class Foo {
  final String id = '';
}

void foo() {
  final items = [Foo()];
  items.codomain((e) => e.id).toMap();
  items.domain((e) => e.id).ascending;

  ['1', '3', '2'].domain(int.tryParse).toMap();
  ['1', '3', '2'].domain(int.tryParse).ascending;
}

