/// ## Services
/// General-purpose widgets and Flutter services.
///
/// * [ColorFilters]
///
/// * [CaseTextInputFormatter]
/// * [IntTextInputFormatter]
///
/// ## Timer
/// Controllers that simply the implementation of timers.
///
/// * [TimerController]
library;

import 'package:stevia/services.dart';

export 'package:stevia/services_haptic.dart';
export 'package:stevia/services_time.dart';

export 'src/services/color_filters.dart' hide Matrix5;
export 'src/services/text_input_formatters.dart';

export 'src/services/timer_controller.dart';
