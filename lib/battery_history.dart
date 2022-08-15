
import 'dart:async';

import 'package:flutter/services.dart';

class BatteryHistory {
  static const MethodChannel _channel = MethodChannel('battery_history');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
