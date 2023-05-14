# Flint - Because `package:lints` wasn't strict enough

[![Flint Build](https://github.com/forus-labs/cauldron/workflows/Flint%20Build/badge.svg)](https://github.com/forus-labs/cauldron/actions?query=workflow%3A%22Flint+Build%22)
[![Pub Dev](https://img.shields.io/pub/v/flint)](https://pub.dev/packages/flint)
[![Documentation](https://img.shields.io/badge/documentation-latest-brightgreen.svg)](https://pub.dev/documentation/flint/latest/)

Lint rules used by Forus Labs.

## Usage

To use a ruleset, add `flint` as a dev dependency in your `pubspec.yaml`.
```yaml
dev_dependencies:
  flint: ^2.7.0
```

Then, add a ruleset to your `analysis_options.yaml`. Flint contains a Dart ruleset & a Flutter ruleset.

To use the Dart ruleset:
```yaml
include: package:flint/analysis_options.dart.yaml
```

To use the Flutter ruleset:
```yaml
include: package:flint/analysis_options.flutter.yaml
```
