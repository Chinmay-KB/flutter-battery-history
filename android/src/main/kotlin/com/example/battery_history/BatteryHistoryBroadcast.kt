package com.example.battery_history

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.BatteryManager
import android.os.Build
import android.widget.Toast
import androidx.annotation.RequiresApi
import io.flutter.plugin.common.EventChannel

class BatteryHistoryBroadcast(val event:EventChannel.EventSink?): BroadcastReceiver() {
    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    override fun onReceive(context: Context?, intent: Intent?) {
        var batteryManager = context?.getSystemService(Context.BATTERY_SERVICE) as BatteryManager

        event?.success(intent.let {
            var batteryLevel = batteryManager?.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
            when(it?.getIntExtra(BatteryManager.EXTRA_PLUGGED, -1)){
                BatteryManager.BATTERY_STATUS_CHARGING -> mapOf(
                    "battery_level" to batteryLevel,
                    "charging_status" to "charging"
                )
                else -> {
                   mapOf(
                       "battery_level" to batteryLevel,
                       "charging_status" to "discharging"
                   )
                }
            }
        })
    }
}