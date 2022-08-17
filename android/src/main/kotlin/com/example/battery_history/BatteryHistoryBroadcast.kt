package com.example.battery_history

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.BatteryManager
import android.os.Build
import androidx.annotation.RequiresApi
import io.flutter.plugin.common.EventChannel
import java.text.DateFormat
import java.text.SimpleDateFormat
import java.util.*

class BatteryHistoryBroadcast(val event:EventChannel.EventSink?): BroadcastReceiver() {
    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    override fun onReceive(context: Context?, intent: Intent?) {
        var batteryManager = context?.getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        val tz: TimeZone = TimeZone.getTimeZone("UTC")
        val df: DateFormat =
            SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss") // Quoted "Z" to indicate UTC, no timezone offset

        df.setTimeZone(tz)
        event?.success(intent.let {
            var batteryLevel = batteryManager?.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
            when(it?.getIntExtra(BatteryManager.EXTRA_STATUS, -1)){
                BatteryManager.BATTERY_STATUS_CHARGING -> mapOf(
                    "battery_level" to batteryLevel,
                    "charging_status" to "charging",
                    "timestamp" to df.format(Date())
                )
                else -> {
                   mapOf(
                       "battery_level" to batteryLevel,
                       "charging_status" to "discharging",
                       "timestamp" to df.format(Date())

                   )
                }
            }
        })
    }
}