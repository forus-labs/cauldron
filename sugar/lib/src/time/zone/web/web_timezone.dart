/// Inter-op bindings for [`Intl.DateFormat().resolvedOptions().timeZone`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/DateTimeFormat/resolvedOptions#description).
@JS('Intl')
@internal library intl;

import 'package:js/js.dart';
import 'package:meta/meta.dart';

// ignore_for_file: public_member_api_docs

@JS()
@staticInterop
class DateTimeFormat {
  external factory DateTimeFormat();
}

extension DateTimeFormatExtension on DateTimeFormat {
  external Options resolvedOptions();
}


@JS()
@staticInterop
class Options {
  external factory Options();
}

extension OptionsExtension on Options {
  external String? get timeZone;
}