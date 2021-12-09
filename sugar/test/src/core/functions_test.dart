import 'package:sugar/sugar.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_dynamic_calls

void main() {

  group('Calls', () {
    test('then', () {
      final order = [];
      (() => order.add(1)).then(() => order.add(2))();

      expect(order, [1, 2]);
    });
  });

  group('Consumers', () {
    test('then', () {
      final order = [];
      ((list) => list.add(1)).then((list) => list.add(2))(order);

      expect(order, [1, 2]);
    });
  });

  group('Mappers', () {
    test('map', () {
      final order = [];
      expect(((list) => list..add(1)).map((list) => list..add(2))(order), [1, 2]);
    });

    test('pipe', () {
      final order = [];
      ((list) => list..add(1)).pipe((list) => list.add(2))(order);
      expect(order, [1, 2]);
    });

    test('test', () {
      final order = [];
      expect(((list) => list..add(1)).test((list) { list.add(2); return true;})(order), true);
      expect(order, [1, 2]);
    });
  });

  group('Predicates', () {
    test('and', () {
      final order = [];
      expect(((list) {list.add(1); return false;}).and((list) {list.add(2); return true;})(order), false);
      expect(order, [1]);
    });

    test('or', () {
      final order = [];
      expect(((list) {list.add(1); return false;}).or((list) {list.add(2); return true;})(order), true);
      expect(order, [1, 2]);
    });

    test('negate', () {
      expect(((_) => true).negate()(null), false);
    });

    test('map', () {
      final order = [];
      expect(((list) => list..add(1)).map((list) => list..add(2))(order), [1, 2]);
      expect(order, [1, 2]);
    });

    test('pipe', () {
      final order = [];
      ((list) => list..add(1)).pipe((list) => list..add(2))(order);
      expect(order, [1, 2]);
    });

  });

  group('Suppliers', () {
    test('map', () => expect((() => 'a').map((a) => '$a b')(), 'a b'));

    test('pipe', () {
      final order = [];
      (() => order..add(1)).pipe((list) => list..add(2))();
      expect(order, [1, 2]);
    });

    test('test', () {
      final order = [];
      expect((() => order..add(1)).test((list) { list.add(2); return true;})(), true);
      expect(order, [1, 2]);
    });
  });

}
