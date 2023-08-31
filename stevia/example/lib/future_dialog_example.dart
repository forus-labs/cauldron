import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stevia/stevia.dart';
import 'package:sugar/sugar.dart';

void main() {
  runApp(HomeWidget());
}

/// The home widget.
class HomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: ThemeData(useMaterial3: true),
    home: DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Future Dialog Example'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'FutureValueDialog'),
              Tab(text: 'FutureResultDialog'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FutureValueDialogs(),
            FutureResultDialogs(),
          ],
        ),
      ),
    ),
  );
}

class FutureValueDialogs extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FloatingActionButton(
          onPressed: () => showFutureValueDialog(
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
          onPressed: () => showFutureValueDialog(
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
          onPressed: () => showFutureValueDialog(
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

class FutureResultDialogs extends StatelessWidget { // This needs to be separated to ensure that the correct BuildContext is used.
  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FloatingActionButton(
          onPressed: () => showFutureResultDialog(
            context: context,
            future: () async {
              await Future.delayed(const Duration(seconds: 5));
              return Success('');
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
          onPressed: () => showFutureResultDialog(
            context: context,
            future: () async {
              await Future.delayed(const Duration(seconds: 5));
              return Success('');
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
          child: const Text('Success', textAlign: TextAlign.center),
        ),
        const SizedBox(height: 10),
        FloatingActionButton(
          onPressed: () => showFutureResultDialog(
            context: context,
            future: () async {
              await Future.delayed(const Duration(seconds: 5));
              return Failure('');
            },
            failureBuilder: (context, _, __) => FloatingActionButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Dismiss'),
            ),
            emptyBuilder: (context, _, __) => Container(
              alignment: Alignment.center,
              child: const Text('This text will disappear after 5s.'),
            ),
          ),
          child: const Text('Failure', textAlign: TextAlign.center),
        ),
        const SizedBox(height: 10),
      ],
    ),
  );
}