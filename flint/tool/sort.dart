import 'dart:io';

import 'environment.dart';

void main() {
  for (final file in Directory.fromUri(Uri.parse('$projectDirectory/lib')).listSync()) {
    if (file is File && file.path.endsWith('.yaml')) {
      sort(file);
    }
  }
}

void sort(File file) {
  final yaml = loadFile(file);
  final include = yaml['include'] as String?;
  final applied = <String>[...?yaml['linter']['rules']]..sort();
  final ignored = <String>[...?yaml['ignore']]..sort();

  file.writeAsStringSync('');

  if (include != null) {
    file.writeAsStringSync('include: $include\n', mode: FileMode.append);
  }

  if (applied.isNotEmpty) {
    file.writeAsStringSync('linter:\n  rules:', mode: FileMode.append);
    for (final rule in applied) {
      file.writeAsStringSync('\n    - $rule', mode: FileMode.append);
    }
  }

  if (ignored.isNotEmpty) {
    file.writeAsStringSync('\nignore:', mode: FileMode.append);
    for (final rule in ignored) {
      file.writeAsStringSync('\n  - $rule', mode: FileMode.append);
    }
  }
}
