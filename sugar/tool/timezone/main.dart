import 'dart:io';
import 'package:path/path.dart';

import 'generate_location_mappings.dart';
import 'generate_locations.dart';
import 'irs.dart';

const zoneinfo = 'tool/timezone/zoneinfo/';
const destination = 'lib/src/time/zone/generated';

void main() {
  final namespace = RootNamespaceIR();
  traverse(Directory(zoneinfo), namespace);
  Locations.generate(namespace);
  LocationMappings.generate(namespace);
}

void traverse(Directory directory, NamespaceIR namespace) {
  for (final entity in directory.listSync()) {
    final path = relative(entity.path, from: zoneinfo).replaceAll(r'\', '/');
    final name = relative(entity.path, from: directory.path).replaceAll(r'\', '/');

    if (entity is File) {
      namespace.locations.add(LocationIR(path, entity));

    } else if (entity is Directory) {
      final child = NestedNamespaceIR(name);
      namespace.namespaces.add(child);
      traverse(entity, child);
    }
  }

  namespace.locations.sort((a, b) => a.location.name.compareTo(b.location.name));
  namespace.namespaces.sort((a, b) => a.name.compareTo(b.name));
}
