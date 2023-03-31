import 'dart:io';

import 'package:sugar/core.dart';
import 'package:sugar/src/time/offset.dart';
import 'package:timezone/tzdata.dart';

/// An intermediate representation of a namespace.
abstract class NamespaceIR {

  /// The nested namespaces.
  final List<NestedNamespaceIR> namespaces = [];
  /// The locations.
  final List<LocationIR> locations = [];

}

/// An intermediate representation of a root namespace.
class RootNamespaceIR extends NamespaceIR {

  String toImport() => "import 'package:sugar/src/time/zone/locations.g.dart';";

  StringBuffer toExtension() => StringBuffer()
    ..writeln('/// Provides type-safe access to [Location]s in the TZ database.')
    ..writeln('/// ')
    ..writeln('/// For example, to access the `Asia/Singapore` location:')
    ..writeln('/// ```dart')
    ..writeln('/// final singapore = Locations.asia.singapore;')
    ..writeln('/// ```')
    ..writeln('/// ')
    ..writeln('/// To access a [Location] based on a string representation of its name, consider using [Location.parse] instead.')
    ..writeln('extension Locations on Never {')
    ..writeln(_staticNestedNamespaceGetters)
    ..writeln(_staticLocationFields)
    ..writeln('}\n');

  StringBuffer get _staticLocationFields {
    final buffer = StringBuffer();
    for (final location in locations) {
      buffer.writeln('  static final Location ${location.variableName} = ${location.toConstructor(4)}\n');
    }

    return buffer;
  }

  StringBuffer get _staticNestedNamespaceGetters {
    final buffer = StringBuffer();
    for (final namespace in namespaces) {
      buffer..writeln('  /// The locations in `${namespace.name}`.')
        ..writeln('  static ${namespace.typeName} get ${namespace.variableName} => const ${namespace.typeName}();\n');
    }

    return buffer;
  }

}

/// An intermediate representation of a nested namespace.
class NestedNamespaceIR extends NamespaceIR {

  /// The name.
  final String name;
  /// The namespace in pascal case, i.e. `Asia` will be `Asia`.
  final String typeName;
  /// The namespace in camel case, i.e. `Asia` will be `asia`.
  final String variableName;

  NestedNamespaceIR(this.name):
    typeName = name.toPascalCase(),
    variableName = name.toEscapedCamelCase();


  String toPackagePath() => 'package:sugar/src/time/zone/locations/${name.toSnakeCase()}.g.dart';

  StringBuffer toClass() => StringBuffer()
    ..writeln('/// A namespace that contains [Location]s and nested namespaces in `$name`.')
    ..writeln('/// ')
    ..writeln('/// See [Location]s for more information.')
    ..writeln('class $typeName {\n')
    ..writeln(_constructor)
    ..writeln(_nestedNamespaceGetters)
    ..writeln(_locationGetters)
    ..writeln(_staticLocationFields)
    ..writeln('}\n');

  StringBuffer get _staticLocationFields {
    final buffer = StringBuffer();
    for (final location in locations) {
      buffer.writeln('  static final Location _${location.variableName} = ${location.toConstructor(4)}\n');
    }

    return buffer;
  }

  String get _constructor => '  const $typeName();\n';

  StringBuffer get _nestedNamespaceGetters {
    final buffer = StringBuffer();

    for (final namespace in namespaces) {
      buffer..writeln('  /// The locations in `${namespace.name}`.')
            ..writeln('  ${namespace.typeName} get ${namespace.variableName} => const ${namespace.typeName}();\n');
    }

    return buffer;
  }

  StringBuffer get _locationGetters {
    final buffer = StringBuffer();
    for (final location in locations) {
      buffer..writeln('  /// A [Location] that represents `${location.location.name}`.')
            ..writeln('  Location get ${location.variableName} => $typeName._${location.variableName};\n');
    }

    return buffer;
  }

}

/// An intermediate representation of a location.
class LocationIR {

  /// The location derived from the corresponding zic compiled file.
  final Location location;
  /// The location's name in camel case, i.e. `Asia/Singapore` will be renamed as `singapore`.
  final String variableName;

  LocationIR(String path, File file):
    location = Location.fromBytes(path, file.readAsBytesSync()),
    variableName = path.split('/').last.toEscapedCamelCase();


  StringBuffer toConstructor(int indentation) => StringBuffer('Location(\n')
      ..writeIndented(indentation, "'${location.name}',\n")
      ..writeIndented(indentation, '[${location.transitionAt.join(', ')}],\n')
      ..writeIndented(indentation, '${_timezones(indentation)},\n')
      ..writeIndented(indentation - 2, ');');

  StringBuffer _timezones(int indentation) {
    final buffer = StringBuffer('const [\n');

    for (int i = 0; i < location.transitionAt.length; i++) {
      final zone = location.zones[location.transitionZone[i]];
      final offset = "Timezone(RawOffset('${format(zone.offset)}', ${zone.offset}), abbreviation: '${location.abbreviations[zone.abbreviationIndex]}', dst: ${zone.isDst})";
      buffer.writeIndented(indentation + 2, '$offset,\n');
    }

    return buffer..writeIndented(indentation, ']');
  }

}


extension on String {

  static final separators = RegExp(r'((\s|_|/)+)|(?<=[a-z])(?=[A-Z])|(?<=[A-Z])(?=[A-Z][a-z])');

  String toEscapedCamelCase() => replaceAll(RegExp(r'-(?=\D)'), '_')
      .replaceAll(RegExp(r'-(?=\d)'), 'Minus')
      .replaceAll(RegExp(r'\+(?=\d)'), 'Plus')
      .toCamelCase(separators);

}
