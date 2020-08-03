const _whitespace = 32;

extension Strings on String {

  String capitalize() {
    if (isBlank) {
      return this;

    } else if (length == 1){
      return toUpperCase();

    } else {
      return this[0].toUpperCase() + substring(1);
    }
  }

  bool equalsIgnoreCase(String other) => toLowerCase() == other.toLowerCase();


  bool get isBlank => isEmpty || codeUnits.every((unit) => unit == _whitespace);

  bool get isNotBlank => !isBlank;

}