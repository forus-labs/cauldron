import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:stevia/src/widgets/resizable/box/resizable_box_model.dart';
import 'package:stevia/src/widgets/resizable/box/resizable_region_change_notifier.dart';
import 'package:stevia/src/widgets/resizable/box/slider.dart';

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
  
  for (final constructor in [
    () => HorizontalSlider.left(model: model, index: -1, size: 500),
  ]) {
    test('constructor throws error', () => expect(constructor, throwsAssertionError));
  }
}