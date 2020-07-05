import 'dart:ui';

import 'package:meta/meta.dart';
import 'package:yaml/yaml.dart';

import 'package:lingua/src/tree/element.dart';
import 'package:lingua/src/tree/parser/identifier.dart';


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
      return ErrorElement('${context.message} is invalid, should be a map');
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
      return ErrorElement('${context.message} is invalid, cannot contain both "$_plural" and "$_gender"');
    }
  }

  @visibleForTesting
  Element map(Context context, YamlMap mapping) {
    final map = MapElement(Type.map);
    for (final entry in mapping.entries) {
      if (entry.value is YamlNode) {
        map.children[entry.key] = element(context.descend(entry.key), entry.value);

      } else if (entry.value is String) {
        map.children[entry.key] = value(context.descend(entry.key), entry.value);

      } else {
        map.children[entry.key] = ErrorElement('${context.descend(entry.key).message} is invalid, should be either a map or string');
      }
    }

    return map;
  }

  @visibleForTesting
  Element plural(Context context, YamlMap map) {
    final element = MapElement(Type.plural);

    for (final entry in map.entries) {
      if (entry.value is !String) {
         element.children[entry.key] = ErrorElement('${context.descend(entry.key).message} is invalid, should contain only strings');

      } else if (_range.stringMatch(entry.key) == entry.key) {
        element.children[entry.key] = value(context.descend(entry.key), entry.value);
      }
    }

    return element;
  }

  @visibleForTesting
  Element gender(Context context, YamlMap map) {
    if (map.keys.length > 3) {
      return ErrorElement('${context.message} is invalid, should not contain more than 3 fields');
    }
    
    final element = MapElement(Type.gender);
    for (final entry in map.entries) {
      if (entry.value is !String) {
        element.children[entry.key] = ErrorElement('${context.message} is invalid, should be string');
        continue;
      }

      switch (entry.key) {
        case 'male':
        case 'female':
        case _gender:
          element.children[entry.key] = value(context.descend(entry.key), entry.value);
          break;

        default:
          element.children[entry.key] = ErrorElement('${context.descend(entry.key).message} is invalid, key should match "male", "female" or "$_gender"');
      }
    }

    return element;
  }

  @visibleForTesting
  Element value(Context context, String value) {
    final variables = <String>{};
    final errors = <String>{};

    for (final match in identifier.allMatches(value)) {
      final raw = match.group(0);
      final argument = raw.substring(2, raw.length);

      keywords.contains(argument) ? errors.add(raw) : variables.add(argument);
    }

    if (errors.isEmpty) {
      return ValueElement(value, variables);

    } else {
      return ErrorElement('"${errors.join('", "')}" in ${context.message} ${errors.length <= 1 ? 'is' : 'are'} invalid, should not be a reserved keyword');
    }
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