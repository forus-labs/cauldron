import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stevia/stevia.dart';

Widget snapshotText(BuildContext context, Snapshot<String> snapshot, Widget? child) => Text(
  snapshot.toString(),
  textDirection: TextDirection.ltr,
);

Future<void> eventFiring(WidgetTester tester) => tester.pump(Duration.zero);
