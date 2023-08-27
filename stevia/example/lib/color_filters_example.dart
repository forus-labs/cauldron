import 'package:flutter/material.dart';
import 'package:stevia/stevia.dart';

void main() {
  runApp(HomeWidget());
}

/// An example application that showcases [ColorFilters].
class HomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: ThemeData(useMaterial3: true),
    home: Scaffold(
      body: Center(
        child: ColorFiltered(
          colorFilter: ColorFilters.matrix(brightness: 0.5, saturation: 0.4, hue: 0.3, contrast: 0.2),
          child: Image.network('https://upload.wikimedia.org/wikipedia/commons/c/c6/500_x_500_SMPTE_Color_Bars.png'),
        ),
      ),
    ),
  );
}

