package com.example.battery_history

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.StreamHandler


class BatteryHistoryPlugin: FlutterPlugin, StreamHandler {

  private lateinit var channel : EventChannel
  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = EventChannel(flutterPluginBinding.binaryMessenger, "battery_history")
    channel.setStreamHandler(this)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setStreamHandler(null)
  }

  override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
    TODO("Not yet implemented")
  }

  override fun onCancel(arguments: Any?) {
    TODO("Not yet implemented")
  }
}
