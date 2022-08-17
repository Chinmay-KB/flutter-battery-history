import 'package:flutter/material.dart';

import 'package:battery_history/battery_history.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final history = BatteryHistoryPlugin();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(textTheme: GoogleFonts.khulaTextTheme()),
      home: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xff1B2430),
          body: StreamBuilder<BatteryHistory>(
            stream: history.batteryInfoStream(),
            builder: (context, data) {
              if (data.data != null) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BatteryGauge(
                      value: data.data!.status.batteryLevel.toDouble(),
                      chargingStatus: data.data!.status.chargingStatus,
                    ),
                    Flexible(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        itemCount: data.data!.history.length,
                        itemBuilder: (context, index) => BatteryHistoryItemCard(
                          item: data.data!.history[index],
                        ),
                      ),
                    ),
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

class BatteryHistoryItemCard extends StatelessWidget {
  const BatteryHistoryItemCard({Key? key, required this.item})
      : super(key: key);

  final BatteryHistoryItem item;

  @override
  Widget build(BuildContext context) {
    final chargePercent =
        item.chargingEnd.batteryLevel - item.chargingStart.batteryLevel;
    final chargeDuration = item.chargingEnd.timestamp
        .difference(item.chargingStart.timestamp)
        .inMinutes;
    final chargeStartTime =
        DateFormat.yMd().add_jm().format(item.chargingStart.timestamp);
    return Container(
      key: ValueKey(chargeStartTime),
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xff1B2430),
        border: Border.all(color: const Color(0xff51557E)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            chargeStartTime,
            style: TextStyle(fontSize: 10, color: Colors.blueGrey.shade200),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InfoSnippet(
                title: 'Battery charged',
                content: chargePercent < 1 ? '<1%' : '$chargePercent %',
              ),
              InfoSnippet(
                  title: 'Charging duration',
                  content:
                      chargeDuration < 1 ? '<1 min' : '$chargeDuration mins'),
            ],
          ),
        ],
      ),
    );
  }
}

class BatteryGauge extends StatelessWidget {
  const BatteryGauge(
      {Key? key, required this.chargingStatus, required this.value})
      : super(key: key);

  final double value;
  final String chargingStatus;

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      enableLoadingAnimation: true,
      axes: [
        RadialAxis(
          annotations: [
            GaugeAnnotation(
                positionFactor: 0.1,
                angle: 90,
                widget: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      value.toStringAsFixed(0) + '%',
                      style: const TextStyle(
                        fontSize: 80,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFD6D5A8),
                      ),
                    ),
                    Text(
                      chargingStatus,
                      style: const TextStyle(
                        fontSize: 24,
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
                value: value,
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
              value: value,
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
    );
  }
}

class InfoSnippet extends StatelessWidget {
  const InfoSnippet({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          content,
          style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color(0xff7A86B6)),
        ),
        Text(
          title,
          style: TextStyle(color: Colors.blueGrey.shade200),
        ),
      ],
    );
  }
}
