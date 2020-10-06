# Out of Context - Context-free navigation & scaffolds

[![Out of Context Build](https://github.com/forus-labs/cauldron/workflows/Out%20of%20Context%20Build/badge.svg)](https://github.com/forus-labs/cauldron/actions?query=workflow%3A%22Out+of+Context+Build%22)
[![Codecov](https://codecov.io/gh/forus-labs/cauldron/branch/master/graph/badge.svg)](https://codecov.io/gh/forus-labs/cauldron)
[![Pub Dev](https://img.shields.io/pub/v/out_of_context)](https://pub.dev/packages/out_of_context)
[![Documentation](https://img.shields.io/badge/documentation-latest-brightgreen.svg)](https://pub.dev/documentation/out_of_context/latest/)

Navigation in Flutter involves a great deal of ceremony as a `BuilderContext` must always be passed to a `Navigator`.
A `BuilContext` must be passed down from a Widget to the calling method, which is needlessly verbose. It also makes testing
hard as the navigation methods are static and cannot be mocked.

Out of Context provides (over-glorified) wrappers for context-free navigation and scaffolds.

**Please view the [stable brunch](https://github.com/forus-labs/cauldron/tree/stable/out_of_context/) for a production version.**

***
### Using `out_of_context`

To import the library, add the following dependency to your project.

```yaml
dependencies:
  out_of_context: ^1.1.0
```

Then, use any of the `Mixin`s provided.
```dart
import 'package:out_of_context/out_of_context.dart';

class Fancy with DispatcherMixin {

  // router is provided by the DispatcherMixin
  // Look Ma, no BuildContexts!
  void back() => dispatcher.pop();

}
```

***
###  Mock of Context

Mock of Context is a companion project that provides mocks to simplify testing. 

**Please see the project [here](https://pub.dev/packages/mock_of_context).**

