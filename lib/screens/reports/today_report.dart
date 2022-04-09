import 'package:flutter/material.dart';
import 'package:marketsystem/controllers/facture_controller.dart';
import 'package:provider/provider.dart';

class TodayReportScreen extends StatelessWidget {
  const TodayReportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        return FactureController()..getTodayReport();
      },
      child: Consumer<FactureController>(
          builder: (BuildContext context, facturecontroller, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Today Report"),
          ),
          body: ListView.separated(
              itemBuilder: (context, index) {
                return Container(
                  height: 100,
                  child: ListTile(
                    title: Text(facturecontroller
                        .list_of_detailsFacture[index].name
                        .toString()),
                    trailing: Container(
                      width: 50,
                      child: Text(facturecontroller
                          .list_of_detailsFacture[index].qty
                          .toString()),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
              itemCount: context
                  .read<FactureController>()
                  .list_of_detailsFacture
                  .length),
        );
      }),
    );
  }
}
