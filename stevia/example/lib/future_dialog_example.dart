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
          onPressed: () => showAdaptiveFutureDialog(
            context: context,
            future: () async {
              await Future.delayed(const Duration(seconds: 5));
              return '';
            },
            emptyBuilder: (context, _, __) => Container(
              alignment: Alignment.center,
              child: const Text('This text will disappear after 5s.'),
            ),
          ),
          child: const Text('Auto-dismiss', textAlign: TextAlign.center,),
        ),
        const SizedBox(height: 10),
        FloatingActionButton(
          onPressed: () => showAdaptiveFutureDialog(
            context: context,
            future: () async {
              await Future.delayed(const Duration(seconds: 5));
              return '';
            },
            builder: (context, _, __) => FloatingActionButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Dismiss'),
            ),
            emptyBuilder: (context, _, __) => Container(
              alignment: Alignment.center,
              child: const Text('This text will disappear after 5s.'),
            ),
          ),
          child: const Text('Has value', textAlign: TextAlign.center),
        ),
        const SizedBox(height: 10),
        FloatingActionButton(
          onPressed: () => showAdaptiveFutureDialog(
            context: context,
            future: () async {
              await Future.delayed(const Duration(seconds: 5));
              throw StateError('Error');
            },
            errorBuilder: (context, _, __) => FloatingActionButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Dismiss'),
            ),
            emptyBuilder: (context, _, __) => Container(
              alignment: Alignment.center,
              child: const Text('This text will disappear after 5s.'),
            ),
          ),
          child: const Text('Has error', textAlign: TextAlign.center),
        ),
        const SizedBox(height: 10),
      ],
    ),
  );
}