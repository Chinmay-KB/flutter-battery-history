import 'dart:convert';

BatteryStatus batteryStatusFromJson(String str) =>
    BatteryStatus.fromJson(json.decode(str));

/// Data class containing information of battery status at
/// an instant.
class BatteryStatus {
  BatteryStatus({
    required this.batteryLevel,
    required this.chargingStatus,
    required this.timestamp,
  });

  /// Battery level as a percentage
  final int batteryLevel;

  /// Whether battery is charging/discharging
  final String chargingStatus;

  /// Time when the status was captured
  final DateTime timestamp;

  factory BatteryStatus.fromJson(Map<String, dynamic> json) => BatteryStatus(
      batteryLevel: json["battery_level"],
      chargingStatus: json["charging_status"],
      timestamp: DateTime.parse(json['timestamp']));

  Map<String, dynamic> toJson() => {
        "battery_level": batteryLevel,
        "charging_status": chargingStatus,
        "timestamp": timestamp.toIso8601String()
      };
}
