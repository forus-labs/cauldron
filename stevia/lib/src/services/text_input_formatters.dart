import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sugar/sugar.dart';
import 'dart:math' as math;

/// A [IntTextInputFormatter] validates whether the text being edited is an integer in a given [Range].
///
/// There is **no** guarantee that the text being edited is an integer since it may be empty or `-`.
///
/// Empty text and a single `-` are ignored. Furthermore, a [IntTextInputFormatter] trims all commas separating parts of
/// the integer, and leading and trailing whitespaces. For example, both ` ` and `-` are allowed while ` 1,000 ` is trimmed
/// to `1000`.
///
///
/// It is recommended to use set the enclosing [TextField]'s `keyboardType` to [TextInputType.number].
///
/// ```dart
/// TextField(
///   keyboardType: TextInputType.number,
///   inputFormatters: [ IntTextInputFormatter(Interval.closedOpen(0, 5)) ], // 0 <= value < 5
/// );
/// ```
class IntTextInputFormatter extends TextInputFormatter {
  final Range<int> _range;

  /// Creates a [IntTextInputFormatter] in the given [Range].
  IntTextInputFormatter(this._range): super();

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty || newValue.text == '-') {
      return newValue;
    }

    final trimmed = newValue.text.trim().replaceAll(',', '');
    return switch (int.tryParse(trimmed)) {
      final value? when _range.contains(value) => switch (newValue.text.length == trimmed.length) {
        true => newValue,
        false => TextEditingValue(
          text: trimmed,
          selection: newValue.selection.copyWith(
            baseOffset: math.min(newValue.selection.start, trimmed.length),
            extentOffset: math.min(newValue.selection.end, trimmed.length),
          ),
          composing: !newValue.composing.isCollapsed && trimmed.length > newValue.composing.start ? TextRange(
            start: newValue.composing.start,
            end: math.min(newValue.composing.end, trimmed.length),
          ): TextRange.empty,
        )
      },
      _ => oldValue,
    };
  }
}
