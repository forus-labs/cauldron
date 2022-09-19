import 'package:sugar/core.dart';

mixin Result<T, E> {
  
  Value<T> get success;

  Value<E> get failure;

}

class _Success<T, E> extends Value<T> with Result<T, E> {

  @override
  // TODO: implement success
  Value<T> get success => this;

  @override
  // TODO: implement failure
  Value<E> get failure => throw UnimplementedError();

}



void a(Result<String, F> result) {
  final success = result.success;
  if (success()) {
    success.infallible();
  }

  final a = result.success.nullable ?? '';
}




abstract class Value<T> {

  final T _value;
  final bool _exists;

  const Value._(this._value, this._exists);

  @override
  bool call() => _exists;



  @Possible({StateError})
  T unwrap() => _exists ? _value : throw StateError('');

}

extension NullableValue<T extends Object> on Value<T> {

  @Possible({StateError})
  T? get nullable => _value;

}