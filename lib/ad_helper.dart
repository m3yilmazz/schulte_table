import 'dart:io';
import 'package:flutter/foundation.dart';

class AdHelper {
  static String get appOpenAdUnitId {
    if (kDebugMode) {
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/9257395921';
      } else if (Platform.isIOS) {
        return 'ca-app-pub-3940256099942544/5575463023';
      }
      throw UnsupportedError("Unsupported platform");
    } else {
      if (Platform.isAndroid) {
        // TODO: Replace with your real Android App Open Ad Unit ID from AdMob
        return 'ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY'; 
      } else if (Platform.isIOS) {
        // TODO: Replace with your real iOS App Open Ad Unit ID from AdMob
        return 'ca-app-pub-XXXXXXXXXXXXXXXX/ZZZZZZZZZZ';
      }
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId {
    if (kDebugMode) {
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/6300978111';
      } else if (Platform.isIOS) {
        return 'ca-app-pub-3940256099942544/2934735716';
      }
      throw UnsupportedError("Unsupported platform");
    } else {
      if (Platform.isAndroid) {
        // TODO: Replace with your real Android Banner Ad Unit ID from AdMob
        return 'ca-app-pub-XXXXXXXXXXXXXXXX/AAAAAAA'; 
      } else if (Platform.isIOS) {
        // TODO: Replace with your real iOS Banner Ad Unit ID from AdMob
        return 'ca-app-pub-XXXXXXXXXXXXXXXX/BBBBBBB';
      }
      throw UnsupportedError("Unsupported platform");
    }
  }
}
