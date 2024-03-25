import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

import 'bar_chart_model.dart';

class BarGraph extends StatelessWidget {
  BarGraph({Key? key}) : super(key: key);
  final List<BarChartModel> data = [
    BarChartModel(
      day: "Sun",
      time: 4,
      color: charts.ColorUtil.fromDartColor(Colors.blueGrey),
    ),
    BarChartModel(
      day: "Mon",
      time: 5,
      color: charts.ColorUtil.fromDartColor(Colors.red),
    ),
    BarChartModel(
      day: "Tue",
      time: 9,
      color: charts.ColorUtil.fromDartColor(Colors.green),
    ),
    BarChartModel(
      day: "Wed",
      time: 11,
      color: charts.ColorUtil.fromDartColor(Colors.yellow),
    ),
    BarChartModel(
      day: "Thurs",
      time: 8,
      color: charts.ColorUtil.fromDartColor(Colors.lightBlueAccent),
    ),
    BarChartModel(
      day: "Fri",
      time: 6,
      color: charts.ColorUtil.fromDartColor(Colors.pink),
    ),
    BarChartModel(
      day: "Sat",
      time: 3,
      color: charts.ColorUtil.fromDartColor(Colors.purple),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    List<charts.Series<BarChartModel, String>> series = [
      charts.Series(
        id: "financial",
        data: data,
        domainFn: (BarChartModel series, _) => series.day,
        measureFn: (BarChartModel series, _) => series.time,
        colorFn: (BarChartModel series, _) => series.color,
      ),
    ];

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
        child: charts.BarChart(
          series,
          animate: true,

        ),
      ),
    );
  }
}
