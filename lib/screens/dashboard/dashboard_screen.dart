import 'package:flutter/material.dart';
import 'package:marketsystem/controllers/facture_controller.dart';
import 'package:marketsystem/controllers/products_controller.dart';
import 'package:marketsystem/models/viewmodel/best_selling.dart';
import 'package:marketsystem/models/viewmodel/daily_sales.dart';
import 'package:marketsystem/models/viewmodel/profitable_vmodel.dart';
import 'package:marketsystem/shared/constant.dart';
import 'package:marketsystem/shared/styles.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class DashBoardScreen extends StatelessWidget {
  DateTime? currentdate;
  DashBoardScreen(this.currentdate);

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
    int current_year = int.parse(currentdate.toString().split("-")[0]);
    int current_month = int.parse(currentdate.toString().split("-")[1]);

    int firstDayInmonth =
        int.parse(currentdate.toString().split(" ")[0].split("-")[2]);
    int latestday_inCurrentMonth = new DateTime(2013, current_month + 1, 0)
        .day; // to get latest day in month
    print("first day $firstDayInmonth");
    print("last day $latestday_inCurrentMonth");
    return ChangeNotifierProvider<FactureController>(
      create: (_) => FactureController()
        ..getBestSelling()
        ..getMostprofitableList()
        ..getDailysalesIn_month(current_year, current_month, firstDayInmonth,
            latestday_inCurrentMonth),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('DashBoard'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: myLinearGradient,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.grey.shade600,
                height: 60,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        months[current_month - 1] + " - $current_year",
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
              Consumer<FactureController>(
                  builder: (context, controller, child) {
                return SfCartesianChart(
                    enableSideBySideSeriesPlacement: false,
                    primaryXAxis: CategoryAxis(),
                    primaryYAxis: NumericAxis(
                        axisLine: const AxisLine(width: 0),
                        labelFormat: '{value} LL',
                        majorTickLines: const MajorTickLines(size: 0)),
                    // Chart title
                    // title: ChartTitle(
                    //   text: 'Daily Sales',
                    // ),
                    // disable legend
                    legend: Legend(isVisible: false),
                    // Enable tooltip
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <ChartSeries<DailySalesVm, String>>[
                      LineSeries<DailySalesVm, String>(
                          dataSource: controller.list_of_DailySalesInMonth,
                          xValueMapper: (DailySalesVm dSVm, _) =>
                              dSVm.day_in_month.toString(),
                          yValueMapper: (DailySalesVm dSVm, _) =>
                              double.parse(dSVm.total_sales_in_day.toString()),
                          name: 'Sales',
                          // Enable data label
                          dataLabelSettings: DataLabelSettings(
                            isVisible: true,
                          ))
                    ]);
              }),
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
              //NOTE best selling diagram
              Consumer<FactureController>(
                  builder: (context, controller, child) {
                return SfCartesianChart(
                  plotAreaBorderWidth: 0,
                  // title: ChartTitle(text: 'Best Selling'),
                  primaryXAxis: CategoryAxis(
                      majorGridLines: const MajorGridLines(width: 0),
                      labelIntersectAction: AxisLabelIntersectAction.rotate45),
                  primaryYAxis: NumericAxis(
                      axisLine: const AxisLine(width: 0),
                      labelFormat: '{value}',
                      majorTickLines: const MajorTickLines(size: 0)),
                  series: _getBestSellingColumnSeries(context),
                  tooltipBehavior: TooltipBehavior(
                      enable: true, header: '', canShowMarker: false),
                );
              }),
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
              Consumer<FactureController>(
                  builder: (context, controller, child) {
                return SfCartesianChart(
                  plotAreaBorderWidth: 0,
                  // title: ChartTitle(text: 'Best Selling'),
                  primaryXAxis: CategoryAxis(
                      majorGridLines: const MajorGridLines(width: 0),
                      labelIntersectAction: AxisLabelIntersectAction.rotate45),
                  primaryYAxis: NumericAxis(
                      axisLine: const AxisLine(width: 0),
                      labelFormat: '{value} LL ',
                      majorTickLines: const MajorTickLines(size: 0)),
                  series: _getMostProfitableColumnSeries(context),
                  tooltipBehavior: TooltipBehavior(
                      enable: true, header: '', canShowMarker: false),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  /// Get default column series
  List<ColumnSeries<BestSellingVmodel, String>> _getBestSellingColumnSeries(
      BuildContext context) {
    return <ColumnSeries<BestSellingVmodel, String>>[
      ColumnSeries<BestSellingVmodel, String>(
        dataSource: context.read<FactureController>().list_of_BestSelling,
        xValueMapper: (BestSellingVmodel bSVm, _) => bSVm.name.toString(),
        yValueMapper: (BestSellingVmodel bSVm, _) =>
            double.parse(bSVm.qty.toString()),
        dataLabelSettings: const DataLabelSettings(
            isVisible: true, textStyle: TextStyle(fontSize: 10)),
      )
    ];
  }
}

List<ColumnSeries<ProfitableVModel, String>> _getMostProfitableColumnSeries(
    BuildContext context) {
  return <ColumnSeries<ProfitableVModel, String>>[
    ColumnSeries<ProfitableVModel, String>(
      dataSource: context.read<FactureController>().list_of_profitableProduct,
      xValueMapper: (ProfitableVModel pVm, _) => pVm.name.toString(),
      yValueMapper: (ProfitableVModel pVm, _) =>
          double.parse(pVm.total_profit.toString()),
      dataLabelSettings: const DataLabelSettings(
          isVisible: true, textStyle: TextStyle(fontSize: 10)),
    )
  ];
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
