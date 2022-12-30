import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart' as crypto show sha256;
import 'package:sugar/core.dart';

/// Generates a random nonce.
String nonce([int length = 32]) {
  const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';

  final random = Random.secure();
  return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
}

/// An extension that provides additional hashing methods.
extension HashExtensions on String {

  /// Returns the sha256 hash of `this` in hex notation.
  String get sha256 => crypto.sha256.convert(utf8.encode(this)).toString();

}
