#import "BatteryHistoryPlugin.h"
#if __has_include(<battery_history/battery_history-Swift.h>)
#import <battery_history/battery_history-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "battery_history-Swift.h"
#endif

@implementation BatteryHistoryPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftBatteryHistoryPlugin registerWithRegistrar:registrar];
}
@end
