import 'dart:io';
import 'package:path/path.dart';

import 'irs.dart';
import 'posix_timezones.dart';
import 'timezones.dart';
import 'zoneinfo.dart';

const zoneinfo = 'tool/timezone/zoneinfo/';

void main() {
  final namespace = NamespaceIR('root');
  traverse(Directory(zoneinfo), namespace);
  ZoneInfo.generate(namespace);
  Timezones.generate(namespace);
  PosixTimezones.generate(namespace);
}

void traverse(Directory directory, NamespaceIR namespace) {
  for (final entity in directory.listSync()) {
    final path = relative(entity.path, from: zoneinfo).replaceAll(r'\', '/');
    final name = relative(entity.path, from: directory.path).replaceAll(r'\', '/');

    if (entity is File) {
      namespace.timezones.add(TimezoneIR(path, entity));
    } else if (entity is Directory) {
      final child = NamespaceIR(name);
      namespace.namespaces.add(child);
      traverse(entity, child);
    }
  }

  namespace.timezones.sort((a, b) => a.location.name.compareTo(b.location.name));
  namespace.namespaces.sort((a, b) => a.name.compareTo(b.name));
}
