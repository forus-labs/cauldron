import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stevia/src/widgets/async/memomized_future_builder.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('FutureBuilder recomputes multiple times, MemoizedFutureBuilder does not recompute', (tester) async {
    await tester.pumpWidget(UnderTest());
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    final state = tester.state<_UnderTestState>(find.byType(UnderTest));
    expect(state.memoizedSideEffect, 1);
    expect(state.futureSideEffect, 2);
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
        MemoizedFutureBuilder(
          future: memoizedBuilder,
          builder: (_, __) => Container(),
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
