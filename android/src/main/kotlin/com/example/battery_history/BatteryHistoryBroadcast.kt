package com.example.battery_history

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.widget.Toast
import io.flutter.plugin.common.EventChannel

class BatteryHistoryBroadcast(val event:EventChannel.EventSink?): BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        event?.success(intent.let {
            (0..100).random().toString() + "Battery State"
        })
    }
}