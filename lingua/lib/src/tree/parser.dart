import 'dart:ui';

import 'package:meta/meta.dart';
import 'package:yaml/yaml.dart';

import 'package:lingua/src/tree/context.dart';
import 'package:lingua/src/tree/element.dart';
import 'package:lingua/src/tree/gender.dart';
import 'package:lingua/src/tree/normalization/identifier.dart';
import 'package:lingua/src/tree/normalization/normalizer.dart';
import 'package:lingua/src/tree/range/parser.dart' as expressions;

const _plural = r'$default';
const _gender = r'$others';

class Parser {

  final Normalizer _normalizer;
  final Set<String> errors = {};

  Parser(this._normalizer);


  Map<Locale, Element> parse(Map<Locale, YamlNode> locales) => {
    for (final entry in locales.entries)
      entry.key : element(Context.root(entry.key), entry.value)
  };


  Element element(Context context, YamlNode node) {
    if (node is !YamlMap) {
      errors.add('Value for ${context.location} should be a map');
      return MapElement(context.lexeme);
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
      errors.add('${context.location} should not contain both "$_plural" and "$_gender"');
      return MapElement(context.lexeme);
    }
  }


  @visibleForTesting
  MapElement map(Context context, YamlMap mapping) {
    final map = MapElement(context.lexeme);
    for (final entry in mapping.entries) {
      final current = context.descend(entry.key);

      if (entry.value is YamlNode) {
        _addChild(current, map, element(current, entry.value));

      } else if (entry.value is String) {
        _addChild(current, map, value(current, entry.value));

      } else {
        errors.add('${current.location} should contain either a map or string');
      }
    }

    return map;
  }

  void _addChild(Context context, MapElement map, Element child) {
    final key = _normalizer.normalize(context.lexeme);
    if (key == null) {
      return;
    }

    if (!map.children.containsKey(key)) {
      map.children[key] = child;

    } else {
      errors.add('Normalized key, "$key" for ${context.location} already exists');
    }
  }


  @visibleForTesting
  PluralElement plural(Context context, YamlMap map) {
    final plurals = PluralElement(context.lexeme, _default(context.descend(_plural), map[_plural]));
    for (final entry in map.entries) {
      if (entry.key == _plural) {
        continue;
      }

      final current = context.descend(entry.key);
      final expression = expressions.parse(current, expressions.lex(current, entry.key));

      if (expression is !String && entry.value is String) {
        plurals.children[expression] = value(current, entry.value);
        continue;
      }

      if (expression is String) {
        errors.add(expression);
      }

      if (entry.value is !String) {
        errors.add('Value for ${current.location} should be a string');
      }
    }

    return plurals;
  }

  ValueElement _default(Context context, dynamic value) {
    if (value is String) {
      return this.value(context, value);

    } else {
      errors.add('Value for ${context.location} should be a string');
      return ValueElement(_plural, '', []);
    }
  }


  @visibleForTesting
  GenderElement gender(Context context, YamlMap map) {
    final genders = GenderElement(context.lexeme);
    if (map.entries.length > 3) {
      errors.add('${context.location} has ${map.entries.length} fields, should not contain more than 3');
      return genders;
    }

    for (final entry in map.entries) {
      if (entry.value is !String) {
        errors.add('Value for ${context.descend(entry.key).location} should be a string');
        continue;
      }

      final gender = Genders.from(entry.key);
      final val = value(context.descend(entry.key), entry.value);
      if (gender != null) {
        genders.children[gender] = val;

      } else {
        errors.add('${context.descend(entry.key).location} should match "male", "female" or "$_gender"');
      }
    }

    return genders;
  }


  @visibleForTesting
  ValueElement value(Context context, String value) {
    final parameters = <String, String>{};

    for (final match in interpolation.allMatches(value)) {
      final literal = match[0];
      final parameter = literal.substring(3, literal.length - 2);

      if (identifier.matchAsPrefix(parameter) != null) {
        errors.add('"$literal" in $value for ${context.location} is not a valid Dart identifier');
        
      } else if (reserved.contains(parameter)) {
        errors.add('"$literal" in $value for ${context.location} should not be a reserved keyword');
        
      } else {
        parameters[literal] = parameter;
      }
    }

    for (final entry in parameters.entries) {
      value = value.replaceAll(entry.key, '\${${entry.value}}');
    }

    return ValueElement(context.lexeme, value, List.of(parameters.values));
  }

}