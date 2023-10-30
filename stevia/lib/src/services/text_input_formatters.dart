import 'package:flutter/material.dart' hide Interval;
import 'package:flutter/services.dart';
import 'package:sugar/sugar.dart';
import 'dart:math' as math;

/// A [IntTextInputFormatter] validates whether the text being edited is an integer in a given [Range].
///
/// There is **no** guarantee that the text being edited is an integer since it may be empty or `-`.
///
/// A [IntTextInputFormatter] trims all commas separating parts of the integer, and leading and trailing whitespaces.
/// For example, both ` ` and `,` are allowed while ` 1,000 ` is trimmed to `1000`.
///
/// It is recommended to use set the enclosing [TextField]'s `keyboardType` to [TextInputType.number].
///
/// ```dart
/// TextField(
///   keyboardType: TextInputType.number,
///   inputFormatters: [ IntTextInputFormatter(Interval.closedOpen(-1, 5)) ], // -1 <= value < 5
/// );
/// ```
class IntTextInputFormatter extends TextInputFormatter {
  final Range<int> _range;
  final bool _hyphen;

  /// Creates a [IntTextInputFormatter] in the given [Range].
  IntTextInputFormatter(this._range): _hyphen = switch (_range) {
    Interval(min: (:final value, :final open)) || Min(:final value, :final open) => value < -1 || (value == -1 && !open),
    _ => true,
  }, super();

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final TextEditingValue(:text, :selection, :composing) = newValue;
    if (text.isEmpty || (_hyphen && text == '-')) {
      return newValue;
    }

    final trimmed = text.trim().replaceAll(',', '');
    return switch (int.tryParse(trimmed)) {
      final value? when _range.contains(value) => switch (text.length == trimmed.length) {
        true => newValue,
        false => TextEditingValue(
          text: trimmed,
          selection: selection.copyWith(
            baseOffset: math.min(selection.start, trimmed.length),
            extentOffset: math.min(selection.end, trimmed.length),
          ),
          composing: !composing.isCollapsed && trimmed.length > composing.start ? TextRange(
            start: composing.start,
            end: math.min(composing.end, trimmed.length),
          ): TextRange.empty,
        )
      },
      _ => oldValue,
    };
  }
}

/// A [CaseTextInputFormatter] converts all characters to either upper or lower case.
///
/// ```dart
/// TextField(
///   inputFormatters: [ const CaseTextInputFormatter.upper() ],
/// );
/// ```
class CaseTextInputFormatter extends TextInputFormatter {

  static String _upper(String string) => string.toUpperCase();

  static String _lower(String string) => string.toLowerCase();


  final String Function(String) _format;

  /// Creates a [CaseTextInputFormatter] that converts all characters to uppercase.
  const CaseTextInputFormatter.upper(): this._(_upper);

  /// Creates a [CaseTextInputFormatter] that converts all characters to lowercase.
  const CaseTextInputFormatter.lower(): this._(_lower);

  const CaseTextInputFormatter._(this._format);

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (_format(newValue.text) case final text when text != newValue.text) {
      return newValue.copyWith(text: text);
    }

    return newValue;
  }

}
