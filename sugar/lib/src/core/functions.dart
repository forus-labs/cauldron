typedef Call = void Function();
typedef Apply<T, R> = R Function(T);
typedef Consumer<T> = void Function(T);
typedef Predicate<T> = bool Function(T);
typedef Supplier<T> = T Function();

extension ComposableCall on Call {

  Call then(Call next) => () {
      this();
      next();
  };

}

extension ComposeableApply<T, R> on Apply<T, R> {

  Apply<T, R1> then<R1>(Apply<R, R1> next) => (value) => next(this(value));

  Consumer<T> pipe(Consumer<R> consumer) => (value) => consumer(this(value));

  Predicate<T> test(Predicate<R> predicate) => (value) => predicate(this(value));

}

extension ComposeableConsumer<T> on Consumer<T> {

   Consumer<T> then(Consumer<T> next) => (value) {
     this(value);
     next(value);
   };

}