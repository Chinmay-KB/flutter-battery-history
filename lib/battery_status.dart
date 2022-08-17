import 'dart:convert';

BatteryStatus batteryStatusFromJson(String str) =>
    BatteryStatus.fromJson(json.decode(str));

class BatteryStatus {
  BatteryStatus({
    required this.batteryLevel,
    required this.chargingStatus,
    required this.timestamp,
  });

  final int batteryLevel;
  final String chargingStatus;
  final DateTime timestamp;

  factory BatteryStatus.fromJson(Map<String, dynamic> json) => BatteryStatus(
      batteryLevel: json["battery_level"],
      chargingStatus: json["charging_status"],
      timestamp: DateTime.now());

  Map<String, dynamic> toJson() => {
        "battery_level": batteryLevel,
        "charging_status": chargingStatus,
        "timestamp": timestamp.toIso8601String()
      };
}
