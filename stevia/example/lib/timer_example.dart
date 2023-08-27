import 'package:flutter/material.dart';
import 'package:stevia/stevia.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CountdownExample());
}

/// An example application that showcases a countdown.
class CountdownExample extends StatefulWidget {
  /// Creates a [CountdownExample].
  const CountdownExample({super.key});
  @override
  _CountdownState createState() => _CountdownState();
}

class _CountdownState extends State<CountdownExample> {

  late TimerController controller;

  @override
  void initState() {
    super.initState();
    controller = TimerController(
      duration: const Duration(seconds: 30),
      interval: const Duration(milliseconds: 10),
      ascending: true,
    )..run();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ValueListenableBuilder(
                valueListenable: controller,
                builder: (context, microseconds, child) => Text(TimerController.seconds(microseconds)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ValueListenableBuilder(
                    valueListenable: controller.state,
                    builder: (context, state, child) => switch (state) {
                      TimerState.idle || TimerState.paused => IconButton(icon: const Icon(Icons.play_arrow), onPressed: controller.run),
                      TimerState.running => IconButton(icon: const Icon(Icons.pause), onPressed: controller.pause),
                      TimerState.done => const SizedBox(),
                    }
                  ),
                  IconButton(icon: const Icon(Icons.replay), onPressed: controller.reset),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

}
