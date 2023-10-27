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
/// class _TimerState extends State<TimerExample> {
///   late TimerController controller;
///
///   @override
///   void initState() {
///     super.initState();
///     controller = TimerController(duration: const Duration(seconds: 30))..run();
///   }
///
///   @override
///   Widget build(BuildContext context) => Column(
///     children: [
///       ValueListenableBuilder(
///         valueListenable: controller,
///         builder: (context, microseconds, child) => Text('$microseconds'),
///       ),
///       IconButton(icon: const Icon(Icons.play_arrow), onPressed: controller.run),
///       IconButton(icon: const Icon(Icons.pause), onPressed: controller.pause),
///       IconButton(icon: const Icon(Icons.replay), onPressed: controller.reset),
///     ],
///   );
///
///   @override
///   void dispose() {
///     controller.dispose();
///     super.dispose();
///   }
/// }
/// ```
sealed class TimerController extends ValueNotifier<int> {
  /// The timer's duration.
  final Duration duration;
  /// The interval at which the timer is updated.
  final Duration interval;
  final int _initial;
  final ValueNotifier<TimerState> _state;

  /// Creates a [TimerController].
  ///
  /// ## Contract
  /// A non-positive [interval]  will lead to undefined behaviour.
  factory TimerController({
    required Duration duration,
    Duration interval = const Duration(seconds: 1),
    bool ascending = false,
  }) {
    if (duration.inMicroseconds <= 0) {
      return _EmptyController(duration, interval);
    }

    if (ascending) {
      return _AscendingTimerController(duration, interval, 0);

    } else {
      return _DescendingTimerController(duration, interval, duration.inMicroseconds);
    }
  }

  TimerController._(this.duration, this.interval, this._initial, [TimerState state = TimerState.idle]):
    assert(0 < interval.inMicroseconds, 'The interval should be positive, but it is $interval.'),
    _state = ValueNotifier(state),
    super(_initial);


  /// Starts or resumes the timer if it is idle or paused. Otherwise does nothing.
  void run();

  /// Pauses the timer if it is running. Otherwise does nothing.
  void pause();

  /// Resets the timer if it is running, paused or done, and [duration] is not zero. Otherwise does nothing.
  void reset();


  /// The timer's current state.
  ValueListenable<TimerState> get state => _state;

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
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


class _EmptyController extends TimerController {
  _EmptyController(Duration duration, Duration interval): super._(duration, interval, 0, TimerState.done);

  @override
  void run() {}

  @override
  void pause() {}

  @override
  void reset() {}
}


sealed class _Controller extends TimerController {
  Timer? _timer;

  _Controller(super.duration, super.interval, super._initial): super._();

  @override
  void run() {
    final state = _state.value;
    if (state == TimerState.idle || state == TimerState.paused) {
      _state.value = TimerState.running;
      _timer = Timer.periodic(interval, _periodic);
    }
  }

  void _periodic(Timer timer);


  @override
  void pause() {
    if (_state.value == TimerState.running) {
      _state.value = TimerState.paused;
      _timer?.cancel();
    }
  }

  @override
  void reset() {
    if (_state.value != TimerState.idle) {
      value = _initial;
      _state.value = TimerState.idle;
      _timer?.cancel();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class _AscendingTimerController extends _Controller {
  _AscendingTimerController(super.duration, super.interval, super._initial);

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

class _DescendingTimerController extends _Controller {
  _DescendingTimerController(super.duration, super.interval, super._initial);

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
