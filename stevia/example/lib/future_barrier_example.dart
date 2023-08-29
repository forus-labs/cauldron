import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stevia/stevia.dart';

void main() {
  runApp(HomeWidget());
}

/// The home widget.
class HomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: ThemeData(useMaterial3: true),
    home: Scaffold(
      body: SomeWidget(),
    ),
  );
}

class SomeWidget extends StatelessWidget { // This needs to be separated to ensure that the correct BuildContext is used.
  @override
  Widget build(BuildContext context) => Center(
    child: FloatingActionButton(
      onPressed: () => showFutureBarrier(
          context: context,
          future: Future.delayed(const Duration(seconds: 5)),
          builder: (context) => const Text('This barrier will disappear after 5.'),
      ),
      child: const Text('Load'),
    ),
  );
}