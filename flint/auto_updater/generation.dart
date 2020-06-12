import 'dart:io';

import 'package:yaml/yaml.dart';

import 'environment.dart';


Future<void> main() async => process(await fetchLintRules());


Future<YamlList> fetchLintRules() async {
  final file = File.fromUri(Uri.parse('$path/.temp/lint-rules.yaml'));
  if (!file.existsSync()) {
    final request = await HttpClient().getUrl(Uri.parse('https://raw.githubusercontent.com/dart-lang/linter/master/example/all.yaml'));
    final response = await request.close();

    file.createSync(recursive: true);

    await response.pipe(file.openWrite());
  }

  final contents = loadYamlDocument(file.readAsStringSync()).contents as YamlMap;
  return contents['linter']['rules'];
}


void process(YamlList all) {
  for (final folder in folders) {
    final environment = load(folder, 'analysis_options.yaml');
    write(folder, 'analysis_options.yaml', environment);
    write(folder, environment.inclusion.replaceAll(versionScheme, '.$version'), environment.parent);
  }
}


Environment load(String folder, String file) {
  final relativePath = 'lib/$folder/$file';
  final uri = Uri.parse('$path/$relativePath');

  final environment = environments[uri];
  if (environment != null) {
    return environment;
  }

  final contents = loadYamlFile(relativePath);
  final inclusion = contents['include'];
  final parent = inclusion != null ? load(folder, inclusion) : null;

  return Environment(
      parent,
      inclusion,
      <String>{...?contents['ignore'] as YamlList},
      <String>{
        // contents?['linter]?['rules] is not supported yet. Wait for NNBD to happen
        if (contents['linter'] != null && contents['linter']['rules'] != null)
          ...contents['linter']['rules'] as YamlList
      },
      versioned: file.contains(digit)
  );
}

void write(String folder, String file, Environment environment) {
  final out = File.fromUri(Uri.parse('$path/lib/$folder/$file'))..writeAsStringSync('');

  if (environment.inclusion != null) {
    out.writeAsStringSync('include: ${environment.inclusion.replaceAll(versionScheme, '.$version')}\n', mode: FileMode.append);
  }

  if (environment.ignore.isNotEmpty) {
    out.writeAsStringSync('ignore:\n');
    for (final rule in environment.ignore) {
      out.writeAsStringSync('  - $rule\n', mode: FileMode.append);
    }
  }

  if (environment.rules.isNotEmpty) {
    out.writeAsStringSync(
'''
linter:
  rules:
''', mode: FileMode.append);
    for (final rule in environment.rules) {
      out.writeAsStringSync('    - $rule\n', mode: FileMode.append);
    }
  }
}
