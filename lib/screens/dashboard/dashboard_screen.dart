import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class DashBoardScreen extends StatelessWidget {
  List<_SalesData> data = [
    _SalesData('1', 35),
    _SalesData('2', 28),
    _SalesData('3', 34),
    _SalesData('4', 32),
    _SalesData('5', 50),
    _SalesData('6', 15),
    _SalesData('7', 21),
    _SalesData('8', 80),
    _SalesData('9', 14),
    _SalesData('10', 14),
    _SalesData('11', 14),
    _SalesData('12', 14),
    _SalesData('13', 14),
    _SalesData('14', 14),
    _SalesData('15', 14),
    _SalesData('16', 14),
    _SalesData('17', 14),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('DashBoard'),
        ),
        body: Column(children: [
          //Initialize the chart widget
          SfCartesianChart(
              enableSideBySideSeriesPlacement: false,
              primaryXAxis: CategoryAxis(),
              // Chart title
              title: ChartTitle(text: 'Daily Sales'),
              // disable legend
              legend: Legend(isVisible: false),
              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ChartSeries<_SalesData, String>>[
                LineSeries<_SalesData, String>(
                    dataSource: data,
                    xValueMapper: (_SalesData sales, _) => sales.year,
                    yValueMapper: (_SalesData sales, _) => sales.sales,
                    name: 'Sales',
                    // Enable data label
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                    ))
              ]),
        ]));
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
