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
                "Create Table products(barcode TEXT ,name TEXT,price INTEGER)")
            .then((value) => print('products table created'))
            .catchError((onError) => print(onError.toString()));

            //NOTE create table store
            db
            .execute(
                "Create Table store(barcode TEXT ,name TEXT,price INTEGER,qty INTEGER)")
            .then((value) => print('products store created'))
            .catchError((onError) => print(onError.toString()));

      },
      onOpen: (database) {
        print('database opened');
      },
    );
  }
}
