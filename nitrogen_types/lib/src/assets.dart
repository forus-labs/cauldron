/// An asset in a Flutter project's assets directory.
///
/// ## Note:
/// This type should with [Nitrogen](https://github.com/forus-labs/cauldron/nitrogen), a type-safe asset generation tool.
sealed class Asset {
  /// The containing package's name.
  final String? package;

  /// A key that identifies this asset.
  final String key;

  /// A path to this asset, i.e. `assets/icons/application/analysis.svg`.
  final String path;

  /// Creates an [Asset].
  const Asset(this.package, this.key, this.path);
}

/// An image.
///
/// ## Note:
/// This type should with [Nitrogen](https://github.com/forus-labs/cauldron/nitrogen), a type-safe asset generation tool.
final class ImageAsset extends Asset {
  /// Creates a [ImageAsset].
  const ImageAsset(super.package, super.key, super.path);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageAsset &&
          runtimeType == other.runtimeType &&
          package == other.package &&
          key == other.key &&
          path == other.path;

  @override
  int get hashCode => package.hashCode ^ key.hashCode ^ path.hashCode;

  @override
  String toString() => 'ImageAsset{package: $package, key: $key, path: $path}';
}

/// A Lottie animation.
///
/// ## Note:
/// This type should with [Nitrogen](https://github.com/forus-labs/cauldron/nitrogen), a type-safe asset generation tool.
final class LottieAsset extends Asset {
  /// Creates a [LottieAsset].
  const LottieAsset(super.package, super.key, super.path);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LottieAsset &&
          runtimeType == other.runtimeType &&
          package == other.package &&
          key == other.key &&
          path == other.path;

  @override
  int get hashCode => package.hashCode ^ key.hashCode ^ path.hashCode;

  @override
  String toString() => 'LottieAsset{package: $package, key: $key, path: $path}';
}

/// An SVG file.
///
/// ## Note:
/// This type should with [Nitrogen](https://github.com/forus-labs/cauldron/nitrogen), a type-safe asset generation tool.
final class SvgAsset extends Asset {
  /// Creates a [SvgAsset].
  const SvgAsset(super.package, super.key, super.path);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SvgAsset &&
          runtimeType == other.runtimeType &&
          package == other.package &&
          key == other.key &&
          path == other.path;

  @override
  int get hashCode => package.hashCode ^ key.hashCode ^ path.hashCode;

  @override
  String toString() => 'SvgAsset{package: $package, key: $key, path: $path}';
}

/// A default asset for file extensions not directly supported by the other [Asset]s.
///
/// ## Note:
/// This type should with [Nitrogen](https://github.com/forus-labs/cauldron/nitrogen), a type-safe asset generation tool.
final class GenericAsset extends Asset {
  /// Creates a [GenericAsset].
  const GenericAsset(super.package, super.key, super.path);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GenericAsset &&
          runtimeType == other.runtimeType &&
          package == other.package &&
          key == other.key &&
          path == other.path;

  @override
  int get hashCode => package.hashCode ^ key.hashCode ^ path.hashCode;

  @override
  String toString() => 'GenericAsset{package: $package, key: $key, path: $path}';
}
