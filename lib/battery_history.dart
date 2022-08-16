import 'dart:async';
import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_isolate/flutter_isolate.dart';

class BatteryHistory {
  static const MethodChannel _channel = MethodChannel('battery_history');

  FlutterIsolate? isolate;
  Future<void> startTick() async {
    // final String? version = await _channel.invokeMethod('getPlatformVersion');
    // return version;
    final _pref = await SharedPreferences.getInstance();
    _pref.setStringList('time', []);
    Timer.periodic(Duration(seconds: 2), (Timer t) async {
      _pref.setStringList(
          'time', [..._pref.getStringList('time') ?? [], t.tick.toString()]);
      // _pref.setStringList(
      //     'time', [..._pref.getStringList('time') ?? [], t.tick.toString()]);
    });
  }

  Future<void> stopTick() async {
    isolate?.kill();
  }

  Future<String> getData() async {
    final _pref = await SharedPreferences.getInstance();

    return _pref.getStringList('time')?.toString() ?? 'no data';
  }
}
