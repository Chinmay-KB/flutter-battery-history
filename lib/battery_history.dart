import 'dart:async';
import 'dart:convert';

import 'package:battery_history/battery_history_item.dart';
import 'package:battery_history/battery_status.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BatteryHistory {
  BatteryHistory({required this.status, required this.history});
  final BatteryStatus status;
  final List<BatteryHistoryItem> history;
}

class BatteryHistoryPlugin {
  static const EventChannel stream = EventChannel("battery_history");
  // late StreamController<List<BatteryHistoryItem>> _streamController;

  BatteryStatus? currentStatus;

  Stream<BatteryHistory> batteryInfoStream() async* {
    var history = await getHistory();
    yield* stream.receiveBroadcastStream().map((event) {
      final status = batteryStatusFromJson(json.encode(event));
      // The plugin has just started listening to battery status

      // The device was earlier charging, now it is discharging
      if (currentStatus?.chargingStatus == "charging" &&
          status.chargingStatus == "discharging") {
        setBatteryLog(currentStatus!, status).then((value) {
          history = [value, ...history];
        });
        currentStatus = null;
      } else if (currentStatus == null && status.chargingStatus == "charging") {
        currentStatus = status;
      }

      return BatteryHistory(status: status, history: history);
    });
  }

  Future<BatteryHistoryItem> setBatteryLog(
      BatteryStatus start, BatteryStatus end) async {
    final _pref = await SharedPreferences.getInstance();
    final _historyItems = _pref.getStringList('history') ?? [];
    final _newItem = BatteryHistoryItem(chargingStart: start, chargingEnd: end);
    _pref.setStringList(
        'history', [..._historyItems, json.encode(_newItem.toJson())]);
    return _newItem;
  }

  Future<List<BatteryHistoryItem>> getHistory() async {
    final _pref = await SharedPreferences.getInstance();
    return _pref
            .getStringList('history')
            ?.map((e) => BatteryHistoryItem.fromJson(json.decode(e)))
            .toList()
            .reversed
            .toList() ??
        [];
  }

  Future<String> getData() async {
    final _pref = await SharedPreferences.getInstance();

    return _pref.getStringList('time')?.toString() ?? 'no data';
  }
}
