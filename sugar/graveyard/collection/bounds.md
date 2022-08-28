## Bounds
Include bounds/ranges on iterables. This allows us to retrieve a section of the iterable which satisfy a condition, i.e. between two indexes or between lower and upper bound values.

```dart
[].between(1, and : 5);

['a', 'c', 'd', 'f', 'e'].between('c', 'e'); 
```

However, such functions can easily be replicated using current standard library functions.
```dart
[].skip(1).take(4);

['a', 'c', 'd', 'f', 'e'].where((val) => 'c' <= val && val <'e'); 
```

Perhaps bounds can be transformed into a predicate function.