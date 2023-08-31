import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stevia/stevia.dart';
import 'package:sugar/sugar.dart';

class HomeWidget extends StatelessWidget {
  final Future<Result<String, String>> Function()? future;
  final ValueWidgetBuilder<String>? builder;
  final ValueWidgetBuilder<String>? failureBuilder;

  const HomeWidget({this.future, this.builder, this.failureBuilder});

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: ThemeData(useMaterial3: true),
    home: Scaffold(
      body: SomeWidget(future: future, builder: builder, failureBuilder: failureBuilder),
    ),
  );
}

class SomeWidget extends StatelessWidget {
  final Future<Result<String, String>> Function()? future;
  final ValueWidgetBuilder<String>? builder;
  final ValueWidgetBuilder<String>? failureBuilder;

  const SomeWidget({this.future, this.builder, this.failureBuilder});

  @override
  Widget build(BuildContext context) => Center(
    child: FloatingActionButton(
      onPressed: () => showFutureResultDialog<String, String>(
        context: context,
        future: future ?? () async {
          await Future.delayed(const Duration(seconds: 5));
          return const Success('');
        },
        builder: builder,
        failureBuilder: failureBuilder,
        emptyBuilder: (context, _, __) => const Text('L'),
      ),
      child: const Text('Button'),
    ),
  );
}

void main() {
  group('showFutureResultDialog', () {
    testWidgets('automatically dismisses when successful', (tester) async {
      await tester.pumpWidget(const HomeWidget());
      await tester.tap(find.text('Button'));

      await tester.pumpAndSettle();

      expect(find.text('L'), findsOneWidget);

      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.text('L'), findsNothing);
    });

    testWidgets('automatically dismisses when fails', (tester) async {
      await tester.pumpWidget(HomeWidget(
        future: () async {
          await Future.delayed(const Duration(seconds: 5));
          return const Failure('');
        },
      ));
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

    testWidgets('show failure builder', (tester) async {
      await tester.pumpWidget(HomeWidget(
        future: () async {
          await Future.delayed(const Duration(seconds: 5));
          return const Failure('');
        },
        failureBuilder: (context, _, __) => const Text('F'),
      ));
      await tester.tap(find.text('Button'));

      await tester.pumpAndSettle();

      expect(find.text('L'), findsOneWidget);

      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.text('F'), findsOneWidget);
      expect(find.text('L'), findsNothing);
    });
  });
}
