import 'dart:io';

import 'package:html/parser.dart' show parse;
import 'package:http/http.dart';
import 'package:yaml/yaml.dart';

import 'environment.dart';

Future<void> main() async => write(await mature(changes(await fetch())).toSet());

Future<Set<String>> fetch() async {
  if (!temp.existsSync() || DateTime.now().difference(temp.lastModifiedSync()) > const Duration(days: 1)) {
    print('"all_rules.yaml" could not be found/is outdated, downloading from ${remote.toString()}');

    final response = await get(remote);
    temp..createSync(recursive: true)..writeAsStringSync(response.body);
  }

  return Set.from(loadFile(temp)['linter']['rules'] as YamlList);
}

Set<String> changes(Set<String> remote) => remote.difference(<String> {
  ...rules['linter']['rules'],
  ...rules['ignore'],
});

Stream<String> mature(Set<String> changes) async* {
  for (final change in changes) {
    final response = await get(Uri.parse('https://dart-lang.github.io/linter/lints/$change.html'));
    if (response.statusCode == 404) {
      print('Warning: https://dart-lang.github.io/linter/lints/$change.html does not exist (the rule might still be experimental)');
      return;
    }

    final header = parse(response.body).body?.getElementsByClassName('wrapper').first.getElementsByTagName('header').first;

    final stable = header?.getElementsByTagName('p')[1].innerHtml == 'Maturity: stable';
    final released = !header!.getElementsByClassName('tooltip').first.getElementsByTagName('p').first.innerHtml.contains('unreleased');

    if (stable && released) {
      yield change;
    }
  }
}

void write(Set<String> changes) {
  if (changes.isNotEmpty) {
    print('See https://dart-lang.github.io/linter/lints/ for more information on lints');

    options.writeAsStringSync('\nchanges:\n', mode: FileMode.append);
    for (final change in changes) {
      options.writeAsStringSync('  - $change\n', mode: FileMode.append);
    }

  } else {
    print('No changes to lints');
  }
}
