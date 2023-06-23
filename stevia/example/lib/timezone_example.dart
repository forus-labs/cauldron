import 'package:flutter/material.dart';

import 'package:stevia/stevia.dart';
import 'package:sugar/sugar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Timezone.platformTimezoneProvider = await flutterPlatformTimezoneProvider();
  runApp(const TimezoneExample());
}

/// An example application that showcases timezone detection across devices.
class TimezoneExample extends StatefulWidget {
  /// Creates a [TimezoneExample].
  const TimezoneExample({super.key});
  @override
  TimezoneState createState() => TimezoneState();
}

/// The timezone example's state.
class TimezoneState extends State<TimezoneExample> {
  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: ThemeData(useMaterial3: true),
    home: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Change the device's timezone & tap the button."),
            Text('${ZonedDateTime.now()}'),
            IconButton(onPressed: () => setState(() {}), icon: const Icon(Icons.refresh)),
          ],
        ),
      ),
    ),
  );
}
