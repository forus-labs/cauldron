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
      body: Center(
        child: ResizableBox(
          height: 600,
          width: 300,
          initialIndex: 1,
          children: [
            ResizableRegion(
              initialSize: 200,
              sliderSize: 60,
              builder: (context, enabled, size, child) => child!,
              child: Container(color: Colors.greenAccent),
            ),
            ResizableRegion(
              initialSize: 250,
              sliderSize: 60,
              builder: (context, enabled, size, child) => child!,
              child: Container(color: Colors.yellowAccent),
            ),
            ResizableRegion(
              initialSize: 150,
              sliderSize: 60,
              builder: (context, enabled, size, child) => child!,
              child: Container(color: Colors.redAccent),
            ),
          ],
        ),
      ),
    ),
  );
}
