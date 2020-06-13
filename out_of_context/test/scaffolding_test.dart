import 'package:flutter_test/flutter_test.dart';

import 'package:out_of_context/out_of_context.dart';

class Stub with ScaffoldMixin {}

void main() {

  test('scaffold', () => expect(Stub().scaffold, isNull));

}