import 'package:flutter/material.dart';

import 'package:stevia/stevia.dart';

void main() {
  runApp(const HapticDemo());
}

class HapticDemo extends StatelessWidget {
  const HapticDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: DefaultTabController(
        initialIndex: 0,
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Haptic Feedback Example'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Agnostic'),
                Tab(text: 'Android'),
                Tab(text: 'iOS'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _PlatformAgnosticHaptic(),
              _AndroidHaptic(),
              _IOSHaptic(),
            ],
          ),
        ),
      )
    );
  }
}

class _PlatformAgnosticHaptic extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ListView(
    children: [
      TextButton(
        onPressed: () => Haptic.success(),
        child: const Text('success'),
      ),
      TextButton(
        onPressed: () => Haptic.warning(),
        child: const Text('warning'),
      ),
      TextButton(
        onPressed: () => Haptic.failure(),
        child: const Text('failure'),
      ),

      TextButton(
        onPressed: () => Haptic.heavy(),
        child: const Text('heavy'),
      ),
      TextButton(
        onPressed: () => Haptic.medium(),
        child: const Text('medium'),
      ),
      TextButton(
        onPressed: () => Haptic.light(),
        child: const Text('light'),
      ),
    ],
  );
}

class _AndroidHaptic extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ListView(
    children: [
      for (final pattern in AndroidHapticPattern.values)
        TextButton(
          onPressed: () => Haptic.feedback((pattern, null)),
          child: Text(pattern.toString().split('.').last),
        ),
    ],
  );
}

class _IOSHaptic extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      for (final pattern in IOSHapticPattern.values)
        TextButton(
          onPressed: () => Haptic.feedback((null, pattern)),
          child: Text(pattern.toString().split('.').last),
        ),
    ],
  );
}
