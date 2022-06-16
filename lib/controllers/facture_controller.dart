import 'package:flutter/cupertino.dart';
import 'package:marketsystem/models/details_facture.dart';
import 'package:marketsystem/models/facture.dart';
import 'package:marketsystem/models/viewmodel/best_selling.dart';
import 'package:marketsystem/models/viewmodel/daily_sales.dart';
import 'package:marketsystem/models/viewmodel/earn_spent_vmodel.dart';
import 'package:marketsystem/models/viewmodel/low_qty_model.dart';
import 'package:marketsystem/models/viewmodel/profitable_vmodel.dart';
import 'package:marketsystem/shared/constant.dart';
import 'package:marketsystem/shared/local/marketdb_helper.dart';

class FactureController extends ChangeNotifier {
  MarketDbHelper marketdb = MarketDbHelper.db;

//NOTE get list of receipts
  List<FactureModel> list_of_receipts = [];

  Future<List<FactureModel>> getReceiptsByDate(String date) async {
    print(date);
    var dbm = await marketdb.database;
    await dbm
        .rawQuery(
            "select * from factures where facturedate='$date' order by facturedate desc")
        .then((value) {
      print("lenght : " + value.length.toString());
      if (value.length > 0) {
        value.forEach((element) {
          list_of_receipts.add(FactureModel.fromJson(element));
        });
      } else {
        print("no receipts yet");
      }

      list_of_receipts.forEach((element) {
        print(element.toJson());
      });
      notifyListeners();
    });
    return list_of_receipts;
  }

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
      String startdate, String enddate,
      {String? receiptId}) async {
    List<DetailsFactureModel> _list_of_detailsFacture = [];
    var dbm = await marketdb.database;
    // print("date : " + date.toString());
    // print("today " + gettodayDate().toString());
    String query =
        "select df.barcode , df.name, SUM(df.qty) as qty , (df.price/df.qty) as price , SUM(df.price) as totalprice  from detailsfacture as df , factures as f on df.facture_id=f.id where f.facturedate>='${startdate}' and f.facturedate<='${enddate}'";
    if (receiptId != null) query += ' and f.id="$receiptId"';

    query += " group by df.barcode order by df.name";
    await dbm.rawQuery(query).then((value) {
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

  List<BestSellingVmodel> _list_of_BestSelling = [];
  List<BestSellingVmodel> get list_of_BestSelling => _list_of_BestSelling;

  Future<List<BestSellingVmodel>> getBestSelling(
      {String? nbOfproduct, DateTime? currentdate}) async {
    _list_of_BestSelling = [];
    var dbm = await marketdb.database;
    // print("date : " + date.toString());
    // print("today " + gettodayDate().toString());

//NOTE need to join to order by barcode
    String query =
        "select df.barcode , df.name, SUM(df.qty) as qty  from detailsfacture as df join factures as f on df.facture_id = f.id ";
    if (currentdate != null) {
      String firstDateInCurrentMonth =
          "${getCurrentYear(currentdate)}-${getCurrentMonth(currentdate)}-${getFirstDayInMonth(currentdate)}";
      String lastDateInCurrentMonth =
          "${getCurrentYear(currentdate)}-${getCurrentMonth(currentdate)}-${getLastDayInCurrentMonth(currentdate)}";
      query +=
          " where f.facturedate>='$firstDateInCurrentMonth' and f.facturedate<='$lastDateInCurrentMonth'";
    }
    query += ' group by barcode order by qty desc';
    query += nbOfproduct != null ? " limit $nbOfproduct" : " limit 15";

    await dbm.rawQuery(query).then((value) {
      if (value.length > 0)
        value.forEach((element) {
          _list_of_BestSelling.add(BestSellingVmodel.fromJson(element));
        });
      notifyListeners();
      //  .forEach((element) => print(element.toJson()));
    });
    return _list_of_BestSelling;
  }

//NOTE get most profitable item
  List<ProfitableVModel> _list_of_profitableProduct = [];
  List<ProfitableVModel> get list_of_profitableProduct =>
      _list_of_profitableProduct;

  Future<List<ProfitableVModel>> getMostprofitableList(
      {String? nbOfproduct, DateTime? currentdate}) async {
    _list_of_profitableProduct = [];
    var dbm = await marketdb.database;
    // print("date : " + date.toString());
    // print("today " + gettodayDate().toString());

    String query =
        "select df.barcode , df.name, SUM(df.qty) as qty , df.profit_per_item_on_sale as profit_per_item_on_sale , SUM(df.qty*df.profit_per_item_on_sale) as total_profit  from detailsfacture as df  join  factures as f on df.facture_id=f.id join  products as p on p.barcode = df.barcode";
    if (currentdate != null) {
      String firstDateInCurrentMonth =
          "${getCurrentYear(currentdate)}-${getCurrentMonth(currentdate)}-${getFirstDayInMonth(currentdate)}";
      String lastDateInCurrentMonth =
          "${getCurrentYear(currentdate)}-${getCurrentMonth(currentdate)}-${getLastDayInCurrentMonth(currentdate)}";
      query +=
          " where f.facturedate>='$firstDateInCurrentMonth' and f.facturedate<='$lastDateInCurrentMonth'";
    }
    query += " group by df.barcode order by total_profit desc";

    //NOTE check nb of product if null set defualt 15
    query += nbOfproduct != null ? " limit $nbOfproduct" : " limit 15";

    await dbm.rawQuery(query).then((value) {
      if (value.length > 0)
        value.forEach((element) {
          //print(object)
          // print(element['barcode']);
          _list_of_profitableProduct.add(ProfitableVModel.fromJson(element));
        });
      notifyListeners();
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

  //NOTE get total spent and earn in one month
  Future<List<EarnSpentVmodel>> getEarnSpentGoupeByItem() async {
    List<EarnSpentVmodel> _list_of_Earn_SpentByIytem = [];
    var dbm = await marketdb.database;

//NOTE need to join to order by barcode
    await dbm
        .rawQuery(
            "select df.barcode , df.name, p.totalprice as total_spent , SUM(df.price) as total_earn , p.qty as rest_qty   from detailsfacture as df  join  products as p on p.barcode = df.barcode group by df.barcode order by df.name")
        .then((value) {
      if (value.length > 0)
        value.forEach((element) {
          _list_of_Earn_SpentByIytem.add(EarnSpentVmodel.fromJson(element));
        });
      //  .forEach((element) => print(element.toJson()));
    });
    return _list_of_Earn_SpentByIytem;
  }

  Future<List<LowQtyVModel>> getLowQtyProductInStore(String nbOfproduct) async {
    List<LowQtyVModel> _list_of_LowQtyVModel = [];
    var dbm = await marketdb.database;
    // print("date : " + date.toString());
    // print("today " + gettodayDate().toString());

//NOTE need to join to order by barcode
    await dbm
        .rawQuery(
            "select barcode , name,qty from Products group by barcode order by qty asc limit $nbOfproduct")
        .then((value) {
      if (value.length > 0)
        value.forEach((element) {
          _list_of_LowQtyVModel.add(LowQtyVModel.fromJson(element));
        });
      //  .forEach((element) => print(element.toJson()));
    });
    return _list_of_LowQtyVModel;
  }

  //NOTE get dailySales diagram report

  List<DailySalesVm> _list_of_DailySalesInMonth = [];
  List<DailySalesVm> get list_of_DailySalesInMonth =>
      _list_of_DailySalesInMonth;
  bool isHasDailySalesInMonth = false;
  Future<void> getDailysalesIn_month(DateTime date) async {
    var dbm = await marketdb.database;

    for (int i = getFirstDayInMonth(date);
        i <= getLastDayInCurrentMonth(date);
        i++) {
      String currentDate =
          "${getCurrentYear(date)}-${getCurrentMonth(date)}-${getCurrentDayInMonth(i)}";
      print("CurrentDate " + currentDate.toString());
      await dbm
          .rawQuery(
              "select  Sum(price) as total_sales_in_day  from factures where facturedate='$currentDate'")
          .then((value) {
        value.forEach((element) {
          DailySalesVm dailySalesVm = DailySalesVm.fromJson(element);
          dailySalesVm.day_in_month = i;
          //    print(dailySalesVm.toJson());
          _list_of_DailySalesInMonth.add(dailySalesVm);
        });

//NOTE to check if has a total sales >0
        if (isHasDailySalesInMonth == false) {
          isHasDailySalesInMonth = _list_of_DailySalesInMonth
              .any((element) => element.total_sales_in_day! > 0);
        }

        print(isHasDailySalesInMonth);

        notifyListeners();
        //print(value.toList());
      });
    }
  }
}
