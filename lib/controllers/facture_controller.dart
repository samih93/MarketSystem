import 'package:flutter/cupertino.dart';
import 'package:marketsystem/models/details_facture.dart';
import 'package:marketsystem/shared/local/marketdb_helper.dart';

class FactureController extends ChangeNotifier {
  MarketDbHelper marketdb = MarketDbHelper.db;

  List<DetailsFactureModel> _list_of_detailsFacture = [];
  List<DetailsFactureModel> get list_of_detailsFacture =>
      _list_of_detailsFacture;
  Future<void> getTodayReport() async {
    _list_of_detailsFacture = [];
    var dbm = await marketdb.database;

    await dbm.rawQuery("select * from detailsfacture").then((value) {
      value.forEach((element) {
        _list_of_detailsFacture.add(DetailsFactureModel.fromJson(element));
      });
      notifyListeners();
    });
  }
}
