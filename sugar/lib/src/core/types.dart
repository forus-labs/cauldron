extension TypeComparison on Object {

  bool subclassOf<T>(T instance) => this is T;

}