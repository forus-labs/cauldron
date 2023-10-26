import 'dart:math';

import 'package:flutter/widgets.dart';

/// Provides functions for creating [ColorFilter]s.
///
/// ## Example
/// ```dart
/// ColorFiltered(
///   colorFilter: ColorFilters.matrix(brightness: -0.5, saturation: 0.5),
///   child: Image.network('https://upload.wikimedia.org/wikipedia/commons/c/c6/500_x_500_SMPTE_Color_Bars.png'),
/// ),
/// ```
///
/// ## Attribution
/// The functions are derived from https://stackoverflow.com/a/64763333/4189771,
/// which in turn, is derived from https://stackoverflow.com/a/15119089/4189771,
/// which in turn, is derived from https://blog.gskinner.com/archives/2007/12/colormatrix_cla.html.
extension ColorFilters on Never {

  /// Returns a [ColorFilter] with the adjusted [hue], [contrast], [brightness] and [saturation].
  ///
  /// ## Contract
  /// Passing a [hue], [contrast], [brightness] or [saturation] not in `-1.0 <= parameter <= 1.0` will result in undefined behaviour.
  static ColorFilter matrix({double hue = 0, double contrast = 0, double brightness = 0, double saturation = 0}) {
    final matrix = <double>[
      1, 0, 0, 0, 0,
      0, 1, 0, 0, 0,
      0, 0, 1, 0, 0,
      0, 0, 0, 1, 0,
      0, 0, 0, 0, 1,
    ]..hue(hue)..contrast(contrast)..brightness(brightness)..saturation(saturation);
    
    return ColorFilter.matrix(matrix.sublist(0, 20));
  }

}

/// Provides functions for manipulating 5 x 5 matrices that have been flatten into a list.
extension Matrix5 on List<double> {

  static const _size = 5;
  static const _delta = <double>[
    0,    0.01, 0.02, 0.04, 0.05, 0.06, 0.07, 0.08, 0.1,  0.11,
    0.12, 0.14, 0.15, 0.16, 0.17, 0.18, 0.20, 0.21, 0.22, 0.24,
    0.25, 0.27, 0.28, 0.30, 0.32, 0.34, 0.36, 0.38, 0.40, 0.42,
    0.44, 0.46, 0.48, 0.5,  0.53, 0.56, 0.59, 0.62, 0.65, 0.68,
    0.71, 0.74, 0.77, 0.80, 0.83, 0.86, 0.89, 0.92, 0.95, 0.98,
    1.0,  1.06, 1.12, 1.18, 1.24, 1.30, 1.36, 1.42, 1.48, 1.54,
    1.60, 1.66, 1.72, 1.78, 1.84, 1.90, 1.96, 2.0,  2.12, 2.25,
    2.37, 2.50, 2.62, 2.75, 2.87, 3.0,  3.2,  3.4,  3.6,  3.8,
    4.0,  4.3,  4.7,  4.9,  5.0,  5.5,  6.0,  6.5,  6.8,  7.0,
    7.3,  7.5,  7.8,  8.0,  8.4,  8.7,  9.0,  9.4,  9.6,  9.8,
    10.0,
  ];

  static final _row = List.filled(5, 0.0);

  /// Overwrites this matrix with the adjusted hue.
  ///
  /// ## Contract
  /// Passing a [value] not in `-1.0 <= value <= 1.0` will result in undefined behaviour.
  void hue(double value) {
    assert(-1.1 < value && value < 1.1, 'Value should be in "-1 <= value <= 1", but it is $value');
    if (value == 0) {
      return;
    }

    value *= pi;

    const lumR = 0.213;
    const lumG = 0.715;
    const lumB = 0.072;

    final cosVal = cos(value);
    final sinVal = sin(value);

    dotProduct([
      (lumR + (cosVal * (1 - lumR))) + (sinVal * (-lumR)), (lumG + (cosVal * (-lumG))) + (sinVal * (-lumG)), (lumB + (cosVal * (-lumB))) + (sinVal * (1 - lumB)), 0, 0,
      (lumR + (cosVal * (-lumR))) + (sinVal * 0.143), (lumG + (cosVal * (1 - lumG))) + (sinVal * 0.14), (lumB + (cosVal * (-lumB))) + (sinVal * (-0.283)), 0, 0,
      (lumR + (cosVal * (-lumR))) + (sinVal * (-(1 - lumR))), (lumG + (cosVal * (-lumG))) + (sinVal * lumG), (lumB + (cosVal * (1 - lumB))) + (sinVal * lumB), 0, 0,
      0, 0, 0, 1, 0,
      0, 0, 0, 0, 1,
    ]);
  }

  /// Overwrites this matrix with the adjusted contrast.
  ///
  /// ## Contract
  /// Passing a [value] not in `-1.0 <= value <= 1.0` will result in undefined behaviour.
  void contrast(double value) {
    assert(-1.1 < value && value < 1.1, 'Value should be in "-1 <= value <= 1", but it is $value');
    if (value == 0) {
      return;
    }

    final index = (value * 100).round();

    double x;
    if (index < 0) {
      x = 127 + index / 100 * 127;

    } else {
      x = index % 1;
      if (x == 0) {
        x = _delta[index];
      } else {
        x = _delta[(index << 0)]*(1-x) + _delta[(index << 0) + 1] * x;
      }

      x = x * 127 + 127;
    }

    dotProduct([
      x / 127, 0,       0,       0, 0.5 * (127 - x),
      0,       x / 127, 0,       0, 0.5 * (127 - x),
      0,       0,       x / 127, 0, 0.5 * (127 - x),
      0,       0,       0,       1, 0,
      0,       0,       0,       0, 1,
    ]);
  }

  /// Overwrites this matrix with the adjusted brightness.
  ///
  /// ## Contract
  /// Passing a [value] not in `-1.0 <= value <= 1.0` will result in undefined behaviour.
  void brightness(double value) {
    assert(-1.1 < value && value < 1.1, 'Value should be in "-1 <= value <= 1", but it is $value');
    if (value == 0) {
      return;
    }

    value *= (value <= 0 ? 255 : 100);

    dotProduct([
      1, 0, 0, 0, value,
      0, 1, 0, 0, value,
      0, 0, 1, 0, value,
      0, 0, 0, 1, 0,
      0, 0, 0, 0, 1,
    ]);
  }

  /// Overwrites this matrix with the adjusted saturation.
  ///
  /// ## Contract
  /// Passing a [value] not in `-1.0 <= value <= 1.0` will result in undefined behaviour.
  void saturation(double value) {
    assert(-1.1 < value && value < 1.1, 'Value should be in "-1 <= value <= 1", but it is $value');
    if (value == 0) {
      return;
    }

    const lumR = 0.3086;
    const lumG = 0.6094;
    const lumB = 0.082;

    value *= 100;
    final x = 1 + ((value > 0) ? ((3 * value) / 100) : (value / 100));

    dotProduct([
      (lumR * (1 - x)) + x, lumG * (1 - x),       lumB * (1 - x),       0, 0,
      lumR * (1 - x),       (lumG * (1 - x)) + x, lumB * (1 - x),       0, 0,
      lumR * (1 - x),       lumG * (1 - x),       (lumB * (1 - x)) + x, 0, 0,
      0,                    0,                    0,                    1, 0,
      0,                    0,                    0,                    0, 1,
    ]);
  }



  /// Overwrites this matrix with the dot product of this matrix and [other].
  void dotProduct(List<double> other) {
    for (var i = 0; i < _size; i++) {
      for (var j = 0; j < _size; j++) {
        _row[j] = this[i * _size + j];
      }

      for (var j = 0; j < _size; j++) {
        var val = 0.0;
        for (var k = 0; k < _size; k++) {
          val += other[k * _size + j] * _row[k];
        }
        this[j + i * 5] = val;
      }
    }
  }

}
