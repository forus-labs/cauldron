## Combinations
    
Combine multiple maps/lists together to form a new value. It is supposed to transform imperative code into declarative code.

For example, the following code snippet:
```dart
/// Retrieves the ongoing sessions.
Future<List<FullTimedSession>> ongoing()  => _storage.transaction((transaction) async {
  final details = await _sessions.queryOngoing(transaction);
  final tags = await _sessionTags.queryTags(transaction, details.keys);
  final slices = await _slices.queryWhere(transaction, sessions: details.keys);
  return [
    for (final id in details.keys)
      FullTimedSession(details: details[id]!, tags: tags[id]!, slices: slices[id]!)
  ];
});
```

Should be transformed into:
```dart
Map<K, Val> foo() => Combine.three(
    await _sessions.queryOngoing(transaction),
    await _sessionTags.queryTags(transaction, details.keys),
    await _slices.queryWhere(transaction, sessions: details.keys)
  ).defaults(
    (key) => val,
    (key) => val,
    (key) => val,
  )((a, b, c) => Val(a, b, c));
```

However, it had the opposite of the intended effect. It becomes harder to understand & write and more verbose. Not to mention,
implementation would have been difficult due to the number of possibilities with the arguments, i.e. `Combine.one(...)`, `Combine.two(...)`.
It was also hard to define which map to iterate over and what to do in the absence of values.

All in all, it was a negative in almost all aspects.