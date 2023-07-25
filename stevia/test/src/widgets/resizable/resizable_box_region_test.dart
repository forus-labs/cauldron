import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:stevia/src/widgets/resizable/resizable_box_model.dart';
import 'package:stevia/src/widgets/resizable/resizable_box_region.dart';
import 'package:stevia/src/widgets/resizable/resizable_region.dart';
import 'package:stevia/src/widgets/resizable/resizable_region_change_notifier.dart';

void main() {
  late ResizableBoxModel model;
  late ResizableRegionChangeNotifier top;
  late ResizableRegionChangeNotifier bottom;

  setUp(() {
    top = ResizableRegionChangeNotifier((min: 10, max: 60), 0, 40);
    bottom = ResizableRegionChangeNotifier((min: 10, max: 60), 40, 60);

    model = ResizableBoxModel([top, bottom], 60, 0);
  });

  testWidgets('HorizontalResizableBoxRegion', (tester) async {
    (RegionSnapshot, bool)? snapshot;
    final box = HorizontalResizableBoxRegion(
      index: 1,
      model: model,
      notifier: top,
      region: ResizableRegion(
        initialSize: 40,
        sliderSize: 10,
        builder: (context, s, child) {
          snapshot = (s, child != null);
          return child!;
        },
        child: const Padding(padding: EdgeInsets.zero),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: Scaffold(
          body: box,
        )
      ),
    );

    expect(tester.getSize(find.byType(HorizontalResizableBoxRegion)), const Size(40, 600));
    expect(snapshot, (RegionSnapshot(index: 1, enabled: false, total: 60, min: 0, max: 40), true));

    model.selected = 1;
    await tester.pumpAndSettle();

    expect(snapshot, (RegionSnapshot(index: 1, enabled: true, total: 60, min: 0, max: 40), true));
  });

  testWidgets('VerticalResizableBoxRegion', (tester) async {
    (RegionSnapshot, bool)? snapshot;
    final box = VerticalResizableBoxRegion(
      index: 1,
      model: model,
      notifier: top,
      region: ResizableRegion(
        initialSize: 40,
        sliderSize: 10,
        builder: (context, s, child) {
          snapshot = (s, child != null);
          return child!;
        },
        child: const Padding(padding: EdgeInsets.zero),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
          theme: ThemeData(useMaterial3: true),
          home: Scaffold(
            body: box,
          )
      ),
    );

    expect(tester.getSize(find.byType(VerticalResizableBoxRegion)), const Size(800, 40));
    expect(snapshot, (RegionSnapshot(index: 1, enabled: false, total: 60, min: 0, max: 40), true));

    model.selected = 1;
    await tester.pumpAndSettle();

    expect(snapshot, (RegionSnapshot(index: 1, enabled: true, total: 60, min: 0, max: 40), true));
  });
}
