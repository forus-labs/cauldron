import 'dart:convert';
import 'dart:io';

import 'package:sugar/src/time/zone/names.g.dart';

void main() {
  while (true) {
    final line = stdin.readLineSync(encoding: utf8) ?? '';
    final timezone = location(line);
    print(timezone.name);
    // print(line);
  }
}