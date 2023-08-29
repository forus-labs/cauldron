import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget valueText(BuildContext context, String value, Widget? child) => Text(
  value,
  textDirection: TextDirection.ltr,
);

Widget errorText(BuildContext context, (Object error, StackTrace trace) error, Widget? child) => Text(
  error.toString(),
  textDirection: TextDirection.ltr,
);

Widget emptyFutureText(BuildContext context, Future<String>? future, Widget? child) => const Text(
  'empty text',
  textDirection: TextDirection.ltr,
);

Widget emptyStreamText(BuildContext context, Widget? child) => const Text(
  'empty text',
  textDirection: TextDirection.ltr,
);

Future<void> eventFiring(WidgetTester tester) => tester.pump(Duration.zero);
