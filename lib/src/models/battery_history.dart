import 'package:battery_history/src/models/battery_history_item.dart';
import 'package:battery_history/src/models/battery_status.dart';

/// Model class storing all the data to be sent from plugin
/// to the app
class BatteryHistory {
  BatteryHistory({required this.status, required this.history});

  /// Current battery status
  final BatteryStatus status;

  /// List of all charge cycles previously stored
  final List<BatteryHistoryItem> history;
}
