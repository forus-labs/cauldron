import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:stevia/src/widgets/resizable/box/resizable_box_model.dart';
import 'package:stevia/src/widgets/resizable/box/resizable_box_region.dart';
import 'package:stevia/src/widgets/resizable/box/resizable_region.dart';
import 'package:stevia/src/widgets/resizable/box/resizable_region_change_notifier.dart';

void main() {
  late ResizableBoxModel model;
  late ResizableRegionChangeNotifier top;
  late ResizableRegionChangeNotifier bottom;

  setUp(() {
    top = ResizableRegionChangeNotifier(10, 40, 60);
    bottom = ResizableRegionChangeNotifier(10, 20, 60);

    model = ResizableBoxModel([top, bottom], 0);
  });

  testWidgets('HorizontalResizableBoxRegion', (tester) async {
    (bool, double, bool)? builder;
    final box = HorizontalResizableBoxRegion(
      index: 1,
      model: model,
      notifier: top,
      region: ResizableRegion(
        initialSize: 40,
        sliderSize: 10,
        builder: (context, enabled, size, child) {
          builder = (enabled, size, child != null);
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
    expect(builder, (false, 40.0, true));

    model.selected = 1;
    await tester.pumpAndSettle();

    expect(builder, (true, 40.0, true));
  });

  testWidgets('VerticalResizableBoxRegion', (tester) async {
    (bool, double, bool)? builder;
    final box = VerticalResizableBoxRegion(
      index: 1,
      model: model,
      notifier: top,
      region: ResizableRegion(
        initialSize: 40,
        sliderSize: 10,
        builder: (context, enabled, size, child) {
          builder = (enabled, size, child != null);
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
    expect(builder, (false, 40.0, true));

    model.selected = 1;
    await tester.pumpAndSettle();

    expect(builder, (true, 40.0, true));
  });
}
