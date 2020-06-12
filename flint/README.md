# Flint: Because Pedantic wasn't strict enough

[![Travis CI](https://img.shields.io/travis/forus-labs/flint/master?logo=travis)](https://travis-ci.com/forus-labs/flint)
[![Pub Dev](https://img.shields.io/pub/v/flint)](https://pub.dev/packages/flint)

Flint contains Forus Labs' different sets of `dartanalyzer` lints that we use internally in our Dart & Flutter projects.

## Using the Lints

To use the lints, add a dependency in your `pubspec.yaml`.

```yaml
dev_dependencies:
  flint: ^1.0.3  
```

Then, add the the set of lints to your `analysis_options.yaml`. The following will always include the latest version of the specified set of lints.

```yaml
include: package:flint/dart/dev/analysis_options.yaml
```

A specific version of a set of lints can also be used via:
```yaml
include: package:flint/dart/dev/analysis_options.1.0.3.yaml
```

The following sets of lints are available:

| Lint                                                 | Description                          |
| :--------------------------------------------------- | :----------------------------------- |
| `package:flint/dart/dev/analysis_options.yaml`       | `master` branch of a Dart project    |
| `package:flint/dart/stable/analysis_options.yaml`    | `stable` branch of a Dart project    |
| `package:flint/flutter/dev/analysis_options.yaml`    | `master` branch of a Flutter project |
| `package:flint/flutter/stable/analysis_options.yaml` | `stable` branch of a Flutter project |


