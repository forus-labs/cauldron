extension Booleans on bool {

  int toInt() => this ? 1 : 0;

}

extension Integers on int {

  bool toBool() => this != 0;

}

extension Doubles on double {

  bool close(double epsilon, {required double to}) => (this - to).abs() < epsilon;

}


void a() {
  0.0.close(to: 1.0, 0.0001);
}

