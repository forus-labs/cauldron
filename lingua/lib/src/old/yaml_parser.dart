import 'dart:ui';

import 'package:meta/meta.dart';
import 'package:yaml/yaml.dart';

import 'file:///C:/Users/Matthias/Documents/NetBeansProjects/cauldron/lingua/lib/src/old/element.dart';
import 'file:///C:/Users/Matthias/Documents/NetBeansProjects/cauldron/lingua/lib/src/old/identifier.dart';


final _range = RegExp(r'((\s*(<)|(<=)|(>=)|(>))?(\s*\d+(\.\d+)?)(\s*&&\s*((<)|(<=)|(>=)|(>))(\s*\d+(\.\d+)?))?)');
const _plural = r'$default';
const _gender = r'$others';


class YamlParser {

  Map<Locale, Element> parse(Map<Locale, YamlNode> locales) => {
    for (final entry in locales.entries)
      entry.key: element(Context(entry.key, '', ''), entry.value)
  };

  @visibleForTesting
  Element element(Context context, YamlNode node) {
    if (node is !YamlMap) {
      return ErrorElement(context.key, ['${context.message} is invalid, should be a map']);
    }

    final mapping = node as YamlMap;
    final plurals = mapping.containsKey(_plural);
    final genders = mapping.containsKey(_gender);

    if (!plurals && !genders) {
      return map(context, mapping);

    } else if (plurals && !genders) {
      return plural(context, mapping);

    } else if (!plurals && genders) {
      return gender(context, mapping);

    } else {
      return ErrorElement(context.key, ['${context.message} is invalid, cannot contain both "$_plural" and "$_gender"']);
    }
  }

  @visibleForTesting
  Element map(Context context, YamlMap mapping) {
    final map = MapElement(context.key, Type.map);
    for (final entry in mapping.entries) {
      if (entry.value is YamlNode) {
        map.children[entry.key] = element(context.descend(entry.key), entry.value);

      } else if (entry.value is String) {
        map.children[entry.key] = value(context.descend(entry.key), entry.value);

      } else {
        map.children[entry.key] = ErrorElement(context.key, ['${context.descend(entry.key).message} is invalid, should be either a map or string']);
      }
    }

    return map;
  }

  @visibleForTesting
  Element plural(Context context, YamlMap map) {
    final element = MapElement(context.key, Type.plural);

    for (final entry in map.entries) {
      if (entry.value is !String) {
         element.children[entry.key] = ErrorElement(entry.key, ['${context.descend(entry.key).message} is invalid, should contain only strings']);

      } else if (_range.stringMatch(entry.key) == entry.key) {
        element.children[entry.key] = value(context.descend(entry.key), entry.value);
      }
    }

    return element;
  }

  @visibleForTesting
  Element gender(Context context, YamlMap map) {
    if (map.keys.length > 3) {
      return ErrorElement(context.key, ['${context.message} is invalid, should not contain more than 3 fields']);
    }
    
    final element = MapElement(context.key, Type.gender);
    for (final entry in map.entries) {
      if (entry.value is !String) {
        element.children[entry.key] = ErrorElement(context.key, ['${context.message} is invalid, should be string']);
        continue;
      }

      switch (entry.key) {
        case 'male':
        case 'female':
        case _gender:
          element.children[entry.key] = value(context.descend(entry.key), entry.value);
          break;

        default:
          element.children[entry.key] = ErrorElement(context.key, ['${context.descend(entry.key).message} is invalid, key should match "male", "female" or "$_gender"']);
      }
    }

    return element;
  }

  @visibleForTesting
  Element value(Context context, String value) {
    final variables = <String>{};
    final errors = <String>[];

    for (final match in interpolation.allMatches(value)) {
      final literal = match.group(0);
      final name = literal.substring(2, literal.length);

      if (identifier.matchAsPrefix(name) == null) {
        errors.add('"$literal" in ${context.message} is invalid, should be a valid Dart identifier');

      } else if (keywords.contains(name)) {
        errors.add('"$literal" in ${context.message} is invalid, should not be a reserved keyword');

      } else {
        variables.add(name);
      }
    }

    return errors.isEmpty ? ValueElement(context.key, value, variables) : ErrorElement(context.key, errors);
  }

}

class Context {

  final Locale locale;
  final String path;
  final String key;

  Context(this.locale, this.path, this.key);

  Context descend(String key) => Context(locale, '${path.isEmpty ? '' : '$path.'}$key', key);

  String get message => '${path.isEmpty ? 'Root' : '"$path"'} in ${locale.toLanguageTag()}.yaml';

}