import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:meta/meta.dart';

import 'package:sugar/src/time/zone/platform/windows_timezones.g.dart';

// ignore_for_file: avoid_private_typedef_functions, camel_case_types, non_constant_identifier_names

typedef _NativeGetDynamicTimeZoneInformation = Uint64 Function(Pointer<_DYNAMIC_TIME_ZONE_INFORMATION> pointer);
typedef _DartGetDynamicTimeZoneInformation = int Function(Pointer<_DYNAMIC_TIME_ZONE_INFORMATION> pointer);

final _kernel32 = DynamicLibrary.open('kernel32.dll');
final _GetDynamicTimeZoneInformation = _kernel32.lookup<NativeFunction<_NativeGetDynamicTimeZoneInformation>>('GetDynamicTimeZoneInformation');


/// The current timezone name on Windows, or `Factory` if the timezone name could not be mapped.
///
/// ### Contract:
/// This field should only be accessed on Windows. Accessing this field on other platforms will result in undefined behaviour.
@internal String get windowsTimezone {
  Pointer<_DYNAMIC_TIME_ZONE_INFORMATION>? pointer;
  try {
    pointer = malloc<_DYNAMIC_TIME_ZONE_INFORMATION>();

    // Calls GetDynamicTimeZoneInformation to retrieve current timezone standard name.
    // https://learn.microsoft.com/en-us/windows/win32/api/timezoneapi/nf-timezoneapi-getdynamictimezoneinformation
    //
    // GetDynamicTimeZoneInformation is used instead of GetTimeZoneInformation as the latter sometimes returns an incorrect
    // timezone name. For example, it returns 'Malay Peninsula Standard Time' instead of 'Singapore Standard Time' in Singapore.
    // It is because of this issue that we can't use Dart's DateTime.timezoneName.
    _GetDynamicTimeZoneInformation.asFunction<_DartGetDynamicTimeZoneInformation>()(pointer);

    final utf16Array = pointer.ref.timeZoneKeyName;
    final standard = String.fromCharCodes([ // This works because Dart's String are internally represented as UTF-16.
      for (int i = 0; i < 127; i++)
        if (utf16Array[i] != 0)
          utf16Array[i]
    ]);

    return windowsTimezones[standard] ?? 'Factory';

  } finally {
    if (pointer != null) {
      malloc.free(pointer);
    }
  }
}


/// Represents a binding for the `DYNAMIC_TIME_ZONE_INFORMATION` structure in the Win32 API.
///
/// See [DYNAMIC_TIME_ZONE_INFORMATION](https://learn.microsoft.com/en-us/windows/win32/api/timezoneapi/ns-timezoneapi-dynamic_time_zone_information.)
///
/// Derived from https://github.com/timsneath/win32/blob/ffb2f5526b38266e2791fec34a22a51348a5d367/lib/src/structs.g.dart#L8483
class _DYNAMIC_TIME_ZONE_INFORMATION extends Struct {
  @Int32()
  external int bias;

  @Array(32)
  external Array<Uint16> standardName;

  external _SYSTEMTIME standardDate;

  @Int32()
  external int standardBias;

  @Array(32)
  external Array<Uint16> daylightName;

  external _SYSTEMTIME daylightDate;

  @Int32()
  external int daylightBias;

  /// The timezone key name. This is the only field we are interested in. It's a UTF-16 string.
  @Array(128)
  external Array<Uint16> timeZoneKeyName;

  @Bool()
  external bool dynamicDaylightTimeDisabled;
}

/// Represents a binding for the `SYSTEMTIME` structure in the Win32 API.
///
/// See [SYSTEMTIME](https://learn.microsoft.com/en-us/windows/win32/api/minwinbase/ns-minwinbase-systemtime) for more information.
///
/// Derived from https://github.com/timsneath/win32/blob/ffb2f5526b38266e2791fec34a22a51348a5d367/lib/src/structs.g.dart#L8483
class _SYSTEMTIME extends Struct {
  @Uint16()
  external int wYear;

  @Uint16()
  external int wMonth;

  @Uint16()
  external int wDayOfWeek;

  @Uint16()
  external int wDay;

  @Uint16()
  external int wHour;

  @Uint16()
  external int wMinute;

  @Uint16()
  external int wSecond;

  @Uint16()
  external int wMilliseconds;
}
