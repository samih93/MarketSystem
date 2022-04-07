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
          body: ListView.separated(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(facturecontroller
                      .list_of_detailsFacture[index].name
                      .toString()),
                  trailing: Text(facturecontroller
                      .list_of_detailsFacture[index].price
                      .toString()),
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
