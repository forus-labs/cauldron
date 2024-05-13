/// An asset in a Flutter project's assets directory.
///
/// **Note: **
/// This type should with [Nitrogen](https://github.com/forus-labs/cauldron/nitrogen), a type-safe asset generation tool.
sealed class Asset {
  /// The containing package's name.
  final String? package;
  /// A key that identifies this asset. All keys in a single package are unique.
  final String key;
  /// A path to this asset, i.e. `assets/icons/application/analysis.svg`.
  final String path;

  /// Creates an [Asset].
  const Asset(this.package, this.key, this.path);
}

/// An image.
///
/// **Note: **
/// This type should with [Nitrogen](https://github.com/forus-labs/cauldron/nitrogen), a type-safe asset generation tool.
final class ImageAsset extends Asset {
  /// Creates a [ImageAsset].
  ImageAsset(super.package, super.key, super.path);
}

/// A Lottie animation.
///
/// **Note: **
/// This type should with [Nitrogen](https://github.com/forus-labs/cauldron/nitrogen), a type-safe asset generation tool.
final class LottieAsset extends Asset {
  /// Creates a [LottieAsset].
  LottieAsset(super.package, super.key, super.path);
}

/// An SVG file.
///
/// **Note: **
/// This type should with [Nitrogen](https://github.com/forus-labs/cauldron/nitrogen), a type-safe asset generation tool.
final class SvgAsset extends Asset {
  /// Creates a [SvgAsset].
  SvgAsset(super.package, super.key, super.path);
}


/// A default asset for file extensions not directly supported by the other [Asset]s.
///
/// **Note: **
/// This type should with [Nitrogen](https://github.com/forus-labs/cauldron/nitrogen), a type-safe asset generation tool.
final class UnknownAsset extends Asset {
  /// Creates a [UnknownAsset].
  UnknownAsset(super.package, super.key, super.path);
}
