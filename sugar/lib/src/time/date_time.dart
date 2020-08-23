import 'package:sugar/time.dart';

mixin Chronological {

}



void main() {
  final now = DateTime.now();
  final ms = now.microsecondsSinceEpoch;
  final remainder = ms % Day.microseconds;

  print(now);
  // What about UTC -X zones?
  print(DateTime.fromMicrosecondsSinceEpoch(ms - remainder - now.timeZoneOffset.inMicroseconds).toString());
  print(ms);
  print(ms - remainder - now.timeZoneOffset.inMicroseconds);
}