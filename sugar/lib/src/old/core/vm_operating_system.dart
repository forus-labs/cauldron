import 'dart:io';

///
enum OperatingSystem {

  a;

  static String get current {
    if (Platform.isAndroid) {
      return android;
    } else if (Platform.isFuchsia) {
      return fuchsia;
    } else if (Platform.isIOS) {
      return ios;
    } else if (Platform.isLinux) {
      return linux;
    } else if (Platform.isMacOS) {
      return macos;
    } else if (Platform.isWindows) {
      return windows;
    } else {
      throw UnsupportedError('Unsupported operating system: ${Platform.operatingSystem}');
    }
  }

  bool call() => this == current;

}