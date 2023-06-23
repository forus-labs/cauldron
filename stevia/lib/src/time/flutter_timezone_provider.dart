import 'package:stevia/src/time/platform_timezone.dart';
import 'package:sugar/sugar.dart';

/// Returns a [Timezone.platformTimezoneProvider] that supports Android and iOS platforms in addition to those supported
/// by [defaultPlatformTimezoneProvider].
///
/// This provider should only be used if you need to support Android and iOS.
///
/// ```dart
/// import 'package:sugar/sugar.dart';
/// import `package:stevia/stevia.dart';
///
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   Timezone.platformTimezoneProvider = await flutterPlatformTimezoneProvider();
///   runApp(MyApp());
/// }
///
/// class MyApp extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) => MaterialApp(
///     theme: ThemeData(useMaterial3: true),
///     home: const Scaffold(
///       body: Text('${ZonedDateTime.now()}'),
///     ),
///   );
/// }
/// ```
Future<String Function()> flutterPlatformTimezoneProvider() async {
  switch (const Runtime().type) {
    case PlatformType.android || PlatformType.ios:
      final platform = await PlatformTimezone.of();
      return () => platform.current;

    default:
      return defaultPlatformTimezoneProvider;
  }
}
