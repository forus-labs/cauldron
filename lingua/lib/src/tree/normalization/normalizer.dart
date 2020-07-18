import 'package:meta/meta.dart';

import 'package:lingua/src/tree/normalization/identifier.dart';

final _separator = RegExp(r'(\s|-|_|\.)+');

class Normalizer {

  final _buffer = StringBuffer();


  String normalize(String name) {
    final normalized = camelCase(name);
    return isIdentifier(normalized) ? normalized : null;
  }

  @visibleForTesting
  String camelCase(String name) {
    _buffer.clear();
    for (final part in name.trim().split(_separator)) {
      _buffer.write(part[0].toUpperCase());
      if (part.length > 1) {
        _buffer.write(part.substring(1, part.length));
      }
    }

    return _buffer.toString();
  }

}