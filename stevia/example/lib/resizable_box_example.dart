import 'package:flutter/material.dart';
import 'package:stevia/stevia.dart';

void main() => runApp(HomeWidget());

class HomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
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
              builder: (context, snapshot, child) => Stack(
                children: [
                  child!,
                  if (snapshot.selected)
                    const Align(
                      alignment: Alignment.bottomCenter,
                      child: ResizableIcon.horizontal(),
                    ),
                ],
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF2C9D8),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                ),
              ),
            ),
            ResizableRegion(
              initialSize: 250,
              sliderSize: 60,
              builder: (context, snapshot, child) => Stack(
                children: [
                  child!,
                  if (snapshot.selected)
                    const Align(
                      alignment: Alignment.topCenter,
                      child: ResizableIcon.horizontal(),
                    ),
                  if (snapshot.selected)
                    const Align(
                      alignment: Alignment.bottomCenter,
                      child: ResizableIcon.horizontal(),
                    ),
                ],
              ),
              child: Container(color: const Color(0xFFF2DAAC)),
            ),
            ResizableRegion(
              initialSize: 150,
              sliderSize: 60,
              builder: (context, snapshot, child) => Stack(
                children: [
                  child!,
                  if (snapshot.selected)
                    const Align(
                      alignment: Alignment.topCenter,
                      child: ResizableIcon.horizontal(),
                    ),
                ],
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF8C5845),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
                ),
              )
            ),
          ],
        ),
      ),
    ),
  );
}
