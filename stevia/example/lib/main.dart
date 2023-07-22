import 'package:flutter/material.dart';

void main() {
  runApp(HomeWidget());
}

/// The home widget.
class HomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: ThemeData(useMaterial3: true),
    home: Scaffold(
      body: Center(
        child: Text('This is a placeholder. Run the other examples in example/lib to get started.'),
      ),
    ),
  );
}
