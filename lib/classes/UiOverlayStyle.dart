import 'dart:ui';

import 'package:flutter/services.dart';
import 'Palette.dart';

class UiOverlayStyle {
  UiOverlayStyle(Color color, Brightness brightness){ // dark or bright
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: color,
        systemNavigationBarIconBrightness: brightness,
        statusBarColor: color,
        statusBarIconBrightness: brightness,
      ),
    );
  }
}