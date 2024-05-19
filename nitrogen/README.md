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

3rd party packages are supported via 'extension' packages:

| Type              | Package       | Extension Package      | 
|-------------------|---------------|------------------------|
| SVG images        | `flutter_svg` | `nitrogen_flutter_svg` |
| Lottie animations | `lottie`      | `nitrogen_lottie`      |

Install the following:
```yaml
dependencies:
  nitrogen_types: <version>

dev_dependencies:
  build_runner: <version>
  nitrogen: <version>
  nitrogen_flutter_svg: <version> # Optional: include when using SVG images
  nitrogen_lottie: <version> # Optional: include when using Lottie animations
```

Alternatively:
```shell
dart pub add nitrogen_types

# Include nitrogen_flutter_svg and nitrogen_lottie when using SVG images and Lottie animations respectively.
dart pub add --dev build_runner nitrogen nitrogen_flutter_svg nitrogen_lottie
```

To generate bindings:
```shell
dart run build_runner build
```

## Configuration

Nitrogen's configuration can be set in the `nitrogen` section of your pubspec.yaml. For most cases, the default
configuration works out of the box.

### Example

A simple configuration looks like:
```yaml
nitrogen:
  use-package: true
  prefix: 'MyPrefix'
  asset-key: file
  asset-generation:
    theme:
      path: assets/themes
      fallback: light
```

### `use-package`

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

### `asset-key`

Optional. Defaults to `file`. Controls the generated assets' key parameters. The following options are supported:

| Option    | Description                                           | Path                    | Generated Key |
|-----------|-------------------------------------------------------|-------------------------|---------------|
| file      | file name, without the extension                      | `assets/images/foo.png` | `foo`         |
| grpc-enum | parent directory and file name, without the extension | `assets/images/foo.png` | `IMAGES_FOO`  |


### `asset-generation`

Optional. Defaults to `standard`. Controls the structure of generated classes. The following options are supported:

#### Basic: 

Generates bare-bones classes without additional utilities.
```yaml
nitrogen:
  asset-generation: basic
```

#### Standard (default):

Generates classes with an additional `contents` map for working with assets in that directory.
```yaml
nitrogen:
  asset-generation: standard
```

#### Theme: 

Generates an additional `asset_themes.nitrogen.dart` file. Useful for working with theme-specific assets.
```yaml
nitrogen:
  asset-generation:
    theme:
      path: assets/themes # Path to themes, relative to package root. Assumes all themes are directly under assets/themes.
      fallback: light # A fallback theme for when a asset is not specified, relative to 'path', i.e. assets/themes/light.
```
