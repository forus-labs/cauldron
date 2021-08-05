import 'dart:html';

extension ComposableFunction on VoidCallback {

  VoidCallback then(VoidCallback next) => () {
    this();
    next();
  };

}