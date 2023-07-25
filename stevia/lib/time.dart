/// {@category Core}
///
/// Utilities for retrieving the current timezone on Android on iOS.
///
/// To retrieve the current timezone, first install the `sugar` package:
/// ```shell
/// flutter pub add sugar
/// ```
///
/// Alternatively, add the `sugar` directly to the project's `pubspec.yaml`:
/// ```yaml
/// sugar: ^3.1.0
/// ```
///
/// Subsequently, set [Timezone.platformTimezoneProvider] to [flutterPlatformTimezoneProvider] in your application's
/// main function.
///
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   Timezone.platformTimezoneProvider = await flutterPlatformTimezoneProvider();
///   runApp(MyApp());
/// }
/// ```
///
/// After setting [Timezone.platformTimezoneProvider], [ZonedDateTime.now] and other current timezone dependent functions
/// will return the current platform's timezone on Android and iOS.
library stevia.time;

import 'package:sugar/sugar.dart';
import 'package:stevia/src/time/flutter_timezone_provider.dart';

export 'src/time/flutter_timezone_provider.dart';
