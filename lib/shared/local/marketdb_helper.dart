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
        db
            .execute(
                "Create Table products(barcode TEXT ,name TEXT,price INTEGER)")
            .then((value) => print('table created'))
            .catchError((onError) => print(onError.toString()));
      },
      onOpen: (database) {
        print('database opened');
      },
    );
  }
}
