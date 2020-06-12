# Out of Context - Context-free navigation, scaffolds & snackbars

[![Travis CI](https://img.shields.io/travis/forus-labs/flint/master?logo=travis)](https://travis-ci.com/forus-labs/cauldron)
[![Pub Dev](https://img.shields.io/pub/v/out_of_context)](https://pub.dev/packages/cauldron)

Navigation in Flutter involves a great deal of ceremony as a `BuilderContext` must always be passed to a `Navigator`.
A `BuilContext` must be passed down from a Widget to the calling method, which is needlessly verbose. It also makes testing
hard as the navigation methods are static and cannot be mocked.

`Out of Context` provides (over-glorified) wrappers for context-free navigation and scaffolds.

**Please view the [stable brunch](https://github.com/forus-labs/cauldron/tree/stable/out_of_context/) for a production version.**

***
### Using `out_of_context`

To import the library, add the following dependency to your project.

```yaml
dependencies:
  out_of_context: ^1.0.0
```

Then, use any of the `Mixin`s provided.
```dart
import 'package:out_of_context';

class Fancy with RouterMixin {

  // router is provided by the RouterMixin
  // Look Ma, no BuildContexts!
  void back() => router.pop();

}
```

