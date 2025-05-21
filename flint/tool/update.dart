import 'dart:io';

import 'package:html/parser.dart' show parse;
import 'package:http/http.dart';

import 'environment.dart';

Future<void> main() async => write(await process(await fetch()));

Future<Set<String>> fetch() async {
  print('Fetching lint rules from $remote.');

  final response = parse((await get(remote)).body);

  final rules = RegExp(r'<span[^>]*>(\w+)</span>')
      .allMatches(response.getElementsByTagName('code').last.innerHtml)
      .map((m) => m.group(1))
      .skip(1)
      .whereType<String>()
      .toSet();

  if (rules.isEmpty) {
    throw StateError('No rules found.');
  }

  return rules;
}

Future<(Set<String> released, Set<String> removed)> process(Set<String> remote) async {
  final existing = <String>{...rules['linter']['rules'], ...rules['ignore']};
  final released = <String>{};
  final experimental = <String>{};
  final removed = <String>{};

  print('Checking rules. This might take awhile.');
  for (final rule in remote) {
    print('https://dart.dev/tools/linter-rules/$rule');
    final response = await get(Uri.parse('https://dart.dev/tools/linter-rules/$rule'));
    if (response.statusCode == 404) {
      print('Warning: https://dart.dev/tools/linter-rules/$rule does not exist.');
      continue;
    }

    final content = parse(response.body)
        .getElementsByClassName('tags')[0]
        .text;

    if (existing.contains(rule) && (content.contains('Deprecated') || content.contains('Removed'))) {
      removed.add(rule);
    } else if (!existing.contains(rule) &&
        !content.contains('Experimental') &&
        !content.contains('Deprecated') &&
        !content.contains('Removed')) {
      released.add(rule);
    }
    if (!existing.contains(rule) && content.contains('experimental')) {
      experimental.add(rule);
    }
  }

  if (experimental.isNotEmpty) {
    print('The following rules are experimental:');
    for (final rule in experimental) {
      print('https://dart.dev/tools/linter-rules/$rule');
    }
  }

  return (released, removed);
}

void write((Set<String> released, Set<String> removed) rules) {
  final (Set<String> released, Set<String> removed) = rules;

  if (released.isNotEmpty) {
    print('The following rules are stable:');
    options.writeAsStringSync('\nreleased:\n', mode: FileMode.append);

    for (final rule in released) {
      print('https://dart.dev/tools/linter-rules/$rule');
      options.writeAsStringSync('  - $rule\n', mode: FileMode.append);
    }
  } else {
    print('No new stable lint rules released.');
  }

  if (removed.isNotEmpty) {
    print('The following rules have been removed:');
    options.writeAsStringSync('\nremoved:\n', mode: FileMode.append);

    for (final rule in removed) {
      print('https://dart.dev/tools/linter-rules/$rule');
      options.writeAsStringSync('  - $rule\n', mode: FileMode.append);
    }
  } else {
    print('No new lint rules removed.');
  }
}
