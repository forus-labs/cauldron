import 'dart:io';
import 'dart:math';

import 'package:stevia_runner/src/ansi.dart';

void push() {
  const max = 3;
  final random = Random();

  for (int i = 1; i < max; i++) {
    print('> [$i/$max] Pulling from origin...');
    final ProcessResult(stderr: pullStdErr, exitCode: pullExitCode) = Process.runSync('git', ['pull', '--rebase', '--autostash']);
    if (pullExitCode != 0) {
      print(red('> [$i/$max] Failed to pull and rebase from origin.'));
      print(pullStdErr);
      exit(pullExitCode);
    }

    print('> [$i/$max] Pushing refs to origin...');
    final ProcessResult(:stderr, :stdout, :exitCode) = Process.runSync('git', ['push']);
    if (exitCode == 0) {
      print('> [$i/$max] Successfully pushed refs to origin.');
      print(stdout);
      print(stderr);
      exit(0);
    }

    final seconds = random.nextInt(5);
    print(red('> [$i/$max] Failed to push to origin. Retrying in ${seconds}s...'));
    sleep(Duration(seconds: seconds));
  }

}
