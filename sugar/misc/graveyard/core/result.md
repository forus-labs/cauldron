# Result implementations

We went through several implementations of `Result` before arriving at the current iteration. This document outlines the
approaches that failed and why they failed.

One of the issues with `Result` was the possibility of either two values. This meant that we needed two variants of each
proposed method on Result. One for when `Result` was a success and another for failure. Our intention was to limit the 
API surface as much as possible/improve ergonomics.

## Combining two variants as one

In this iteration, we combined handling of both success and failure into a single method via parameters. For example:
```dart
abstract class Result<S, F> {
  
  Result<S1, F1> map<S1, F1>({S1 Function(S)? success, F1 Function(F)? failure});
  
}
```

Although this approach omitted the need for variants, it greatly affected usability. This was caused by the need to always
declare the generic type parameters when calling the method, otherwise the type will be inferrable and fallback to `dynamic`.
This is fine if the type names are short, however, it can greatly impend readability when the type names are long and/or
chaining multiple successive calls on a `Result`.

```dart
void foo(Result<String, int> result) {
  final typed = result.map<int, int>(success: (string) => 1);
  final untyped = result.map(success: (string) => 1); // untyped will be inferred as Result<int, dynamic>();
}
```

Furthermore, it is easy to forget about specifying the type parameters.

## Namespacing variants

In this iteration, method variants for transforming the `Result` are moved into the wrappers for `success` and `failure`.
For example:
```dart
abstract class Result<S, F> {
  
  SuccessValue<S> get success;
  
  FailureValue<F> get failure;
  
}

abstract class SuccessValue<S, F> {
  
  Result<S1, F> map<S1>(S1 Function(S) function);
  
}

abstract class FailureValue<S, F> {

  Result<S, F1> map<F1>(F1 Function(F) function);

}
```

In theory, this seemed like a promising concept. However, implementation proved to be (unnecessary) complex and long. 
This was caused by `SuccessValue` and `FailureValue`, which is nested in `Result`, requiring access to the other value. 

More importantly, accessing the methods felt unintuitive. It is contrary to expectations that methods for transforming 
the `Result` will be in the value monads. In the value monads, we expect methods for transforming the values themselves, 
not the `Result`. This caused transforming a `Result` to be confusing as well.

```dart
void foo(Result<String, int> result) {
  final value = result.success.map((string) => 1); // Are we mapping the result or the value?
  print(value); // value is actually a Result<int, int>();
}
```

## Preserving two variants (Current implementation)

Our current implementation preserves the two method variants. Method variants for failures are simply suffixed with `Failure`.
This changed in decision stemmed from our observations that in most cases, we are only interested in transforming the value
of a success. It is rare to want to transform a failure. Hence, leaving a hatch to transform failures while suffixing the
method variants with `Failure` is fine.


