import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:stevia/src/widgets/resizable/resizable_region_box.dart';
import 'package:stevia/stevia.dart';

void main() {
  final top = ResizableRegion(
    initialSize: 30,
    sliderSize: 10,
    builder: (context, snapshot, child) => const SizedBox(),
  );

  final bottom = ResizableRegion(
    initialSize: 70,
    sliderSize: 10,
    builder: (context, snapshot, child) => const SizedBox(),
  );

  late List<dynamic> calls;

  setUp(() => calls = Haptic.stubForTesting());


  for (final (index, constructor) in [
    () => ResizableBox(
      horizontal: true,
      height: -1,
      width: 100,
      children: [top, bottom],
    ),
    () => ResizableBox(
      height: 100,
      width: -1,
      children: [top, bottom],
    ),
    () => ResizableBox(
      height: 50,
      width: 100,
      children: [top],
    ),
    () => ResizableBox(
      height: 50,
      width: 100,
      initialIndex: -1,
      children: [top, bottom],
    ),
    () => ResizableBox(
      height: 50,
      width: 100,
      initialIndex: 2,
      children: [top, bottom],
    ),
    () => ResizableBox(
      height: 110,
      width: 100,
      children: [top, bottom],
    ),
    () => ResizableBox(
      horizontal: true,
      height: 100,
      width: 110,
      children: [top, bottom],
    ),
  ].indexed) {
    test('[$index] constructor throws error', () => expect(constructor, throwsAssertionError));
  }


  testWidgets('vertical drag downwards', (tester) async {
    final vertical = ResizableBox(
      height: 100,
      width: 50,
      hapticFeedbackVelocity: 0.0,
      children: [top, bottom],
    );
    
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(body: Center(child: vertical)),
    ));

    await tester.timedDrag(find.byType(GestureDetector).at(1), const Offset(0, 100), const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(calls.length, 1);
    expect(tester.getSize(find.byType(VerticalResizableRegionBox).first), const Size(50, 80));
    expect(tester.getSize(find.byType(VerticalResizableRegionBox).last), const Size(50, 20));
  });

  testWidgets('no vertical drag when disabled', (tester) async {
    final vertical = ResizableBox(
      height: 100,
      width: 50,
      children: [top, bottom],
    );

    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(body: Center(child: vertical)),
    ));

    await tester.tap(find.byType(GestureDetector).at(3));
    calls.clear();

    await tester.timedDrag(find.byType(GestureDetector).at(1), const Offset(0, 100), const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(calls.length, 0);
    expect(tester.getSize(find.byType(VerticalResizableRegionBox).first), const Size(50, 30));
    expect(tester.getSize(find.byType(VerticalResizableRegionBox).last), const Size(50, 70));
  });

  testWidgets('vertical drag when haptic feedback disabled', (tester) async {
    final vertical = ResizableBox(
      height: 100,
      width: 50,
      hapticFeedbackVelocity: null,
      children: [top, bottom],
    );

    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(body: Center(child: vertical)),
    ));

    await tester.timedDrag(find.byType(GestureDetector).at(1), const Offset(0, 100), const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(calls.length, 0);
    expect(tester.getSize(find.byType(VerticalResizableRegionBox).first), const Size(50, 80));
    expect(tester.getSize(find.byType(VerticalResizableRegionBox).last), const Size(50, 20));
  });


  testWidgets('vertical drag upwards', (tester) async {
    final vertical = ResizableBox(
      height: 100,
      width: 50,
      hapticFeedbackVelocity: 0.0,
      children: [top, bottom],
    );

    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(body: Center(child: vertical)),
    ));

    await tester.timedDrag(find.byType(GestureDetector).at(1), const Offset(0, -100), const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(calls.length, 1);
    expect(tester.getSize(find.byType(VerticalResizableRegionBox).first), const Size(50, 20));
    expect(tester.getSize(find.byType(VerticalResizableRegionBox).last), const Size(50, 80));
  });

  testWidgets('horizontal drag right', (tester) async {
    final horizontal = ResizableBox(
      horizontal: true,
      height: 50,
      width: 100,
      hapticFeedbackVelocity: 0.0,
      children: [top, bottom],
    );

    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(body: Center(child: horizontal)),
    ));

    await tester.timedDrag(find.byType(GestureDetector).at(1), const Offset(100, 0), const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(calls.length, 1);
    expect(tester.getSize(find.byType(HorizontalResizableRegionBox).first), const Size(80, 50));
    expect(tester.getSize(find.byType(HorizontalResizableRegionBox).last), const Size(20, 50));
  });

  testWidgets('horizontal drag left', (tester) async {
    final horizontal = ResizableBox(
      horizontal: true,
      height: 50,
      width: 100,
      hapticFeedbackVelocity: 0.0,
      children: [top, bottom],
    );

    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(body: Center(child: horizontal)),
    ));

    await tester.timedDrag(find.byType(GestureDetector).at(1), const Offset(-100, 0), const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(calls.length, 1);
    expect(tester.getSize(find.byType(HorizontalResizableRegionBox).first), const Size(20, 50));
    expect(tester.getSize(find.byType(HorizontalResizableRegionBox).last), const Size(80, 50));
  });

  testWidgets('horizontal drag when disabled', (tester) async {
    final horizontal = ResizableBox(
      horizontal: true,
      height: 50,
      width: 100,
      hapticFeedbackVelocity: null,
      children: [top, bottom],
    );

    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(body: Center(child: horizontal)),
    ));

    await tester.timedDrag(find.byType(GestureDetector).at(1), const Offset(100, 0), const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(calls.length, 0);
    expect(tester.getSize(find.byType(HorizontalResizableRegionBox).first), const Size(80, 50));
    expect(tester.getSize(find.byType(HorizontalResizableRegionBox).last), const Size(20, 50));
  });

  testWidgets('no horizontal drag when disabled', (tester) async {
    final horizontal = ResizableBox(
      horizontal: true,
      height: 50,
      width: 100,
      children: [top, bottom],
    );

    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(body: Center(child: horizontal)),
    ));

    await tester.tap(find.byType(GestureDetector).at(3));
    calls.clear();

    await tester.timedDrag(find.byType(GestureDetector).at(1), const Offset(-100, 0), const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(calls.length, 0);
    expect(tester.getSize(find.byType(HorizontalResizableRegionBox).first), const Size(30, 50));
    expect(tester.getSize(find.byType(HorizontalResizableRegionBox).last), const Size(70, 50));
  });

}
