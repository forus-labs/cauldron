
/// B
enum OperatingSystem {

  android,
  fuchsia,
  ios,
  linux,
  macos,
  windows,
  web;

  static OperatingSystem get current => OperatingSystem.web;

  bool call() => this == OperatingSystem.web;

}
