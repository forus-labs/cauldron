import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stevia/stevia.dart';

void main() {

  test('seconds(...)', () => expect(TimerController.seconds(30120000), '00:00:30'));

  for (final (i, function) in [
    () => TimerController(duration: const Duration(seconds: 1), interval: Duration.zero),
  ].indexed) {
    test('[$i] assertions', () => expect(function, throwsAssertionError));
  }

  group('idle state', () {
    test('ascending', () => expect(TimerController(
      duration: const Duration(microseconds: 1),
      interval: const Duration(microseconds: 1),
      ascending: true,
    ).value, 0));

    test('descending', () => expect(TimerController(
      duration: const Duration(microseconds: 1),
      interval: const Duration(microseconds: 1),
    ).value, 1));

    test('run()', () {
      fakeAsync((async) {
        final controller = TimerController(duration: const Duration(days: 1), ascending: true);
        expect(controller.state.value, TimerState.idle);

        controller.run();
        async.elapse(const Duration(seconds: 10));

        expect(controller.state.value, TimerState.running);
        expect(controller.value, 10 * Duration.microsecondsPerSecond);
      });
    });

    test('pause()', () {
      fakeAsync((async) {
        final controller = TimerController(duration: const Duration(days: 1), ascending: true);
        expect(controller.state.value, TimerState.idle);

        controller.pause();
        async.elapse(const Duration(seconds: 10));

        expect(controller.state.value, TimerState.idle);
        expect(controller.value, 0);
      });
    });

    test('reset()', () {
      fakeAsync((async) {
        final controller = TimerController(duration: const Duration(days: 1), ascending: true);
        expect(controller.state.value, TimerState.idle);

        controller.reset();
        async.elapse(const Duration(seconds: 10));

        expect(controller.state.value, TimerState.idle);
        expect(controller.value, 0);
      });
    });

    test('done', () {
      fakeAsync((async) {
        final controller = TimerController(duration: const Duration(days: 1), ascending: true);
        expect(controller.state.value, TimerState.idle);
        expect(controller.value, 0);

        async.elapse(const Duration(days: 10));

        expect(controller.state.value, TimerState.idle);
        expect(controller.value, 0);
      });
    });
  });

  group('running state', () {
    test('run() ascending', () {
      fakeAsync((async) {
        final controller = TimerController(duration: const Duration(days: 1), ascending: true)..run();
        async.elapse(const Duration(seconds: 10));

        expect(controller.state.value, TimerState.running);
        expect(controller.value, 10 * Duration.microsecondsPerSecond);

        controller.run();

        async.elapse(const Duration(seconds: 10));

        expect(controller.state.value, TimerState.running);
        expect(controller.value, 20 * Duration.microsecondsPerSecond);
      });
    });

    test('run() descending', () {
      fakeAsync((async) {
        final controller = TimerController(duration: const Duration(days: 1))..run();
        async.elapse(const Duration(seconds: 10));

        expect(controller.state.value, TimerState.running);
        expect(controller.value, Duration.microsecondsPerDay - 10 * Duration.microsecondsPerSecond);

        controller.run();

        async.elapse(const Duration(seconds: 10));

        expect(controller.state.value, TimerState.running);
        expect(controller.value, Duration.microsecondsPerDay - 20 * Duration.microsecondsPerSecond);
      });
    });

    test('pause()', () {
      fakeAsync((async) {
        final controller = TimerController(duration: const Duration(days: 1), ascending: true)..run();
        async.elapse(const Duration(seconds: 10));

        expect(controller.state.value, TimerState.running);
        expect(controller.value, 10 * Duration.microsecondsPerSecond);

        controller.pause();

        async.elapse(const Duration(seconds: 10));

        expect(controller.state.value, TimerState.paused);
        expect(controller.value, 10 * Duration.microsecondsPerSecond);
      });
    });

    test('reset()', () {
      fakeAsync((async) {
        final controller = TimerController(duration: const Duration(days: 1), ascending: true)..run();
        async.elapse(const Duration(seconds: 10));

        expect(controller.state.value, TimerState.running);
        expect(controller.value, 10 * Duration.microsecondsPerSecond);

        controller.reset();

        async.elapse(const Duration(seconds: 10));

        expect(controller.state.value, TimerState.idle);
        expect(controller.value, 0);
      });
    });

    test('done ascending', () {
      fakeAsync((async) {
        final controller = TimerController(duration: const Duration(days: 1), ascending: true)..run();
        async.elapse(const Duration(seconds: 10));

        expect(controller.state.value, TimerState.running);
        expect(controller.value, 10 * Duration.microsecondsPerSecond);

        async.elapse(const Duration(days: 10));

        expect(controller.state.value, TimerState.done);
        expect(controller.value, Duration.microsecondsPerDay);
      });
    });

    test('done ascending', () {
      fakeAsync((async) {
        final controller = TimerController(duration: const Duration(days: 1), ascending: true)..run();
        async.elapse(const Duration(seconds: 10));

        expect(controller.state.value, TimerState.running);
        expect(controller.value, 10 * Duration.microsecondsPerSecond);

        async.elapse(const Duration(days: 10));

        expect(controller.state.value, TimerState.done);
        expect(controller.value, Duration.microsecondsPerDay);
      });
    });

    test('done descending', () {
      fakeAsync((async) {
        final controller = TimerController(duration: const Duration(days: 1))..run();
        async.elapse(const Duration(seconds: 10));

        expect(controller.state.value, TimerState.running);
        expect(controller.value, Duration.microsecondsPerDay - 10 * Duration.microsecondsPerSecond);

        async.elapse(const Duration(days: 10));

        expect(controller.state.value, TimerState.done);
        expect(controller.value, 0);
      });
    });
  });

  group('paused state', () {
    test('run()', () {
      fakeAsync((async) {
        final controller = TimerController(duration: const Duration(days: 1), ascending: true)..run();
        async.elapse(const Duration(seconds: 10));
        controller.pause();

        expect(controller.state.value, TimerState.paused);
        expect(controller.value, 10 * Duration.microsecondsPerSecond);

        controller.run();

        async.elapse(const Duration(seconds: 10));

        expect(controller.state.value, TimerState.running);
        expect(controller.value, 20 * Duration.microsecondsPerSecond);
      });
    });

    test('pause()', () {
      fakeAsync((async) {
        final controller = TimerController(duration: const Duration(days: 1), ascending: true)..run();
        async.elapse(const Duration(seconds: 10));
        controller.pause();

        expect(controller.state.value, TimerState.paused);
        expect(controller.value, 10 * Duration.microsecondsPerSecond);

        controller.pause();

        async.elapse(const Duration(seconds: 10));

        expect(controller.state.value, TimerState.paused);
        expect(controller.value, 10 * Duration.microsecondsPerSecond);
      });
    });

    test('reset()', () {
      fakeAsync((async) {
        final controller = TimerController(duration: const Duration(days: 1), ascending: true)..run();
        async.elapse(const Duration(seconds: 10));
        controller.pause();

        expect(controller.state.value, TimerState.paused);
        expect(controller.value, 10 * Duration.microsecondsPerSecond);

        controller.reset();

        async.elapse(const Duration(seconds: 10));

        expect(controller.state.value, TimerState.idle);
        expect(controller.value, 0);
      });
    });

    test('done', () {
      fakeAsync((async) {
        final controller = TimerController(duration: const Duration(days: 1), ascending: true)..run();
        async.elapse(const Duration(seconds: 10));
        controller.pause();

        expect(controller.state.value, TimerState.paused);
        expect(controller.value, 10 * Duration.microsecondsPerSecond);

        async.elapse(const Duration(days: 10));

        expect(controller.state.value, TimerState.paused);
        expect(controller.value, 10 * Duration.microsecondsPerSecond);
      });
    });
  });

  group('done', () {
    test('run() ascending', () {
      fakeAsync((async) {
        final controller = TimerController(duration: const Duration(days: 1), ascending: true)..run();
        async.elapse(const Duration(days: 10));

        expect(controller.state.value, TimerState.done);
        expect(controller.value, Duration.microsecondsPerDay);

        controller.run();
        async.elapse(const Duration(seconds: 10));

        expect(controller.state.value, TimerState.done);
        expect(controller.value, Duration.microsecondsPerDay);
      });
    });

    test('run() descending', () {
      fakeAsync((async) {
        final controller = TimerController(duration: const Duration(days: 1))..run();
        async.elapse(const Duration(days: 10));

        expect(controller.state.value, TimerState.done);
        expect(controller.value, 0);

        controller.run();
        async.elapse(const Duration(seconds: 10));

        expect(controller.state.value, TimerState.done);
        expect(controller.value, 0);
      });
    });

    test('pause()', () {
      fakeAsync((async) {
        final controller = TimerController(duration: const Duration(days: 1), ascending: true)..run();
        async.elapse(const Duration(days: 10));

        expect(controller.state.value, TimerState.done);
        expect(controller.value, Duration.microsecondsPerDay);

        controller.pause();
        async.elapse(const Duration(seconds: 10));

        expect(controller.state.value, TimerState.done);
        expect(controller.value, Duration.microsecondsPerDay);
      });
    });

    test('reset ascending', () {
      fakeAsync((async) {
        final controller = TimerController(duration: const Duration(days: 1), ascending: true)..run();
        async.elapse(const Duration(days: 10));

        expect(controller.state.value, TimerState.done);
        expect(controller.value, Duration.microsecondsPerDay);

        controller.reset();
        async.elapse(const Duration(seconds: 10));

        expect(controller.state.value, TimerState.idle);
        expect(controller.value, 0);
      });
    });

    test('reset descending', () {
      fakeAsync((async) {
        final controller = TimerController(duration: const Duration(days: 1))..run();
        async.elapse(const Duration(days: 10));

        expect(controller.state.value, TimerState.done);
        expect(controller.value, 0);

        controller.reset();
        async.elapse(const Duration(seconds: 10));

        expect(controller.state.value, TimerState.idle);
        expect(controller.value, Duration.microsecondsPerDay);
      });
    });
  });

  test('dispose()', () {
    fakeAsync((async) {
      final controller = TimerController(duration: const Duration(days: 1), ascending: true)..run();
      async.elapse(const Duration(seconds: 10));

      expect(controller.state.value, TimerState.running);
      expect(controller.value, 10 * Duration.microsecondsPerSecond);

      controller.dispose();

      async.elapse(const Duration(seconds: 10));

      expect(controller.state.value, TimerState.running);
      expect(controller.value, 10 * Duration.microsecondsPerSecond);
    });
  });

}
