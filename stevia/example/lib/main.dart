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
        child: SizedBox(
          height: 700,
          width: 300,
          child: ResizableBox(
            verticial: true,
            initialIndex: 1,
            children: [
              ResizableBoxRegion(
                initialPercentage: (_) => 0.4,
                sliderSize: 60,
                builder: (_, __, ___, child) => child!,
                child: Container(color: Colors.greenAccent),
              ),
              ResizableBoxRegion(
                initialPercentage: (_) => 0.3,
                sliderSize: 60,
                builder: (_, __, ___, child) => child!,
                child: Container(color: Colors.yellowAccent),
              ),
              ResizableBoxRegion(
                initialPercentage: (_) => 0.3,
                sliderSize: 60,
                builder: (_, __, ___, child) => child!,
                child: Container(color: Colors.redAccent),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
