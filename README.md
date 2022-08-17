# battery_history

A simple plugin to monitor battery charging/discharging state when the app is in non-terminated state, i.e - foreground or background

## Note

- The plugin can only monitor charge cycles when it is either in foreground or background, not in terminated state
- If the device is already charging when the plugin is initialised, then
- it will consider the charge cycle to start from that instant only, and not
- before.
- The list of [BatteryHistory] provided is ordered by time, recent first
- The plugin is tested for Android, not tested properly on iOS due to device issues.
