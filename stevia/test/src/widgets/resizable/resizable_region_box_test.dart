import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:stevia/src/widgets/resizable/resizable_box_model.dart';
import 'package:stevia/src/widgets/resizable/resizable_region_box.dart';
import 'package:stevia/src/widgets/resizable/resizable_region.dart';
import 'package:stevia/src/widgets/resizable/resizable_region_change_notifier.dart';

void main() {
  late ResizableBoxModel model;
  late ResizableRegionChangeNotifier top;
  late ResizableRegionChangeNotifier bottom;
  (RegionSnapshot, bool)? snapshot;

  setUp(() {
    snapshot = null;

    top = ResizableRegionChangeNotifier(
      ResizableRegion(
        initialSize: 40,
        sliderSize: 10,
        builder: (context, s, child) {
          snapshot = (s, child != null);
          return child!;
        },
        child: const Padding(padding: EdgeInsets.zero),
      ),
      RegionSnapshot(index: 0, selected: true, constraints: (min: 10, max: 60), min: 0, max: 40),
    );

    bottom = ResizableRegionChangeNotifier(
      ResizableRegion(
        initialSize: 20,
        sliderSize: 10,
        builder: (_, __, ___) =>  const Padding(padding: EdgeInsets.zero),
      ),
      RegionSnapshot(index: 1, selected: false, constraints: (min: 10, max: 60), min: 40, max: 60),
    );

    model = ResizableBoxModel([top, bottom], 60, 0, null, null);
  });

  testWidgets('HorizontalResizableRegionBox', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: Scaffold(
          body: HorizontalResizableRegionBox(
            model: model,
            notifier: top,
          ),
        )
      ),
    );

    expect(tester.getSize(find.byType(HorizontalResizableRegionBox)), const Size(40, 600));
    expect(snapshot, (RegionSnapshot(index: 0, selected: true, constraints: (min: 10, max: 60), min: 0, max: 40), true));

    model.selected = 1;
    await tester.pumpAndSettle();

    expect(snapshot, (RegionSnapshot(index: 0, selected: false, constraints: (min: 10, max: 60), min: 0, max: 40), true));
  });

  testWidgets('VerticalResizableRegionBox', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VerticalResizableRegionBox(
            model: model,
            notifier: top,
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byType(VerticalResizableRegionBox)), const Size(800, 40));
    expect(snapshot, (RegionSnapshot(index: 0, selected: true, constraints: (min: 10, max: 60), min: 0, max: 40), true));

    model.selected = 1;
    await tester.pumpAndSettle();

    expect(snapshot, (RegionSnapshot(index: 0, selected: false, constraints: (min: 10, max: 60), min: 0, max: 40), true));
  });
}