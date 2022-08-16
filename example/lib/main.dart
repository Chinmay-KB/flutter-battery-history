import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:battery_history/battery_history.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  late BatteryHistory history;

  @override
  void initState() {
    super.initState();
    history = BatteryHistory();

    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    // });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    history.startTick();
  }

  String his = "3 2 1";

  Future<void> fetchData() async {
    final c = await history.getData();
    setState(() {
      his = c;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   onPressed: fetchData,
        //   child: Icon(Icons.data_array),
        // ),
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: StreamBuilder(
            stream: history.batteryInfoStream(),
            builder: (context, data) {
              return Text(data.data.toString());
            },
          ),
        ),
      ),
    );
  }
}
