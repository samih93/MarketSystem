import 'package:flutter/cupertino.dart';
import 'package:marketsystem/models/details_facture.dart';
import 'package:marketsystem/models/viewmodel/best_selling.dart';
import 'package:marketsystem/models/viewmodel/profitable_vmodel.dart';
import 'package:marketsystem/models/viewmodel/transactions_vmodel.dart';
import 'package:marketsystem/shared/constant.dart';
import 'package:marketsystem/shared/local/marketdb_helper.dart';

class FactureController extends ChangeNotifier {
  MarketDbHelper marketdb = MarketDbHelper.db;

  Future<List<DetailsFactureModel>> getReportByDate(String date) async {
    List<DetailsFactureModel> _list_of_detailsFacture = [];
    var dbm = await marketdb.database;
    print("date : " + date.toString());
    print("today " + gettodayDate().toString());

    await dbm
        .rawQuery(
            "select df.barcode , df.name, SUM(df.qty) as qty , (df.price/df.qty) as price , SUM(df.price) as totalprice  from detailsfacture as df , factures as f on df.facture_id=f.id where f.facturedate='${date}'  group by df.barcode order by df.name")
        .then((value) {
      if (value.length > 0)
        value.forEach((element) {
          //print(object)
          // print(element['barcode']);
          _list_of_detailsFacture.add(DetailsFactureModel.fromJson(element));
        });
    });
    return _list_of_detailsFacture;
  }

  Future<List<DetailsFactureModel>> getDetailsFacturesBetweenTwoDates(
      String startdate, String enddate) async {
    List<DetailsFactureModel> _list_of_detailsFacture = [];
    var dbm = await marketdb.database;
    // print("date : " + date.toString());
    // print("today " + gettodayDate().toString());

    await dbm
        .rawQuery(
            "select df.barcode , df.name, SUM(df.qty) as qty , (df.price/df.qty) as price , SUM(df.price) as totalprice  from detailsfacture as df , factures as f on df.facture_id=f.id where f.facturedate>='${startdate}' and f.facturedate<='${enddate}'  group by df.barcode order by df.name")
        .then((value) {
      if (value.length > 0)
        value.forEach((element) {
          //print(object)
          // print(element['barcode']);
          _list_of_detailsFacture.add(DetailsFactureModel.fromJson(element));
        });
      //  _list_of_detailsFacture.forEach((element) => print(element.toJson()));
    });
    return _list_of_detailsFacture;
  }

//-----------NOTE get Best Selling products -------------

  Future<List<BestSellingVmodel>> getBestSelling(String nbOfproduct) async {
    List<BestSellingVmodel> _list_of_BestSelling = [];
    var dbm = await marketdb.database;
    // print("date : " + date.toString());
    // print("today " + gettodayDate().toString());

//NOTE need to join to order by barcode
    await dbm
        .rawQuery(
            "select barcode , name, SUM(qty) as qty  from detailsfacture group by barcode order by qty desc limit $nbOfproduct")
        .then((value) {
      if (value.length > 0)
        value.forEach((element) {
          _list_of_BestSelling.add(BestSellingVmodel.fromJson(element));
        });
      //  .forEach((element) => print(element.toJson()));
    });
    return _list_of_BestSelling;
  }

//NOTE get most profitable item

  Future<List<ProfitableVModel>> getMostprofitableList(
      String nbOfproduct) async {
    List<ProfitableVModel> _list_of_profitableProduct = [];
    var dbm = await marketdb.database;
    // print("date : " + date.toString());
    // print("today " + gettodayDate().toString());

    await dbm
        .rawQuery(
            "select df.barcode , df.name, df.qty , p.profit_per_item as profit_per_item , df.qty*p.profit_per_item as total_profit  from detailsfacture as df  join  factures as f on df.facture_id=f.id join  products as p on p.barcode = df.barcode group by df.barcode order by total_profit desc limit $nbOfproduct ")
        .then((value) {
      if (value.length > 0)
        value.forEach((element) {
          //print(object)
          // print(element['barcode']);
          _list_of_profitableProduct.add(ProfitableVModel.fromJson(element));
        });
      //_list_of_profitableProduct.forEach((element) => print(element.toJson()));
    });
    return _list_of_profitableProduct;
  }
// NOTE get all transaction by date ---------------------

  // Future<List<TransactionsVModel>> gettransactionsReport(String date) async {
  //   List<TransactionsVModel> _list_of_transactions = [];
  //   var dbm = await marketdb.database;
  //   print("date : " + date.toString());
  //   print("today " + gettodayDate().toString());

  //   await dbm
  //       .rawQuery(
  //           "select  df.name as name, df.qty as qty , df.price as price  from detailsfacture as df , factures as f on df.facture_id=f.id where f.facturedate='${date}'  group by df.barcode order by f.facturedate desc")
  //       .then((value) {
  //     if (value.length > 0)
  //       value.forEach((element) {
  //         //print(object)
  //         // print(element['barcode']);
  //         _list_of_transactions.add(TransactionsVModel.fromJson(element));
  //       });
  //   });
  //   return _list_of_transactions;
  // }
}
