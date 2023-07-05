import 'package:flutter/widgets.dart';
import 'package:stevia/widgets.dart';

/// Signature for strategies that build widgets based on asynchronous
/// interaction.
///
/// See also:
///  * [StreamBuilder], which delegates to an [AsyncWidgetBuilder] to build itself based on a snapshot from interacting
///    with a [Stream].
///
///  * [FutureValueBuilder], which delegates to an [AsyncValueBuilder] to build itself based on a snapshot from
///    interacting with a [Future].
typedef AsyncValueBuilder<T> = Widget Function(BuildContext context, Snapshot<T> snapshot, Widget? child);

/// An immutable representation of the most recent interaction with an asynchronous computation.
sealed class Snapshot<T> {
  /// The current state of connection to the asynchronous computation.
  final ConnectionState state;

  const Snapshot._(this.state);

  /// Returns a copy of this [Snapshot] with the given [ConnectionState].
  Snapshot<T> transition({required ConnectionState to});
}

/// An [EmptySnapshot] contains neither a value nor error.
///
/// This is often returned in a [FutureValueBuilder] and [StreamValueBuilder] when no initial value is provided and no
/// value has been returned by the asynchronous computation yet.
final class EmptySnapshot<T> extends Snapshot<T> {
  /// Creates an [EmptySnapshot].
  EmptySnapshot(super.state): super._(); // ignore: prefer_const_constructors, TODO: https://github.com/dart-lang/linter/issues/4531

  @override
  EmptySnapshot<T> transition({required ConnectionState to}) => EmptySnapshot(to);

  @override
  bool operator ==(Object other) => identical(this, other) || other is EmptySnapshot<T> && runtimeType == other.runtimeType
                                 && state == other.state;

  @override
  int get hashCode => state.hashCode;

  @override
  String toString() => 'EmptySnapshot(state: $state)';
}

/// A [ValueSnapshot] contains the latest value produced by an asynchronous computation.
final class ValueSnapshot<T> extends Snapshot<T> {
  /// The latest value produced by an asynchronous computation.
  final T value;

  /// Creates a [ValueSnapshot].
  const ValueSnapshot(super.state, this.value): super._();

  @override
  ValueSnapshot<T> transition({required ConnectionState to}) => ValueSnapshot(to, value);

  @override
  bool operator ==(Object other) => identical(this, other) || other is ValueSnapshot<T> && runtimeType == other.runtimeType &&
    state == other.state &&
    value == other.value;

  @override
  int get hashCode => state.hashCode ^ value.hashCode;

  @override
  String toString() => 'ValueSnapshot(state: $state, value: $value)';
}

/// A [ErrorSnapshot] contains the latest error produced by an asynchronous computation.
final class ErrorSnapshot<T> extends Snapshot<T> {
  /// The latest error object received by the asynchronous computation.
  final Object error;
  /// The latest stack trace object received by the asynchronous computation.
  final StackTrace stackTrace;

  /// Creates an [ErrorSnapshot].
  const ErrorSnapshot(super.state, this.error, [this.stackTrace = StackTrace.empty]): super._();

  @override
  ErrorSnapshot<T> transition({required ConnectionState to}) => ErrorSnapshot(to, error, stackTrace);

  @override
  bool operator ==(Object other) => identical(this, other) || other is ErrorSnapshot &&
    runtimeType == other.runtimeType &&
    state == other.state &&
    error == other.error &&
    stackTrace == other.stackTrace;

  @override
  int get hashCode => state.hashCode ^ error.hashCode ^ stackTrace.hashCode;

  @override
  String toString() => 'ErrorSnapshot(state: $state, error: $error, stackTrace: $stackTrace)';
}
