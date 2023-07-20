import 'package:flutter/material.dart';
import 'package:stevia/src/widgets/old/resizable_widget.dart';

void main() {
  runApp(HomeWidget());
}

/// The home widget.
class HomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: ThemeData(useMaterial3: true),
    home: Scaffold(
      body: ResizableWidget(
        isHorizontalSeparator: false,
        separatorSize: 50,
        children: [ // required
          Container(color: Colors.greenAccent),
          Container(color: Colors.yellowAccent),
          Container(color: Colors.redAccent),
        ],
      ),
    ),
  );
}
