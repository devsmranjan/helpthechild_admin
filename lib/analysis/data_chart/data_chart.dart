import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'data.dart';

class DataChart extends StatelessWidget {
  final chartData;

  const DataChart({Key key, @required this.chartData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
        legend:
            Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
        series: <CircularSeries>[
          PieSeries<ChartData, String>(
              dataSource: chartData,
              pointColorMapper: (ChartData data, _) => data.color,
              xValueMapper: (ChartData data, _) => data.pin,
              yValueMapper: (ChartData data, _) => data.times,
              dataLabelSettings: DataLabelSettings(isVisible: true))
        ]);
  }
}
