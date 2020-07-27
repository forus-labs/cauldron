import 'dart:io';

import 'package:yaml/yaml.dart';

import 'environment.dart';


Future<void> main() async => write(changeset(await fetch()));

Future<Set<String>> fetch() async {
  if (!temp.existsSync()) {
    final response = await (await HttpClient().getUrl(remote)).close();
    await response.pipe((temp..createSync(recursive: true)).openWrite());
  }

  return Set.from(loadFile(temp)['linter']['rules'] as YamlList);
}

Set<String> changeset(Set<String> remote) => remote.difference(<String> {
  ...rules['linter']['rules'],
  ...rules['ignore'],
  ...?rules['unreleased'],
});

void write(Set<String> changes) {
  if (changes.isNotEmpty) {
    options.writeAsStringSync('\nchanges:\n', mode: FileMode.append);
    for (final change in changes) {
      options.writeAsStringSync('  - $change\n', mode: FileMode.append);
    }
  }
}