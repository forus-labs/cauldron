class Types {

  static bool isSubtype<T>(dynamic unknown, T type) => unknown is T;

}