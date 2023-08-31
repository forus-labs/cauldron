import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stevia/stevia.dart';

class HomeWidget extends StatelessWidget {
  final Future<String> Function()? future;
  final ValueWidgetBuilder<String>? builder;
  final ValueWidgetBuilder<(Object error, StackTrace stackTrace)>? errorBuilder;

  const HomeWidget({this.future, this.builder, this.errorBuilder});

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: ThemeData(useMaterial3: true),
    home: Scaffold(
      body: SomeWidget(future: future, builder: builder, errorBuilder: errorBuilder),
    ),
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
      onPressed: () => showFutureDialog<String>(
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

void main() {
  group('showFutureDialog', () {
    testWidgets('automatically dismisses when successful', (tester) async {
      await tester.pumpWidget(const HomeWidget());
      await tester.tap(find.text('Button'));

      await tester.pumpAndSettle();

      expect(find.text('L'), findsOneWidget);

      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.text('L'), findsNothing);
    });

    testWidgets('show value builder', (tester) async {
      await tester.pumpWidget(HomeWidget(
        builder: (context, _, __) => const Text('V'),
      ));
      await tester.tap(find.text('Button'));

      await tester.pumpAndSettle();

      expect(find.text('L'), findsOneWidget);

      await tester.pumpAndSettle(const Duration(seconds: 5));

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
      ));
      await tester.tap(find.text('Button'));

      await tester.pumpAndSettle();

      expect(find.text('L'), findsOneWidget);

      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.text('E'), findsOneWidget);
      expect(find.text('L'), findsNothing);
    });
  });
}
