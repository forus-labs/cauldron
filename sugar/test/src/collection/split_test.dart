import 'package:sugar/collection.dart';

void main() {
  [1, 2, 3].split.window(5, by: 1);

  print(a);
  f.add(4);
  print(a);
}

bool Function(E) memomize<E>() {
  var count = 0;
  return (e) {
    count++;
    print(count);
    return true;
  };
}