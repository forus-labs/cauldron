import 'package:sugar/src/time/offset.dart';
import 'package:sugar/time.dart';

class Timezone {

  final String abbreviation;
  final Offset offset;
  final bool dst;

  const Timezone(this.offset, {required this.abbreviation, required this.dst});

}

void a() {
  const Timezone(FastOffset(''), abbreviation: 'a', dst: false);
}