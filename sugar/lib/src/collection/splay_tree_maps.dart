import 'dart:collection';

extension SplayTreeMaps<K, V> on SplayTreeMap<K, V> {

  V? firstValueAfter(K key) => switch (firstKeyAfter(key)) {
    null => null,
    final key => this[key],
  };

  V? lastValueBefore(K key) => switch (lastKeyBefore(key)) {
    null => null,
    final key => this[key],
  };

}
