# Mock of Context - Companion project for Out Of Context

![Mock of Context Build](https://github.com/forus-labs/cauldron/workflows/Mock%20of%20Context%20Build/badge.svg)
[![Codecov](https://codecov.io/gh/forus-labs/cauldron/branch/master/graph/badge.svg)](https://codecov.io/gh/forus-labs/cauldron)
[![Pub Dev](https://img.shields.io/pub/v/mock_of_context)](https://pub.dev/packages/mock_of_context)
[![Documentation](https://img.shields.io/badge/documentation-1.0.0-brightgreen.svg)](https://pub.dev/documentation/mock_of_context/latest/)



**Please view the [stable brunch](https://github.com/forus-labs/cauldron/tree/stable/mock_of_context/) for a production version.**

***
### Using `mock_of_context`

To import the library, add the following dependency to your project.

```yaml
dev_dependencies:
  mock_of_context: ^1.0.0
```

Then, use any of the `Mixin`s provided to mock a mixin from `Out of Context`.
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mock_of_context/mock_of_context.dart';

import 'package:out_of_context/out_of_context.dart';

class Fancy with RouterMixin {

  void back() => router.pop();

}

class StubFancy extends Fancy with MockRouterMixin {}

void main() {
  
  test('example', () {
    final fancy = StubFancy()..pop();
    verify(fancy.router.pop());
  });

}
```
