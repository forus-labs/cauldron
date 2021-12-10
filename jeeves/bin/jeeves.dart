import 'package:args/command_runner.dart';

import 'package:jeeves/jeeves.dart';

void main(List<String> arguments) => CommandRunner('jeeves', 'Make Flutter development great again!')
..addCommand(BranchCommand(
    name: 'environments',
    aliases: ['environment', 'envs', 'env'],
    description: 'environment management utilities',
    children: [
      LoadCommand(),
    ]
))
..addCommand(BranchCommand(
    name: 'create',
    description: 'create ',
    children: [

    ]
))
..run(arguments);
