import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:stevia/src/widgets/resizable/direction.dart';

import 'package:stevia/src/widgets/resizable/resizable_box_model.dart';
import 'package:stevia/src/widgets/resizable/resizable_region_change_notifier.dart';
import 'package:stevia/src/widgets/resizable/slider.dart';

import 'slider_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ResizableBoxModel>(), MockSpec<ResizableRegionChangeNotifier>()])
void main() {
  late MockResizableBoxModel model;
  late MockResizableRegionChangeNotifier notifier;

  setUp(() {
    model = MockResizableBoxModel();
    notifier = MockResizableRegionChangeNotifier();
    when(model.notifiers).thenReturn([notifier]);
  });


  for (final (index, constructor) in [
    () => HorizontalSlider.left(model: model, index: -1, size: 500),
    () => HorizontalSlider.right(model: model, index: -1, size: 500),
    () => VerticalSlider.top(model: model, index: -1, size: 500),
    () => VerticalSlider.bottom(model: model, index: -1, size: 500),

    () => HorizontalSlider.left(model: model, index: 1, size: 500),
    () => HorizontalSlider.right(model: model, index: 1, size: 500),
    () => VerticalSlider.top(model: model, index: 1, size: 500),
    () => VerticalSlider.bottom(model: model, index: 1, size: 500),

    () => HorizontalSlider.left(model: model, index: 0, size: double.nan),
    () => HorizontalSlider.right(model: model, index: 0, size: double.nan),
    () => VerticalSlider.top(model: model, index: 0, size: double.nan),
    () => VerticalSlider.bottom(model: model, index: 0, size: double.nan),

    () => HorizontalSlider.left(model: model, index: 0, size: double.infinity),
    () => HorizontalSlider.right(model: model, index: 0, size: double.infinity),
    () => VerticalSlider.top(model: model, index: 0, size: double.infinity),
    () => VerticalSlider.bottom(model: model, index: 0, size: double.infinity),
  ].indexed) {
    test('[$index] constructor throws error', () => expect(constructor, throwsAssertionError));
  }


  for (final (index, (function, direction)) in [
    (() => HorizontalSlider.left(model: model, index: 0, size: 50), Direction.left),
    (() => HorizontalSlider.right(model: model, index: 0, size: 50), Direction.right),
  ].indexed) {
    group('[$index] horizontal slider', () {
      late HorizontalSlider slider;

      setUp(() => slider = function());

      testWidgets('size', (tester) async {
        await tester.pumpWidget(slider);

        final Size(:height, :width) = tester.getSize(find.byType(SizedBox));
        expect(height, isNot(50));
        expect(width, 50);
        expect((find.byType(Align).evaluate().single.widget as Align).alignment, direction.alignment);
      });

      for (final (index, offset) in [
        const Offset(100, 0),
        const Offset(-100, 0),
      ].indexed) {
        testWidgets('[$index] enabled horizontal drag', (tester) async {
          when(model.selected).thenReturn(0);

          await tester.pumpWidget(slider);
          await tester.drag(find.byType(GestureDetector), offset);

          verify(model.update(0, direction, any));
        });

        testWidgets('[$index] disabled horizontal drag', (tester) async {
          when(model.selected).thenReturn(1);

          await tester.pumpWidget(slider);
          await tester.drag(find.byType(GestureDetector), offset);

          verifyNever(model.update(0, direction, any));
        });
      }

      for (final (index, offset) in [
        const Offset(0, 100),
        const Offset(0, -100),
      ].indexed) {
        testWidgets('[$index] enabled vertical drag', (tester) async {
          when(model.selected).thenReturn(0);

          await tester.pumpWidget(slider);
          await tester.drag(find.byType(GestureDetector), offset);

          verifyNever(model.update(0, direction, any));
        });
      }
    });
  }


  for (final (index, (function, direction)) in [
    (() => VerticalSlider.top(model: model, index: 0, size: 50), Direction.top),
    (() => VerticalSlider.bottom(model: model, index: 0, size: 50), Direction.bottom),
  ].indexed) {
    group('[$index] horizontal slider', () {
      late VerticalSlider slider;

      setUp(() => slider = function());

      testWidgets('size', (tester) async {
        await tester.pumpWidget(slider);

        final Size(:height, :width) = tester.getSize(find.byType(SizedBox));
        expect(height, 50);
        expect(width, isNot(50));
        expect((find.byType(Align).evaluate().single.widget as Align).alignment, direction.alignment);
      });

      for (final (index, offset) in [
        const Offset(0, 100),
        const Offset(0, -100),
      ].indexed) {
        testWidgets('[$index] enabled vertical drag', (tester) async {
          when(model.selected).thenReturn(0);

          await tester.pumpWidget(slider);
          await tester.drag(find.byType(GestureDetector), offset);

          verify(model.update(0, direction, any));
        });

        testWidgets('[$index] disabled vertical drag', (tester) async {
          when(model.selected).thenReturn(1);

          await tester.pumpWidget(slider);
          await tester.drag(find.byType(GestureDetector), offset);

          verifyNever(model.update(0, direction, any));
        });
      }

      for (final (index, offset) in [
        const Offset(100, 0),
        const Offset(-100, 0),
      ].indexed) {
        testWidgets('[$index] enabled horizontal drag', (tester) async {
          when(model.selected).thenReturn(0);

          await tester.pumpWidget(slider);
          await tester.drag(find.byType(GestureDetector), offset);

          verifyNever(model.update(0, direction, any));
        });
      }
    });
  }

}
