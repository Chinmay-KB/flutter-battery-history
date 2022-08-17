import 'package:battery_history/battery_history_item.dart';
import 'package:battery_history/battery_status.dart';
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
  late BatteryHistoryPlugin history;

  @override
  void initState() {
    super.initState();
    history = BatteryHistoryPlugin();

    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    // });
  }

  // Platform messages are asynchronous, so we initialize in an async method.

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
        body: StreamBuilder<BatteryHistory>(
          stream: history.batteryInfoStream(),
          builder: (context, data) {
            if (data.data != null) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(data.data!.status.chargingStatus),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.data?.history.length,
                      itemBuilder: (context, index) {
                        return Text('$index' ?? 'Unavailable');
                      },
                    ),
                  ),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
