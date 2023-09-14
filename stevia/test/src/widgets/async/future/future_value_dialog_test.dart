import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:stevia/stevia.dart';

import 'future_value_dialog_test.mocks.dart';

class HomeWidget extends StatelessWidget {
  final Future<String> Function()? future;
  final ValueWidgetBuilder<String>? builder;
  final ValueWidgetBuilder<(Object error, StackTrace stackTrace)>? errorBuilder;
  final NavigatorObserver? observer;

  const HomeWidget({this.future, this.builder, this.errorBuilder, this.observer});

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: ThemeData(useMaterial3: true),
    home: Scaffold(
      body: SomeWidget(future: future, builder: builder, errorBuilder: errorBuilder),
    ),
    navigatorObservers: observer == null ? [] : [observer!],
  );
}

class SomeWidget extends StatelessWidget {
  final Future<String> Function()? future;
  final ValueWidgetBuilder<String>? builder;
  final ValueWidgetBuilder<(Object error, StackTrace stackTrace)>? errorBuilder;

  const SomeWidget({this.future, this.builder, this.errorBuilder});

  @override
  Widget build(BuildContext context) => Center(
    child: FloatingActionButton(
      onPressed: () => showFutureValueDialog(
        context: context,
        future: future ?? () async {
          await Future.delayed(const Duration(seconds: 5));
          return '';
        },
        builder: builder,
        errorBuilder: errorBuilder,
        emptyBuilder: (context, _, __) => const Text('L'),
      ),
      child: const Text('Button'),
    ),
  );
}

@GenerateNiceMocks([MockSpec<NavigatorObserver>()])
void main() {
  group('showFutureValueDialog', () {
    late MockNavigatorObserver observer;

    setUp(() => observer = MockNavigatorObserver());

    testWidgets('automatically dismisses when successful', (tester) async {
      await tester.pumpWidget(HomeWidget(observer: observer));
      await tester.tap(find.text('Button'));

      await tester.pumpAndSettle();

      expect(find.text('L'), findsOneWidget);

      await tester.pumpAndSettle(const Duration(seconds: 5));

      verify(observer.didPop(any, any)).called(1);
      expect(find.text('L'), findsNothing);
    });

    testWidgets('show value builder', (tester) async {
      await tester.pumpWidget(HomeWidget(
        builder: (context, _, __) => const Text('V'),
        observer: observer,
      ));
      await tester.tap(find.text('Button'));

      await tester.pumpAndSettle();

      expect(find.text('L'), findsOneWidget);

      await tester.pumpAndSettle(const Duration(seconds: 5));

      verifyNever(observer.didPop(any, any));
      expect(find.text('V'), findsOneWidget);
      expect(find.text('L'), findsNothing);
    });

    testWidgets('show error builder', (tester) async {
      await tester.pumpWidget(HomeWidget(
        future: () async {
          await Future.delayed(const Duration(seconds: 5));
          throw StateError('help');
        },
        errorBuilder: (context, _, __) => const Text('E'),
        observer: observer,
      ));
      await tester.tap(find.text('Button'));

      await tester.pumpAndSettle();

      expect(find.text('L'), findsOneWidget);

      await tester.pumpAndSettle(const Duration(seconds: 5));

      verifyNever(observer.didPop(any, any));
      expect(find.text('E'), findsOneWidget);
      expect(find.text('L'), findsNothing);
    });
  });
}
