// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;

void main(List<String> args) async {
  final javaHome = Platform.environment['JAVA_HOME'];
  if (javaHome == null) {
    print('JAVA_HOME is not set');
    exit(1);
  }

  if (Platform.isWindows) {
    final result = Process.runSync('which', ['jvm.dll'], runInShell: true);
    if (result.exitCode != 0) {
      print(r'Make sure that $JAVA_HOME\bin\server\jvm.dll is in your PATH');
      exit(1);
    }
  }

  final javaDir = Directory(javaHome);
  if (!javaDir.existsSync()) {
    print('$javaHome is not am existing directory');
    exit(1);
  }
  if (p.basename(Directory.current.path) != 'sugar') {
    print('This script should be run from the root of the sugar project');
    exit(1);
  }

  if (!args.contains('--skip-java')) {
    final setupJni = Process.runSync(
      'dart',
      ['run', 'jni:setup'],
      runInShell: true,
    );
    if (setupJni.exitCode != 0) {
      print('Failed to run `dart run jni:setup`');
      print(setupJni.stdout);
      print(setupJni.stderr);
      exit(1);
    }

    final updateTzdb = Process.runSync(
      'java',
      ['-jar', 'tool/tzupdater.jar', '-f'],
      runInShell: true,
    );
    if (updateTzdb.exitCode != 0) {
      print('Failed to update the timezone database');
      print(updateTzdb.stdout);
      print(updateTzdb.stderr);
      exit(1);
    }
  }

  final nodeCheckResult = Process.runSync('node', ['-v'], runInShell: true);
  if (nodeCheckResult.exitCode != 0) {
    print('Node.js is not installed');
    print(nodeCheckResult.stdout);
    print(nodeCheckResult.stderr);
    exit(1);
  }
  final npmCheckResult = Process.runSync('npm', ['-v'], runInShell: true);
  if (npmCheckResult.exitCode != 0) {
    print('npm is not installed');
    print(npmCheckResult.stdout);
    print(npmCheckResult.stderr);
    exit(1);
  }
  final installTubular = Process.runSync(
    'npm',
    ['install', '-g', '@tubular/time-tzdb@1'],
    runInShell: true,
  );
  if (installTubular.exitCode != 0) {
    print('Failed to install @tubular/time-tzdb');
    print(installTubular.stdout);
    print(installTubular.stderr);
    exit(1);
  }

  final timezoneDatabaseLocation = p.join(
    Directory.systemTemp.path,
    'timezone.json',
  );
  final generateTubular = Process.runSync(
    'npx',
    ['tzc', '--large', timezoneDatabaseLocation, '-o'],
    runInShell: true,
  );
  if (generateTubular.exitCode != 0) {
    print('Failed to generate Tubular timezone database');
    print(generateTubular.stdout);
    print(generateTubular.stderr);
    exit(1);
  }
  final timezoneContent = File(timezoneDatabaseLocation).readAsStringSync();

  final tzDb = jsonDecode(timezoneContent) as Map<String, dynamic>;
  if (tzDb['version'] != '2025a') {
    print('The timezone database is not up to date');
    exit(1);
  }
  // Remove metadata from the timezone database
  tzDb.removeWhere((key, value) => !_isTimezoneId(key));
  // The timezone database uses aliases for some timezones
  // For instance "Africa/Porto-Novo" is an alias for "Africa/Lagos"
  // Some of these aliases have extra metadata that needs to be removed
  for (final id in tzDb.keys) {
    final data = tzDb[id] as String;
    if (!RegExp('^[+-]').hasMatch(data)) {
      // Clean up the alias name
      final aliasName = data.replaceAll(RegExp('^!'), '').split(',').last;
      tzDb[id] = aliasName;
    }
  }

  final content = '''
// ignore_for_file: prefer_single_quotes
part of 'tzdb.dart';

/// The timezone database.
const _tzdb = ${jsonEncode(tzDb)};
''';
  File(p.join(
    Directory.current.path,
    'lib',
    'src',
    'time',
    'zone',
    'providers',
    'universal',
    'tzdb.g.dart',
  ))
    ..createSync()
    ..writeAsStringSync(content);

  print('Success');
}

/// Check if a key in the timezone database is an
/// actual timezone or just metadata.
bool _isTimezoneId(String key) => [
      RegExp('^years'),
      RegExp('^version'),
      RegExp('^leapSeconds'),
      RegExp('^deltaTs'),
      RegExp('^_'),
      RegExp('^SystemV/'),
    ].every((k) => !k.hasMatch(key));
