import 'package:battery_history/battery_status.dart';

class BatteryHistoryItem {
  BatteryHistoryItem({required this.chargingStart, required this.chargingEnd});
  final BatteryStatus chargingStart;
  final BatteryStatus chargingEnd;

  factory BatteryHistoryItem.fromJson(Map<String, dynamic> json) =>
      BatteryHistoryItem(
        chargingStart: BatteryStatus.fromJson(json["charging_start"]),
        chargingEnd: BatteryStatus.fromJson(json["charging_end"]),
      );

  Map<String, dynamic> toJson() => {
        "charging_start": chargingStart.toJson(),
        "charging_end": chargingEnd.toJson(),
      };
}
