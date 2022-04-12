import 'package:flutter/cupertino.dart';
import 'package:marketsystem/models/details_facture.dart';
import 'package:marketsystem/shared/constant.dart';
import 'package:marketsystem/shared/local/marketdb_helper.dart';

class FactureController extends ChangeNotifier {
  MarketDbHelper marketdb = MarketDbHelper.db;

  List<DetailsFactureModel> _list_of_detailsFacture = [];
  List<DetailsFactureModel> get list_of_detailsFacture =>
      _list_of_detailsFacture;
  Future<List<DetailsFactureModel>> getReportByDate(String date) async {
    _list_of_detailsFacture = [];
    var dbm = await marketdb.database;
    print("date : " + date.toString());
    print("today " + gettodayDate().toString());

    await dbm
        .rawQuery(
            "select * from detailsfacture as df , factures as f on df.facture_id=f.id where f.facturedate='${date}'")
        .then((value) {
      if (value.length > 0)
        value.forEach((element) {
          _list_of_detailsFacture.add(DetailsFactureModel.fromJson(element));
        });
      _list_of_detailsFacture.forEach((element) => print(element.toJson()));

      notifyListeners();
    });
    return _list_of_detailsFacture;
  }
}
