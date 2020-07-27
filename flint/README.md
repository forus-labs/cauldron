# Flint - Because Pedantic wasn't strict enough

![Flint Build](https://github.com/forus-labs/cauldron/workflows/Flint%20Build/badge.svg)
[![Codecov](https://codecov.io/gh/forus-labs/cauldron/branch/master/graph/badge.svg)](https://codecov.io/gh/forus-labs/cauldron)
[![Pub Dev](https://img.shields.io/pub/v/flint)](https://pub.dev/packages/flint)
[![Documentation](https://img.shields.io/badge/documentation-1.1.1-brightgreen.svg)](https://pub.dev/documentation/flint/latest/)

**Forus Labs' `dartanalyzer` configurations that are used internally in our Dart & Flutter projects.**

**Please view the [stable brunch](https://github.com/forus-labs/cauldron/tree/stable/flint/) for a production version.**

***
### Using the Lints

To use the lints, add the following dependency in your `pubspec.yaml`.

```yaml
dev_dependencies:
  flint: ^1.1.1  
```

Then, add a configuration to your `analysis_options.yaml`. The following will always include the latest version of said set.

```yaml
include: package:flint/analysis_options.dart.dev.yaml
```

***
### Configurations

| Configuration                                                 | Description                                        |
| :--------------------------------------------------- | :------------------------------------------------- |
| `package:flint/analysis_options..dart.dev.yaml`       | `master` branch of a Dart project                  |
| `package:flint/analysis_options.dart.stable.yaml`    | `staging` and `stable` branch of a Dart project    |
| `package:flint/analysis_options.flutter.dev.yaml`    | `master` branch of a Flutter project               |
| `package:flint/analysis_options.flutter.stable.yaml` | `staging` and `stable` branch of a Flutter project |


