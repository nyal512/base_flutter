import 'package:flutter/widgets.dart';

class Scaling {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double _safeAreaHorizontal;
  static late double _safeAreaVertical;

  // Reference design size (e.g., from Figma)
  static const double refWidth = 1280;
  static const double refHeight = 800;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;

    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
  }

  /// Get the scaled width based on reference width
  static double scaleW(num width) {
    return (width / refWidth) * screenWidth;
  }

  /// Get the scaled height based on reference height
  static double scaleH(num height) {
    return (height / refHeight) * screenHeight;
  }

  /// Get scaled font size (using width as a baseline for scaling)
  static double scaleFont(num fontSize) {
    return (fontSize / refWidth) * screenWidth;
  }

  static double get safeBlockHorizontal => (screenWidth - _safeAreaHorizontal) / 100;
  static double get safeBlockVertical => (screenHeight - _safeAreaVertical) / 100;
}

extension ResponsiveSize on num {
  /// Scale width
  double get w => Scaling.scaleW(this);

  /// Scale height
  double get h => Scaling.scaleH(this);

  /// Scale font size
  double get sp => Scaling.scaleFont(this);
}
