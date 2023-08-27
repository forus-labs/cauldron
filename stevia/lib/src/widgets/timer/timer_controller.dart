import 'dart:async';

import 'package:flutter/foundation.dart';

/// A timer's controller that periodically emits the remaining microseconds every [interval] until the timer reaches
/// [duration] or zero, depending on whether the controller is ascending or descending.
///
/// The timer can be paused, resumed and reset. It does not automatically start. Users can also be notified of the
/// timer's state by listening to [state].
///
/// No accompanying timer widget is provided. It is expected that users will create their own timer widget tailored to
/// their own use-cases.
/// 
/// A basic timer can be created as follows:
/// ```dart
/// class TimerExample extends StatefulWidget {
///  const TimerExample({super.key});
///  @override
///  _TimerState createState() => _TimerState();
///}
///
///class _TimerState extends State<TimerExample> {
///
///  late TimerController controller;
///
///  @override
///  void initState() {
///    super.initState();
///    controller = TimerController(duration: const Duration(seconds: 30))..run();
///  }
///
///  @override
///  Widget build(BuildContext context) => Column(
///    children: [
///      ValueListenableBuilder(
///        valueListenable: controller,
///        builder: (context, microseconds, child) => Text(TimerController.seconds(microseconds)),
///      ),
///      IconButton(icon: const Icon(Icons.play_arrow), onPressed: controller.run),
///      IconButton(icon: const Icon(Icons.pause), onPressed: controller.pause),
///      IconButton(icon: const Icon(Icons.replay), onPressed: controller.reset),
///    ],
///  );
///
///  @override
///  void dispose() {
///    controller.dispose();
///    super.dispose();
///  }
///
///}
/// ```
sealed class TimerController extends ValueNotifier<int> {

  /// Returns a string representation of the [microseconds], rounded to the nearest second, in the format, "HH:mm:ss".
  ///
  /// For example, 30,120,000 microseconds yields `00:00:30.12`.
  static String seconds(int microseconds) {
    final hours = (microseconds ~/ Duration.microsecondsPerHour).toString().padLeft(2, '0');
    microseconds = microseconds.remainder(Duration.microsecondsPerHour);

    final minutes = (microseconds ~/ Duration.microsecondsPerMinute).toString().padLeft(2, '0');
    microseconds = microseconds.remainder(Duration.microsecondsPerMinute);

    final seconds = (microseconds ~/ Duration.microsecondsPerSecond).toString().padLeft(2, '0');
    microseconds = microseconds.remainder(Duration.microsecondsPerSecond);

    return '$hours:$minutes:$seconds';
  }

  /// The timer's duration.
  final Duration duration;
  /// The interval at which the timer is updated.
  final Duration interval;
  final int _initial;
  final ValueNotifier<TimerState> _state;
  Timer? _timer;

  /// Creates a [TimerController].
  ///
  /// ## Contract
  /// The following will lead to undefined behaviour:
  /// * [duration] is negative
  /// * [interval] is non-positive
  factory TimerController({
    required Duration duration,
    Duration interval = const Duration(seconds: 1),
    bool ascending = false,
  }) => ascending ? _AscendingTimerController(duration, interval, 0) : _DescendingTimerController(duration, interval, duration.inMicroseconds);

  TimerController._(this.duration, this.interval, this._initial):
    assert(0 <= duration.inMicroseconds, 'The duration should be non-negative, but it is $duration.'),
    assert(0 < interval.inMicroseconds, 'The interval should be positive, but it is $interval.'),
    _state = ValueNotifier(TimerState.idle),
    super(_initial);


  /// Starts or resumes the timer if it is idle or paused. Otherwise does nothing.
  void run() {
    final state = _state.value;
    if (state == TimerState.idle || state == TimerState.paused) {
      _state.value = TimerState.running;
      _timer = Timer.periodic(interval, _periodic);
    }
  }

  void _periodic(Timer timer);


  /// Pauses the timer if it is running. Otherwise does nothing.
  void pause() {
    if (_state.value == TimerState.running) {
      _state.value = TimerState.paused;
      _timer?.cancel();
    }
  }

  /// Resets the timer if it is running, paused or done. Otherwise does nothing.
  void reset() {
    if (_state.value != TimerState.idle) {
      value = _initial;
      _state.value = TimerState.idle;
      _timer?.cancel();
    }
  }

  /// The timer's current state.
  ValueListenable<TimerState> get state => _state;

  @override
  void dispose() {
    _timer?.cancel();
    _state.dispose();
    super.dispose();
  }

}

class _AscendingTimerController extends TimerController {
  _AscendingTimerController(super.duration, super.interval, super._initial): super._();

  @override
  void _periodic(Timer timer) {
    final next = value + interval.inMicroseconds;
    if (duration.inMicroseconds <= next) {
      value = duration.inMicroseconds;
      _state.value = TimerState.done;
      timer.cancel();

    } else {
      value = next;
    }
  }
}

class _DescendingTimerController extends TimerController {
  _DescendingTimerController(super.duration, super.interval, super._initial): super._();

  @override
  void _periodic(Timer timer) {
    final next = value - interval.inMicroseconds;
    if (next <= 0) {
      value = 0;
      _state.value = TimerState.done;
      timer.cancel();

    } else {
      value = next;
    }
  }
}


/// The possible timer states.
enum TimerState {
  /// Signifies that the timer has not yet started, or has been reset.
  ///
  /// Possible transitions:
  /// * [idle] -> [running]
  idle,
  /// Signifies that the timer is currently running.
  ///
  /// Possible transitions:
  /// * [running] -> [paused]
  /// * [running] -> [done]
  /// * [running] -> [idle]
  running,
  /// Signifies that the timer is currently paused.
  ///
  /// Possible transitions:
  /// * [paused] -> [running]
  /// * [paused] -> [idle]
  paused,
  /// Signifies that the timer has completed running.
  ///
  /// Possible transitions:
  /// * [done] -> [idle]
  done,
}
