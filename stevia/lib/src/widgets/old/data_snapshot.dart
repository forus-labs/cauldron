import 'package:flutter/widgets.dart';
import 'package:stevia/stevia.dart';

/// Signature for strategies that build widgets based on asynchronous
/// interaction.
///
/// See also:
///  * [StreamDataBuilder], which delegates to an [AsyncDataWidgetBuilder] to build
///    itself based on a snapshot from interacting with a [Stream].
///  * [FutureDataBuilder], which delegates to an [AsyncDataWidgetBuilder] to build
///    itself based on a snapshot from interacting with a [Future].
typedef AsyncDataWidgetBuilder<T> = Widget Function(BuildContext context, DataSnapshot<T> snapshot, Widget? child);

/// A representation of the most recent interaction with an asynchronous computation.
///
/// This analogous to an [AsyncSnapshot] but with numerous improvements.
///
/// ## Motivation
///
/// An [AsyncSnapshot] stores the current state in a field, [AsyncSnapshot.connectionState] and data in a nullable field,
/// [AsyncSnapshot.data]. This makes retrieving data from an [AsyncSnapshot] cumbersome.
///
/// ```dart
/// Widget builder(BuildContext context, AsyncSnapshot<String?> snapshot) => switch (snapshot) {
///   AsyncSnapshot(:final data, :final state) when state == ConnectionState.active || state == ConnectionState.done =>
///     Text(data ?? 'something'),
///   _ => Container(),
/// }
/// ```
///
/// A [DataSnapshot] represents the various states as an algebraic sum type instead. This makes retrieving data more natural.
/// The above code snippet can be rewritten as:
/// ```dart
/// Widget builder(BuildContext context, DataSnapshot<String?> snapshot) => switch (snapshot) {
///   ValueSnapshot(:final value) => Text(data ?? 'something'), // bonus: T isn't converted to T?
///   _ => Container(),
/// }
/// ```
///
/// See [FutureDataBuilder] and [StreamDataBuilder] for more information.
sealed class DataSnapshot<T> {
  /// The current state of connection to the asynchronous computation.
  final ConnectionState state;

  const DataSnapshot._(this.state);
}

/// An empty [DataSnapshot].
///
/// It is always in either [ConnectionState.none] or [ConnectionState.waiting].
final class EmptySnapshot extends DataSnapshot<Object?> {
  /// Creates an [EmptySnapshot] in [ConnectionState.none].
  const EmptySnapshot.none(): super._(ConnectionState.none);

  /// Creates an [EmptySnapshot] in [ConnectionState.waiting].
  const EmptySnapshot.waiting(): super._(ConnectionState.waiting);
}

/// A [ValueSnapshot] represents either a initial value or a successful asynchronous computation that produced a value.
final class ValueSnapshot<T> extends DataSnapshot<T> {
  /// The value of the asynchronous computation.
  final T value;

  /// Creates an [ValueSnapshot] with value and state.
  const ValueSnapshot(this.value, super.state): super._();
}

/// An [ErrorSnapshot] represents a failed asynchronous computation that produced an error.
///
/// It is always in either [ConnectionState.active] or [ConnectionState.done].
final class ErrorSnapshot extends DataSnapshot<Object?> {
  /// The error produced.
  final Object error;
  /// The error's stacktrace.
  final StackTrace stackTrace;

  /// Creates an [ErrorSnapshot] with the [error] and [stackTrace] in [ConnectionState.active].
  const ErrorSnapshot.active(this.error, [this.stackTrace = StackTrace.empty]): super._(ConnectionState.active);

  /// Creates an [ErrorSnapshot] with the [error] and [stackTrace] in [ConnectionState.done].
  const ErrorSnapshot.done(this.error, [this.stackTrace = StackTrace.empty]): super._(ConnectionState.done);
}