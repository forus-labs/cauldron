/// {@category Widgets}
///
/// General purpose widgets for every Flutter program.
///
/// ## Async
/// Widgets that build themselves based on interaction with an asynchronous computation.
///
/// * [showFutureResultDialog]
/// * [showFutureValueDialog]
///
/// * [FutureResultBuilder]
/// * [FutureValueBuilder]
/// * [StreamValueBuilder]
///
/// ## Resizable
/// Widgets that contain children which can be resized either horizontally or vertically.
///
/// * [ResizableBox]
library;

import 'package:stevia/widgets.dart';

export 'src/widgets/async/future/future_builder.dart' show
  FutureResultBuilder,
  FutureValueBuilder,
  showFutureResultDialog,
  showFutureValueDialog;
export 'src/widgets/async/stream_value_builder.dart';

export 'src/widgets/resizable/resizable_box.dart';
export 'src/widgets/resizable/resizable_icon.dart';
export 'src/widgets/resizable/resizable_region.dart';
