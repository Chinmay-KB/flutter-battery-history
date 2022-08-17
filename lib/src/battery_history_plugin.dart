import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/models.dart';

/// A simple plugin which monitors battery charging state and stores necessary
/// data in local storage.
/// - The plugin can only monitor charge cycles when it is either in foreground
/// or background, not in terminated state
/// - If the device is already charging when the plugin is initialised, then
/// it will consider the charge cycle to start from that instant only, and not
/// before.
/// - The list of [BatteryHistory] provided is ordered by time, recent first

class BatteryHistoryPlugin {
  static const EventChannel _stream = EventChannel("battery_history");

  BatteryStatus? _currentStatus;

  /// Emits a stream of [BatteryHistory], which contains current charging status,
  /// and history of charge cycles recorded by the app
  Stream<BatteryHistory> batteryInfoStream() async* {
    var history = await getHistory();
    yield* _stream.receiveBroadcastStream().map((event) {
      final status = batteryStatusFromJson(json.encode(event));

      // The device was earlier charging, now it is discharging. i.e - A
      // charge cycle is completed

      if (_currentStatus?.chargingStatus == "charging" &&
          status.chargingStatus == "discharging") {
        _setBatteryLog(_currentStatus!, status).then((value) {
          history = [value, ...history];
        });
        // Making current status null indicates we are not monitoring
        // a charge cycle anymore
        _currentStatus = null;
      }
      // Store the status of when a charge cycle begins
      else if (_currentStatus == null && status.chargingStatus == "charging") {
        _currentStatus = status;
      }

      return BatteryHistory(status: status, history: history);
    });
  }

  /// Add details of a charge cycle to local storage
  Future<BatteryHistoryItem> _setBatteryLog(
      BatteryStatus start, BatteryStatus end) async {
    final _pref = await SharedPreferences.getInstance();
    final _historyItems = _pref.getStringList('history') ?? [];
    final _newItem = BatteryHistoryItem(chargingStart: start, chargingEnd: end);
    _pref.setStringList(
        'history', [..._historyItems, json.encode(_newItem.toJson())]);
    return _newItem;
  }

  /// Get history of all charging cycles
  Future<List<BatteryHistoryItem>> getHistory() async {
    final _pref = await SharedPreferences.getInstance();
    // List is being reversed to get latest charge cycle first
    return _pref
            .getStringList('history')
            ?.map((e) => BatteryHistoryItem.fromJson(json.decode(e)))
            .toList()
            .reversed
            .toList() ??
        [];
  }
}
