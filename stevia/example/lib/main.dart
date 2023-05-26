import 'package:flutter/material.dart';

void main() {
  runApp(HomeWidget());
}

/// The home widget.
class HomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: ThemeData(useMaterial3: true),
    home: const Scaffold(
      body: Text('This is a placeholder. Run the other examples in the example/lib folder to get started.'),
    ),
  );
}
