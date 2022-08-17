import 'package:battery_history/battery_history_item.dart';
import 'package:battery_history/battery_status.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:battery_history/battery_history.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

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
      theme: ThemeData(textTheme: GoogleFonts.khulaTextTheme()),
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xff1B2430),
          // floatingActionButton: FloatingActionButton(
          //   onPressed: fetchData,
          //   child: Icon(Icons.data_array),
          // ),

          body: StreamBuilder<BatteryHistory>(
            stream: history.batteryInfoStream(),
            builder: (context, data) {
              if (data.data != null) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Text(data.data!.status.chargingStatus),
                    SfRadialGauge(
                      enableLoadingAnimation: true,
                      axes: [
                        RadialAxis(
                          annotations: [
                            GaugeAnnotation(
                                positionFactor: 0.1,
                                angle: 90,
                                widget: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      data.data!.status.batteryLevel
                                              .toStringAsFixed(0) +
                                          '%',
                                      style: const TextStyle(
                                        fontSize: 80,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFD6D5A8),
                                      ),
                                    ),
                                  ],
                                ))
                          ],
                          minimum: 0,
                          maximum: 100,
                          showLabels: false,
                          showTicks: false,
                          pointers: [
                            RangePointer(
                                value:
                                    data.data!.status.batteryLevel.toDouble(),
                                width: 0.1,
                                enableAnimation: true,
                                animationType: AnimationType.ease,
                                sizeUnit: GaugeSizeUnit.factor,
                                cornerStyle: CornerStyle.startCurve,
                                gradient: const SweepGradient(colors: <Color>[
                                  Color(0xFF816797),
                                  Color(0xFF51557E),
                                ], stops: <double>[
                                  0.25,
                                  0.75
                                ])),
                            MarkerPointer(
                              value: data.data!.status.batteryLevel.toDouble(),
                              markerType: MarkerType.circle,
                              color: const Color(0xFFC9BBCF),
                            )
                          ],
                          axisLineStyle: const AxisLineStyle(
                            thickness: 0.1,
                            cornerStyle: CornerStyle.bothCurve,
                            color: Color.fromARGB(255, 38, 50, 65),
                            thicknessUnit: GaugeSizeUnit.factor,
                          ),
                        )
                      ],
                    ),
                    Flexible(
                        child: ListView.builder(
                            itemCount: data.data!.history.length,
                            itemBuilder: (context, index) {
                              final item = data.data!.history[index];
                              final chargePercent =
                                  item.chargingEnd.batteryLevel -
                                      item.chargingStart.batteryLevel;
                              final chargeDuration = item.chargingEnd.timestamp
                                  .difference(item.chargingStart.timestamp)
                                  .inMinutes;
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 4),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: const Color(0xff1B2430),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xff51557E),
                                        blurRadius: 6.0,
                                        spreadRadius: 0.0,
                                        offset: Offset(
                                          0.0,
                                          3.0,
                                        ),
                                      )
                                    ]),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          'Battery charged by',
                                          style: TextStyle(
                                              color: Colors.blueGrey.shade200),
                                        ),
                                        Text(
                                          chargePercent < 1
                                              ? '<1%'
                                              : '$chargePercent %',
                                          style: const TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff7A86B6)),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        const Text('Battery charged for'),
                                        Text(chargeDuration < 1
                                            ? '<1 min'
                                            : '$chargeDuration minutes'),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            })),
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
