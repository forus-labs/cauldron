## 1.1.1 - I messed up (06/10/2020)

This update includes documentation that was accidentally omitted when publishing the previous update.

## 1.1.0 - Viva la Dispatcher (06/10/2020)

Flutter introduced a `Router` in a recent update. We have to rename _our_ `Router` to
prevent a naming conflict.

- Change `Keyed` to be exported
- Change `Router` to `Dispatcher`
- Change `RouterMixin` to `DispatcherMixin`

## 1.0.2 - Bumpity Bump (15/08/2020)

- Add Flutter version constraint
- Change minimum Dart version from `2.8.4` to `2.9.0`

## 1.0.1 - No context is best context (13/06/2020)

- Fix missing example/pubspec.yaml
- Fix relative path for Flint


## 1.0.0 - How can mirrors be real if our eyes aren't real? (13/06/2020)

- Add `Keyed`
- Add `Router`
- Add `RouterMixin`
- Add `ScaffoldMixin`