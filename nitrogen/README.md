# Nitrogen

Modern, type-safe generated bindings for accessing your Flutter assets.
* Custom prefixes for generated classes.
* Option for generating additional utilities.
* Option for generating assets as package dependency.
* Support for 3rd party packages such as `flutter_svg` and `lottie`.
* Support for themes.

## Motivation

Using raw strings to access assets is error-prone. Suppose you define an image in your pubspec.yaml:
```yaml
flutter:
  assets:
    - assets/images/foo.png
```

And you access in your application:
```dart
Widget build(BuildContext context) => Image.asset('assets/images/foo.png');
```

What if you:
* Change the name of the image?
* Change the location of the image?
* Delete the image?
* Misspell the path?

The above code snippet now throws an exception. You won't know either unless you re-run the widget.

Nitrogen generates bindings that are safe:
```dart
Widget build(BuildContext context) => Assets.images.foo();
```

## Getting started

3rd party packages are supported via 'extension' packages. `extension` packages contain an `extension` that provide a 
`call(...)` function that transforms an `Asset` into a 3rd party type.

| Type              | Package       | Extension Package      | Version                                                                                                        |
|-------------------|---------------|------------------------|----------------------------------------------------------------------------------------------------------------|
| SVG images        | `flutter_svg` | `nitrogen_flutter_svg` | [![Pub Dev](https://img.shields.io/pub/v/nitrogen_flutter_svg)](https://pub.dev/packages/nitrogen_flutter_svg) |
| Lottie animations | `lottie`      | `nitrogen_lottie`      | [![Pub Dev](https://img.shields.io/pub/v/nitrogen_lottie)](https://pub.dev/packages/nitrogen_lottie)           |


Install the following:
```yaml
dependencies:
  nitrogen_types: <version>
  nitrogen_flutter_svg: <version> # Optional: include when using SVG images
  nitrogen_lottie: <version> # Optional: include when using Lottie animations

dev_dependencies:
  build_runner: <version>
  nitrogen: <version>
```

Alternatively:
```shell
# Include nitrogen_flutter_svg and nitrogen_lottie when using SVG images and Lottie animations respectively.
dart pub add nitrogen_types  nitrogen_flutter_svg nitrogen_lottie

dart pub add --dev build_runner nitrogen
```

To generate bindings:
```shell
dart run build_runner build
```

## Configuration

Nitrogen's configuration can be set in the `nitrogen` section of your build.yaml. In most cases, the default
configuration works out of the box.

### Example

A simple configuration looks like:
```yaml
targets:
  $default:
    builders:
      nitrogen:
        options:
          package: true
          prefix: 'MyPrefix'
          key: file-name
          assets:
            output: 'lib/src/assets.nitrogen.dart'
          themes:
            output: 'lib/src/asset_themes.nitrogen.dart'
            fallback: assets/themes/light
```

### `package`

Optional. Defaults to `false`. Controls whether to generate assets as a package dependency. This should be `true` if 
you're bundling assets for other projects to use, i.e. [forui-assets](https://github.com/forus-labs/forui).

### `prefix`

Optional. Defaults to an empty string. Controls generated classes' prefixes. Given 'MyPrefix', the generated classes will
look like:
```dart
class MyPrefixAssets {
  const MyPrefixAssets();

  static const Map<String, Asset> contents = {};

  static $MyPrefixAssetsIcons get icons => const $MyPrefixAssetsIcons();
}
```

### `key`

Optional. Defaults to `file`. Controls the generated assets' key parameters. The following options are supported:

| Option    | Description                                           | Path                    | Generated Key |
|-----------|-------------------------------------------------------|-------------------------|---------------|
| file-name | file name, without the extension                      | `assets/images/foo.png` | `foo`         |
| grpc-enum | parent directory and file name, without the extension | `assets/images/foo.png` | `IMAGES_FOO`  |

### `assets`

Optional. Controls the location of the generated assets file.

```yaml
assets:
  # Path to the generated assets file. Relative to the project root. Defaults to `lib/src/assets.nitrogen.dart`.
  output: lib/src/my/path/assets.nitrogen.dart
``` 

### `themes`

Optional. Defaults to `null`. Controls whether to generate an additional `asset_themes.nitrogen.dart` file. Useful for 
working with theme-specific assets.

```yaml
themes:
  # Path to the generated themes file. Relative to the project root. Defaults to `lib/src/asset_themes.nitrogen.dart`.
  output: lib/src/my/path/assets_themes.nitrogen.dart
  # Path to fallback theme, relative to package root. Assumes that all themes are under 'assets/themes'.
  fallback: assets/themes/light
```
