import 'dart:html';

// ignore_for_file: public_member_api_docs

class Runtime {

  const Runtime();

  String get platform => window.navigator.appVersion;

  PlatformType get type => PlatformType.web;

  bool get android => false;

  bool get fuchsia => false;

  bool get ios => false;

  bool get linux => false;

  bool get macos => false;

  bool get windows => false;

  bool get web => true;

}

enum PlatformType {
  android,
  fuchsia,
  ios,
  linux,
  macos,
  windows,
  web,
  unknown,
}
