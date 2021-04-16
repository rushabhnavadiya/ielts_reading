import 'package:flutter/material.dart';

double cW(double width) => UIUtills().getWidth(width);
double cH(double height) => UIUtills().getHeight(height);

class UIUtills {
  factory UIUtills() {
    return _singleton;
  }
  static final UIUtills _singleton = UIUtills._internal();
  UIUtills._internal() {
    print("Instance created UIUtills");
  }
//region Screen Size and Proportional according to device
  double _screenHeight;
  double _screenWidth;
  double get screenHeight => _screenHeight;
  double get screenWidth => _screenWidth;
  final double _refrenceScreenHeight = 640;
  final double _refrenceScreenWidth = 360;
  void updateScreenDimension({double width, double height}) {
    _screenWidth = (width != null) ? width : _screenWidth;
    _screenHeight = (height != null) ? height : _screenHeight;
  }
  double getHeight(double height) {
    if (_screenHeight == null) return height;
    return _screenHeight * height / _refrenceScreenHeight;
  }
  double getWidth(double width) {
    if (_screenWidth == null) return width;
    var w = _screenWidth * width / _refrenceScreenWidth;
    return w.ceilToDouble();
  }
//endregion
//region TextStyle
  double textSize(double size){
    if (_screenWidth == null) return size;
    return ((size.toDouble() * _screenWidth) / _refrenceScreenWidth);
  }

  TextStyle getTextStyleRegular(
      {String fontName = 'Roboto-Regular',
        int fontSize = 12,
        Color color,
        bool isChangeAccordingToDeviceSize = true,
        double characterSpacing,
        double lineSpacing}) {
    double finalFontSize = fontSize.toDouble();
    if (isChangeAccordingToDeviceSize && this._screenWidth != null) {
      finalFontSize = (finalFontSize * _screenWidth) / _refrenceScreenWidth;
    }
    if (characterSpacing != null) {
      return TextStyle(
          fontSize: finalFontSize,
          fontFamily: fontName,
          color: color,
          letterSpacing: characterSpacing);
    } else if (lineSpacing != null) {
      return TextStyle(
          fontSize: finalFontSize,
          fontFamily: fontName,
          color: color,
          height: lineSpacing);
    }
    return TextStyle(
        fontSize: finalFontSize, fontFamily: fontName, color: color);
  }
}