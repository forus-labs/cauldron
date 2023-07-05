import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stevia/stevia.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('FutureBuilder recomputes multiple times, MemoizedFutureValueBuilder does not recompute', (tester) async {
    await tester.pumpWidget(UnderTest());
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    final state = tester.state<_UnderTestState>(find.byType(UnderTest));
    expect(state.memoizedSideEffect, 1);
    expect(state.futureSideEffect, 2);
  });

  testWidgets('shows child', (tester) async {
    final key = GlobalKey();
    await tester.pumpWidget(MemoizedFutureValueBuilder.value(
      key: key,
      future: () => null,
      initial: 'I',
      builder: (_, __, child) => child!,
      child: const Text('hello', textDirection: TextDirection.ltr),
    ));

    expect(find.text('hello'), findsOneWidget);
  });
}

class UnderTest extends StatefulWidget {
  @override
  State<UnderTest> createState() => _UnderTestState();
}

class _UnderTestState extends State<UnderTest> {
  int memoizedSideEffect = 0;
  int futureSideEffect = 0;

  @override
  Widget build(BuildContext context) => MaterialApp(
    home: Column(
      children: [
        FloatingActionButton(onPressed: () => setState(() {})),
        MemoizedFutureValueBuilder(
          future: memoizedBuilder,
          builder: (_, __, ___) => Container(),
        ),
        FutureBuilder(
          future: futureBuilder(),
          builder: (_, __) => Container(),
        ),
      ],
    ),
  );

  Future<void> futureBuilder() async {
    await Future.delayed(const Duration(milliseconds: 1));
    futureSideEffect++;
  }

  Future<void> memoizedBuilder() async {
    await Future.delayed(const Duration(milliseconds: 1));
    memoizedSideEffect++;
  }
}
