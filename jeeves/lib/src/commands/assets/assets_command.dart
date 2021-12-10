import 'package:jeeves/src/core/terminal.dart';

/// A command that generates Dart binding for assets, i.e. icons and illustrations when executed.
class AssetsCommand extends TerminalCommand<void> {

  @override
  String get name => 'assets';

  @override
  List<String> get aliases => ['asset'];

  @override
  String get description => 'creates Dart bindings for assets, i.e. icons and illustrations';

}
