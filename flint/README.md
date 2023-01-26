# Flint - Because ~~Pedantic~~ `package:lints` wasn't strict enough

[![Flint Build](https://github.com/forus-labs/cauldron/workflows/Flint%20Build/badge.svg)](https://github.com/forus-labs/cauldron/actions?query=workflow%3A%22Flint+Build%22)
[![Pub Dev](https://img.shields.io/pub/v/flint)](https://pub.dev/packages/flint)
[![Documentation](https://img.shields.io/badge/documentation-latest-brightgreen.svg)](https://pub.dev/documentation/flint/latest/)

**`dart analyze` flavours that are used internally in Forus Labs' Dart & Flutter projects.**

## Using the Lints

To use the lints, add the following dependency in your `pubspec.yaml`.

```yaml
dev_dependencies:
  flint: ^2.6.0
```

Then, add a flavour to your `analysis_options.yaml`. The following will always include the latest version of said flavour.

```yaml
include: package:flint/analysis_options.dart.yaml
```

## Flavours

| Configuration                                 | Description          |
|:----------------------------------------------|:---------------------|
| `package:flint/analysis_options.dart.yaml`    | For Dart projects    |
| `package:flint/analysis_options.flutter.yaml` | For Flutter projects |
