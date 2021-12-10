import 'package:args/command_runner.dart';

/// A command that contains child commands.
class BranchCommand extends Command<void> {

  @override final String name;
  @override final List<String> aliases;
  @override final String description;

  /// Creates a [BranchCommand] with the given parameters.
  BranchCommand({required this.name, required this.description, required List<Command<void>> children, this.aliases = const []}) {
    children.forEach(addSubcommand);
  }

}
