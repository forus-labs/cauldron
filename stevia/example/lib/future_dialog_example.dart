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
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FloatingActionButton(
          onPressed: () => showFutureDialog(
            context: context,
            future: Future.delayed(const Duration(seconds: 5), () async => ''),
            emptyBuilder: (context, _, __) => const Text('This barrier will disappear after 5.'),
          ),
          child: const Text('No dialog'),
        ),
        FloatingActionButton(
          onPressed: () => showFutureDialog(
            context: context,
            future: Future.delayed(const Duration(seconds: 5), () async => ''),
            builder: (context, _, __) => FloatingActionButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Dismiss'),
            ),
            emptyBuilder: (context, _, __) => const Text('Please wait 5s'),
          ),
          child: const Text('Has value dialog'),
        ),
        FloatingActionButton(
          onPressed: () => showFutureDialog(
            context: context,
            future: Future.delayed(const Duration(seconds: 5), () async => throw StateError('Error')),
            errorBuilder: (context, _, __) => FloatingActionButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Dismiss'),
            ),
            emptyBuilder: (context, _, __) => const Text('Please wait 5s'),
          ),
          child: const Text('Has error dialog'),
        ),
      ],
    ),
  );
}