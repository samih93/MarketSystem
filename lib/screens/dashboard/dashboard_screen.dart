import 'package:flutter/material.dart';
import 'package:marketsystem/shared/constant.dart';
import 'package:marketsystem/shared/styles.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class DashBoardScreen extends StatelessWidget {
  int currentYear;
  int currentMonth;
  DashBoardScreen(this.currentYear, this.currentMonth);

  List<String> months = [
    'January',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

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
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: myLinearGradient,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
              color: Colors.grey.shade600,
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      months[currentMonth - 1] + " - $currentYear",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 2,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            //Initialize the chart widget
            Container(
              color: Colors.amberAccent,
              height: 30,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Daily Sales",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SfCartesianChart(
                enableSideBySideSeriesPlacement: false,
                primaryXAxis: CategoryAxis(),
                // Chart title
                // title: ChartTitle(
                //   text: 'Daily Sales',
                // ),
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
            Container(
              color: Colors.amberAccent,
              height: 30,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Best Selling",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SfCartesianChart(
              plotAreaBorderWidth: 0,
              // title: ChartTitle(text: 'Best Selling'),
              primaryXAxis: CategoryAxis(
                  majorGridLines: const MajorGridLines(width: 0),
                  labelIntersectAction: AxisLabelIntersectAction.rotate45),
              primaryYAxis: NumericAxis(
                  axisLine: const AxisLine(width: 0),
                  labelFormat: '{value}%',
                  majorTickLines: const MajorTickLines(size: 0)),
              series: _getDefaultColumnSeries(),
              tooltipBehavior: TooltipBehavior(
                  enable: true, header: '', canShowMarker: false),
            ),
            Container(
              color: Colors.amberAccent,
              height: 30,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Most Profitable",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SfCartesianChart(
              plotAreaBorderWidth: 0,
              // title: ChartTitle(text: 'Best Selling'),
              primaryXAxis: CategoryAxis(
                  majorGridLines: const MajorGridLines(width: 0),
                  labelIntersectAction: AxisLabelIntersectAction.rotate45),
              primaryYAxis: NumericAxis(
                  axisLine: const AxisLine(width: 0),
                  labelFormat: '{value} LL',
                  majorTickLines: const MajorTickLines(size: 0)),
              series: _getDefaultColumnSeries(),
              tooltipBehavior: TooltipBehavior(
                  enable: true, header: '', canShowMarker: false),
            ),
          ]),
        ));
  }

  /// Get default column series
  List<ColumnSeries<ChartSampleData, String>> _getDefaultColumnSeries() {
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
        dataSource: <ChartSampleData>[
          ChartSampleData(x: 'China', y: 0.541),
          ChartSampleData(x: 'Brazil', y: 0.818),
          ChartSampleData(x: 'Bolivia', y: 1.51),
          ChartSampleData(x: 'Mexico', y: 1.302),
          ChartSampleData(x: 'Egypt', y: 2.017),
          ChartSampleData(x: 'Mongolia', y: 1.683),
        ],
        xValueMapper: (ChartSampleData sales, _) => sales.x as String,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        dataLabelSettings: const DataLabelSettings(
            isVisible: true, textStyle: TextStyle(fontSize: 10)),
      )
    ];
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}

class ChartSampleData {
  ChartSampleData({required this.x, required this.y});
  String x;
  double y;
}
