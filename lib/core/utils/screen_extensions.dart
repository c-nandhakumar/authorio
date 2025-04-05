import 'package:flutter/widgets.dart';

const double mediumScreenBreakPoint = 720;

extension ScreenExtensions on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  double get screenWidth => mediaQuery.size.width;
  double get screenHeight => mediaQuery.size.height;

  bool get isMediumDevice => screenHeight < mediumScreenBreakPoint;

  double get blockSizeHorizontal => screenWidth / 100;
  double get blockSizeVertical => screenHeight / 100;

  double get safeAreaHorizontal =>
      mediaQuery.padding.left + mediaQuery.padding.right;
  double get safeAreaVertical =>
      mediaQuery.padding.top + mediaQuery.padding.bottom;

  double get safeBlockHorizontal => (screenWidth - safeAreaHorizontal) / 100;
  double get safeBlockVertical => (screenHeight - safeAreaVertical) / 100;


  double w(double percent) => screenWidth * (percent / 100);

  double h(double percent) => screenHeight * (percent / 100);
}