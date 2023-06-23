import 'package:flutter/material.dart';

import 'package:stevia/stevia.dart';

void main() {
  runApp(const HapticExample());
}

/// An example application that showcases haptic feedback across all supported platforms.
class HapticExample extends StatelessWidget {
  /// Creates a [HapticExample].
  const HapticExample({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: DefaultTabController(
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
      ),
    );
}

class _PlatformAgnosticHaptic extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ListView(
    children: const [
      TextButton(
        onPressed: Haptic.success,
        child: Text('success'),
      ),
      TextButton(
        onPressed: Haptic.warning,
        child: Text('warning'),
      ),
      TextButton(
        onPressed: Haptic.failure,
        child: Text('failure'),
      ),
      TextButton(
        onPressed: Haptic.heavy,
        child: Text('heavy'),
      ),
      TextButton(
        onPressed: Haptic.medium,
        child: Text('medium'),
      ),
      TextButton(
        onPressed: Haptic.light,
        child: Text('light'),
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
          onPressed: () => Haptic.perform((pattern, null)),
          child: Text(pattern.toString().split('.').last),
        ),
    ],
  );
}

class _IOSHaptic extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ListView(
    children: [
      for (final pattern in IOSHapticPattern.values)
        TextButton(
          onPressed: () => Haptic.perform((null, pattern)),
          child: Text(pattern.toString().split('.').last),
        ),
    ],
  );
}
