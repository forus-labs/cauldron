// ignore_for_file: public_member_api_docs

import 'dart:io';

import 'package:meta/meta.dart';

class System {
  @useResult
  static DateTime Function() currentDateTime = DateTime.now;

  @useResult
  static int get epochMilliseconds => currentDateTime().millisecondsSinceEpoch;

  @useResult
  static int get epochMicroseconds => currentDateTime().microsecondsSinceEpoch;

  const System();

  String get platform => Platform.operatingSystemVersion;

  PlatformType get type => PlatformType._cache ??= PlatformType._current;

  bool get android => Platform.isAndroid;

  bool get fuchsia => Platform.isFuchsia;

  bool get ios => Platform.isIOS;

  bool get linux => Platform.isLinux;

  bool get macos => Platform.isMacOS;

  bool get windows => Platform.isWindows;

  bool get web => false;
}

enum PlatformType {
  android,
  fuchsia,
  ios,
  linux,
  macos,
  windows,
  web,
  unknown;

  // This assumes that the current platform cannot be changed mid-way through the programme's lifetime.
  static PlatformType? _cache;
  static PlatformType get _current {
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
      return unknown;
    }
  }
}
