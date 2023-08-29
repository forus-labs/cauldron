import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stevia/stevia.dart';

class HomeWidget extends StatelessWidget {
  final Future<void>? future;

  const HomeWidget([this.future]);

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: ThemeData(useMaterial3: true),
    home: const Scaffold(
      body: SomeWidget(),
    ),
  );
}

class SomeWidget extends StatelessWidget {
  final Future<void>? future;

  const SomeWidget([this.future]);

  @override
  Widget build(BuildContext context) => Center(
    child: FloatingActionButton(
      onPressed: () => showFutureBarrier(
        context: context,
        future: future ?? Future.delayed(const Duration(seconds: 5)),
        builder: (context) => const Text('b'),
      ),
      child: const Text('a'),
    ),
  );
}

void main() {
  group('showFutureBarrier', () {
    testWidgets('show barrier', (tester) async {
      await tester.pumpWidget(const HomeWidget());
      await tester.tap(find.text('a'));

      await tester.pumpAndSettle();

      expect(find.text('b'), findsOneWidget);

      await tester.pumpAndSettle(const Duration(seconds: 5));
    });

    testWidgets('barrier automatically hides on successful completion', (tester) async {
      await tester.pumpWidget(const HomeWidget());
      await tester.tap(find.text('a'));

      await tester.pumpAndSettle();

      expect(find.text('b'), findsOneWidget);

      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.text('b'), findsNothing);
    });
  });
}
