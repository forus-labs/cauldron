## 2.0.0 - The Stubbed Contexts (28/06/2021)

Update the project to support null safety. As a result of this update, most of our mocks
are now stubs...

- Change `MockDispatcher` to `StubNavigation`
- Change `MockDispatcherMixin` to `StubNavigationMixin`
- Change `MockSaccfoldMixin` to `StubScaffoldMixin`
- Change `MockScaffoldState` to `StubScaffoldState`

## 1.2.0 - The Cascading Effect (06/10/2020)

Flutter introduced a `Router` in a recent update. We have to rename _our_ `Router` to
prevent a naming conflict.

- Change `MockRouter` to `MockDispatcher`

## 1.1.0 - Ch-ch-changes (15/0/8/2020)
This update adds a mixin for mocking `ChangeNotifier`.

- Add `MockNotifier`
- Add `MockNotifierMixin`

## 1.0.0 - Initial Launch! 🚀

- Add `MockRouterMixin`
- Add `MockScaffoldMixin`
- Add `MockScaffoldState`