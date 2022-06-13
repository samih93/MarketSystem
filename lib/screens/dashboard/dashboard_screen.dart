import 'package:flutter/material.dart';
import 'package:marketsystem/controllers/facture_controller.dart';
import 'package:marketsystem/models/viewmodel/best_selling.dart';
import 'package:marketsystem/models/viewmodel/daily_sales.dart';
import 'package:marketsystem/models/viewmodel/profitable_vmodel.dart';
import 'package:marketsystem/shared/constant.dart';
import 'package:marketsystem/shared/styles.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FactureController>(
      create: (_) => FactureController()
        ..getBestSelling(currentdate: currentdate)
        ..getMostprofitableList(currentdate: currentdate)
        ..getDailysalesIn_month(currentdate!),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('OverView'),
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
                        months[int.parse(getCurrentMonth(currentdate!)) - 1] +
                            " - ${getCurrentYear(currentdate!)}",
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
              //NOTE daily Sales diagram
              Consumer<FactureController>(
                  builder: (context, controller, child) {
                return SfCartesianChart(
                    enableSideBySideSeriesPlacement: false,
                    primaryXAxis: CategoryAxis(
                      title: AxisTitle(
                          text: "Day", alignment: ChartAlignment.center),
                    ),
                    primaryYAxis: NumericAxis(
                        isVisible:
                            controller.isHasDailySalesInMonth ? false : true,
                        title: AxisTitle(
                            text: "Money", alignment: ChartAlignment.center),
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
                    series: _getDailysalesInMonthColumnSeries(context));
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
                      title: AxisTitle(
                          text: "Products", alignment: ChartAlignment.center),
                      majorGridLines: const MajorGridLines(width: 0),
                      labelIntersectAction: AxisLabelIntersectAction.rotate45),
                  primaryYAxis: NumericAxis(
                      title: AxisTitle(
                          text: "Qty", alignment: ChartAlignment.center),
                      axisLine: const AxisLine(width: 0),
                      //labelFormat: '{value}',
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
                      title: AxisTitle(
                          text: "Products", alignment: ChartAlignment.center),
                      majorGridLines: const MajorGridLines(width: 0),
                      labelIntersectAction: AxisLabelIntersectAction.rotate45),
                  primaryYAxis: NumericAxis(
                      title: AxisTitle(
                          text: "Money", alignment: ChartAlignment.center),
                      isVisible: controller.list_of_BestSelling.length == 0
                          ? true
                          : false,
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

  List<ColumnSeries<DailySalesVm, String>> _getDailysalesInMonthColumnSeries(
      BuildContext context) {
    return <ColumnSeries<DailySalesVm, String>>[
      ColumnSeries<DailySalesVm, String>(
          dataSource:
              context.read<FactureController>().list_of_DailySalesInMonth,
          xValueMapper: (DailySalesVm dSVm, _) => dSVm.day_in_month.toString(),
          yValueMapper: (DailySalesVm dSVm, _) =>
              double.parse(dSVm.total_sales_in_day.toString()),
          name: 'Sales',
          // Enable data label
          dataLabelSettings: DataLabelSettings(
            showZeroValue: false,
            isVisible: true,
            textStyle: TextStyle(fontSize: 10),
          ))
    ];
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
            isVisible: true,
            showZeroValue: false,
            textStyle: TextStyle(
              fontSize: 10,
            )),
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
          showZeroValue: false,
          isVisible: true,
          textStyle: TextStyle(fontSize: 10)),
    )
  ];
}
