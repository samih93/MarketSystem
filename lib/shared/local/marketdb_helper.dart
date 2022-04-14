import 'package:sqflite/sqflite.dart';

class MarketDbHelper {
  MarketDbHelper._();
  static final MarketDbHelper db = MarketDbHelper._();
  late Database database;

  Future<void> init() async {
    database = await openDatabase(
      'Market.db',
      version: 1,
      onCreate: (db, version) {
        print("database created");
        // NOTE create table product
        db
            .execute(
                "Create Table products(barcode TEXT ,name TEXT,price INTEGER,totalprice INTEGER,qty INTEGER)")
            .then((value) => print('products table created'))
            .catchError((onError) => print(onError.toString()));

        // NOTE create table factures
        db
            .execute(
                "Create Table factures(id INTEGER PRIMARY KEY AUTOINCREMENT ,price INTEGER,facturedate TEXT)")
            .then((value) => print('factures table created'))
            .catchError((onError) => print(onError.toString()));

        db
            .execute(
                "Create Table detailsfacture(id INTEGER PRIMARY KEY AUTOINCREMENT ,barcode TEXT ,name TEXT,qty INTEGER,price INTEGER,facture_id INTEGER)")
            .then((value) => print('detailsfactures table created'))
            .catchError((onError) => print(onError.toString()));
      },
      onOpen: (database) {
        print('database opened');
      },
    );
  }
}
