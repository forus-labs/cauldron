import 'package:flutter/widgets.dart';
import 'package:stevia/stevia.dart';

class FutureDataBuilder<T> extends StatefulWidget {
  /// The asynchronous computation to which this builder is currently connected.
  ///
  /// If no future has yet completed, including in the case where [future] is null, the data provided to the [builder]
  /// will be set to [initial].
  final Future<T>? future;
  final (T,)? initial;
  /// The build strategy currently used by this builder.
  ///
  /// The builder is provided with a [DataSnapshot] whose [DataSnapshot.state] property will be one of the following values:
  ///
  ///  * [ConnectionState.none]: [future] is null. If [initial] is not null, returns a [ValueSnapshot] with [initial]'s
  ///    value, otherwise returns a [EmptySnapshot.none].
  ///
  ///  * [ConnectionState.waiting]: [future] is not null, but has not yet completed. If [initial] is not null, returns a
  ///   [ValueSnapshot] with [initial]'s value, otherwise returns a [EmptySnapshot.waiting].
  ///
  ///  * [ConnectionState.done]: [future] is not null, and has completed. If the future completed successfully, returns
  ///    a [ValueSnapshot]. Otherwise returns a [ErrorSnapshot] if the future completed with an error.
  ///
  /// This builder must only return a widget and should not have any side effects as it may be called multiple times.
  final AsyncDataWidgetBuilder<T> builder;
  /// A [FutureDataBuilder]-independent widget which is passed back to the [builder].
  ///
  /// This argument is optional and can be null if the entire widget subtree the [builder] builds depends on the value
  /// of the [future]. For example, in the case where the [future] is a [String] and the [builder] returns a [Text] widget
  /// with the current [String] value, there would be no useful [child].
  final Widget? child;

  FutureDataBuilder({
    super.key,
    required this.future,
    required this.builder,
    this.child,
  }): initial = null;

  FutureDataBuilder.initially(
    T initial, {
    super.key,
    required this.future,
    required this.builder,
    this.child,
  }): initial = (initial,);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }

}

class AsyncBuilder {
  AsyncBuilder.future({
    super.key,
    required this.future,
    required this.builder,
    this.child,
  }): initial = null;
}

void a() => FutureDataBuilder.initially(
  [],
  future: future,
  builder: builder,
)

