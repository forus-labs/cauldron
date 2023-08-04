// Mocks generated by Mockito 5.4.2 from annotations
// in stevia/test/src/widgets/resizable/slider_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:ui' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i7;
import 'package:stevia/src/widgets/resizable/direction.dart' as _i6;
import 'package:stevia/src/widgets/resizable/resizable_box_model.dart' as _i4;
import 'package:stevia/src/widgets/resizable/resizable_region_change_notifier.dart'
    as _i5;
import 'package:stevia/stevia.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeResizableRegion_0 extends _i1.SmartFake
    implements _i2.ResizableRegion {
  _FakeResizableRegion_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeOffset_1 extends _i1.SmartFake implements _i3.Offset {
  _FakeOffset_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [ResizableBoxModel].
///
/// See the documentation for Mockito's code generation for more information.
class MockResizableBoxModel extends _i1.Mock implements _i4.ResizableBoxModel {
  @override
  List<_i5.ResizableRegionChangeNotifier> get notifiers => (super.noSuchMethod(
        Invocation.getter(#notifiers),
        returnValue: <_i5.ResizableRegionChangeNotifier>[],
        returnValueForMissingStub: <_i5.ResizableRegionChangeNotifier>[],
      ) as List<_i5.ResizableRegionChangeNotifier>);
  @override
  double get size => (super.noSuchMethod(
        Invocation.getter(#size),
        returnValue: 0.0,
        returnValueForMissingStub: 0.0,
      ) as double);
  @override
  int get selected => (super.noSuchMethod(
        Invocation.getter(#selected),
        returnValue: 0,
        returnValueForMissingStub: 0,
      ) as int);
  @override
  set selected(int? value) => super.noSuchMethod(
        Invocation.setter(
          #selected,
          value,
        ),
        returnValueForMissingStub: null,
      );
  @override
  bool update(
    int? index,
    _i6.Direction? direction,
    _i3.Offset? delta,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #update,
          [
            index,
            direction,
            delta,
          ],
        ),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);
  @override
  void end(
    int? index,
    _i6.Direction? direction,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #end,
          [
            index,
            direction,
          ],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [ResizableRegionChangeNotifier].
///
/// See the documentation for Mockito's code generation for more information.
class MockResizableRegionChangeNotifier extends _i1.Mock
    implements _i5.ResizableRegionChangeNotifier {
  @override
  _i2.ResizableRegion get region => (super.noSuchMethod(
        Invocation.getter(#region),
        returnValue: _FakeResizableRegion_0(
          this,
          Invocation.getter(#region),
        ),
        returnValueForMissingStub: _FakeResizableRegion_0(
          this,
          Invocation.getter(#region),
        ),
      ) as _i2.ResizableRegion);
  @override
  bool get selected => (super.noSuchMethod(
        Invocation.getter(#selected),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);
  @override
  set selected(bool? value) => super.noSuchMethod(
        Invocation.setter(
          #selected,
          value,
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i2.RegionSnapshot get snapshot => (super.noSuchMethod(
        Invocation.getter(#snapshot),
        returnValue: _i7.dummyValue<_i2.RegionSnapshot>(
          this,
          Invocation.getter(#snapshot),
        ),
        returnValueForMissingStub: _i7.dummyValue<_i2.RegionSnapshot>(
          this,
          Invocation.getter(#snapshot),
        ),
      ) as _i2.RegionSnapshot);
  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);
  @override
  _i3.Offset update(
    _i6.Direction? direction,
    _i3.Offset? delta,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #update,
          [
            direction,
            delta,
          ],
        ),
        returnValue: _FakeOffset_1(
          this,
          Invocation.method(
            #update,
            [
              direction,
              delta,
            ],
          ),
        ),
        returnValueForMissingStub: _FakeOffset_1(
          this,
          Invocation.method(
            #update,
            [
              direction,
              delta,
            ],
          ),
        ),
      ) as _i3.Offset);
  @override
  void addListener(_i3.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void removeListener(_i3.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #removeListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void notifyListeners() => super.noSuchMethod(
        Invocation.method(
          #notifyListeners,
          [],
        ),
        returnValueForMissingStub: null,
      );
}
