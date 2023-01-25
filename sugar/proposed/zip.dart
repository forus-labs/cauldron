// Weak map

/// Retrieves the ongoing sessions.
// Future<List<FullTimedSession>> ongoing()  => _storage.transaction((transaction) async {
//   final details = await _sessions.queryOngoing(transaction);
//   final tags = await _sessionTags.queryTags(transaction, details.keys);
//   final slices = await _slices.queryWhere(transaction, sessions: details.keys);
//   return [
//     for (final id in details.keys)
//       FullTimedSession(details: details[id]!, tags: tags[id]!, slices: slices[id]!)
//   ];
// });
//
// class Foo {
//   Foo([int? a]);
// }
//
// void bar(Foo Function(int) a) {
//
// }
//
// void c() {
//   bar(Foo.new);
// }
//
//
//
// Future<dynamic> a() async {
//   final details = await _sessions.queryOngoing(transaction);
//   return combine3(
//     details,
//     await _sessionTags.queryTags(transaction, details.keys),
//     await _slices.queryWhere(transaction, sessions: details.keys),
//     FullTimedSession(details: details, tags: tags, slices: slices),
//   );
// }
//
// List<R> combine3<K, V1, V2, V3>(Map<K, V1> a, Map<K, V2> b, Map<K, V3> c, R Function(V1, V2, V3) combine) {
//
// }
//
//
// void a() {
//   final list = <int>[];
//   final map = list.derive<int, String>((s) => s.length, (n) => n.toString());
//
//   final map = <String, int>{};
//   final other = { for (final a in map.values) a.toString(): a.isEven, };
//   final aewfw = map.revalue((a) => a.isEven);
//
//
//
//   combine different maps of types.
//
// }

// lazy iterable

// cylic iterable
