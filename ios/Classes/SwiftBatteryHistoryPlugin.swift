import Flutter
import UIKit


public class SwiftBatteryHistoryPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterEventChannel(name: "battery_history", binaryMessenger: registrar.messenger())
      channel.setStreamHandler(BatteryStream())
  }


}

class BatteryStream: NSObject, FlutterStreamHandler {
  var eventSink: FlutterEventSink?
  let batteryState = BatteryStateDetails()


  public func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
    self.eventSink = eventSink
    let batteryInfo = batteryState.status()
    eventSink(batteryInfo)
    return nil
  }
  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    eventSink = nil
    return nil
  }
}

struct BatteryStateDetails{
    let device: UIDevice

    init(){
      device = UIDevice.current
      device.isBatteryMonitoringEnabled = true
    }

    private func getBatteryState() -> String {
      switch device.batteryState {
        case .full:
          return BatteryStateEnum.charging
        case .charging:
          return BatteryStateEnum.charging
        case .unplugged:
          return BatteryStateEnum.discharging
        default:
          return "undefined"
        }
    }
    
    func status() -> Dictionary<String, Any>{
        let dateFormatter = DateFormatter()
        let enUSPosixLocale = Locale(identifier: "en_US_POSIX")
        dateFormatter.locale = enUSPosixLocale
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateFormatter.calendar = Calendar(identifier: .gregorian)

        let iso8601String = dateFormatter.string(from: Date())
      var batteryInfo: [String: Any] = [:]
        batteryInfo["battery_level"] = Int(device.batteryLevel*100)
      batteryInfo["charging_status"] = getBatteryState()
      batteryInfo["timestamp"] = iso8601String
      return batteryInfo
    }
}
enum BatteryStateEnum {
  static let charging = "charging"
  static let discharging = "discharging"
}
