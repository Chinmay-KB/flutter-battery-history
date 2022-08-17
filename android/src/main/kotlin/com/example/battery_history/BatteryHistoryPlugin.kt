package com.example.battery_history

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.widget.Toast
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.StreamHandler


class BatteryHistoryPlugin: FlutterPlugin, StreamHandler {

  private lateinit var channel : EventChannel
  private lateinit var batteryStateReceiver: BroadcastReceiver
  private lateinit var applicationContext: Context


  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    applicationContext = flutterPluginBinding.applicationContext;
    channel = EventChannel(flutterPluginBinding.binaryMessenger, "battery_history")
    channel.setStreamHandler(this)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setStreamHandler(null)
  }

  override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
    batteryStateReceiver = BatteryHistoryBroadcast(events)
    applicationContext.registerReceiver(batteryStateReceiver, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
  }

  override fun onCancel(arguments: Any?) {
    applicationContext.unregisterReceiver(batteryStateReceiver)
  }
}

