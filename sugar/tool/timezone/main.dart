import 'dart:io';
import 'package:path/path.dart';

import 'generate_library.dart';
import 'generate_location_mappings.dart';
import 'generate_locations.dart';
import 'irs.dart';

const zoneinfo = 'tool/timezone/zoneinfo/';
const _whitelist = {
  'Cuba',
  'Egypt',
  'Eire',
  'Factory',
  'GB',
  'GB-Eire',
  'Hongkong',
  'Iceland',
  'Iran',
  'Israel',
  'Jamaica',
  'Japan',
  'Kwajalein',
  'Libya',
  'Navajo',
  'NZ',
  'NZ-CHAT',
  'Poland',
  'Portugal',
  'PRC',
  'ROC',
  'ROK',
  'Singapore',
  'Turkey',
  'Zulu',
};

void main() {
  final namespace = RootNamespaceIR();
  traverse(Directory(zoneinfo), namespace, _whitelist);
  LocationsLibrary.generate(namespace);
  Locations.generate(namespace);
  LocationMappings.generate(namespace);
}

void traverse(Directory directory, NamespaceIR namespace, Set<String>? whitelist) {
  for (final entity in directory.listSync()) {
    final path = relative(entity.path, from: zoneinfo).replaceAll(r'\', '/');
    final name = relative(entity.path, from: directory.path).replaceAll(r'\', '/');

    if (entity is File && (whitelist?.contains(name) ?? true)) {
      namespace.locations.add(LocationIR(path, entity));

    } else if (entity is Directory) {
      final child = NestedNamespaceIR(name);
      namespace.namespaces.add(child);
      traverse(entity, child, null);
    }
  }

  namespace.locations.sort((a, b) => a.location.name.compareTo(b.location.name));
  namespace.namespaces.sort((a, b) => a.name.compareTo(b.name));
}
