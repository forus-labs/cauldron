import 'package:args/command_runner.dart';

import 'package:jeeves/src/commands/load.dart';

void main(List<String> arguments) => CommandRunner('jeeves', 'Make environment management great again!')
                                                  ..addCommand(LoadCommand())
                                                  ..run(arguments);
