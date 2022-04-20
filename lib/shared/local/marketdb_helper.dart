import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

import 'dart:io' as io;

class MarketDbHelper {
  MarketDbHelper._();
  static final MarketDbHelper db = MarketDbHelper._();
  late Database database;

  Future<void> init() async {
    var databasesPath = await getDatabasesPath();
    var completepath = path.join(databasesPath, "Market.db");

    var exists = await databaseExists(completepath);
    print("database : " + exists.toString());

    if (!exists) {
      // Should happen only the first time you launch your application

      // NOTE------------START COPY DB FROM MY ASSETS ------------------
       //     print("Creating new copy from asset");

      // Make sure the parent directory exists
      // try {
      //   await Directory(path.dirname(completepath)).create(recursive: true);
      // } catch (_) {}

      // // Copy from asset
      // ByteData data =
      //     await rootBundle.load(path.join("assets/db", "Market.db"));
      // List<int> bytes =
      //     data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // // Write and flush the bytes written
      // await File(completepath).writeAsBytes(bytes, flush: true);

      // NOTE  -----------------Start Copy Db From Internet

      // link github https://github.com/samih93/MarketSystem/raw/master/Market.db

      print("Creating new copy from internet");

      String url = "https://github.com/samih93/MarketSystem/raw/master/Market.db";

      var httpClient = new io.HttpClient();
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();

      // thow an error if there was error getting the file
      // so it prevents from wrting the wrong content into the db file
      if (response.statusCode != 200) throw "Error getting db file";
      var bytes = await consolidateHttpClientResponseBytes(response);
      await File(completepath).writeAsBytes(bytes, flush: true);
    } else {
      print("Reading Existing Database");
    }

    // open the database
    database = await openDatabase(completepath);

//! old one without read database from assets
    // database = await openDatabase(
    //   'Market.db',
    //   version: 1,
    //   onCreate: (db, version) {
    //     print("database created");
    //     // NOTE create table product
    //     db
    //         .execute(
    //             "Create Table products(barcode TEXT ,name TEXT,price INTEGER,totalprice INTEGER,qty INTEGER)")
    //         .then((value) => print('products table created'))
    //         .catchError((onError) => print(onError.toString()));

    //     // NOTE create table factures
    //     db
    //         .execute(
    //             "Create Table factures(id INTEGER PRIMARY KEY AUTOINCREMENT ,price INTEGER,facturedate TEXT)")
    //         .then((value) => print('factures table created'))
    //         .catchError((onError) => print(onError.toString()));

    //     db
    //         .execute(
    //             "Create Table detailsfacture(id INTEGER PRIMARY KEY AUTOINCREMENT ,barcode TEXT ,name TEXT,qty INTEGER,price INTEGER,facture_id INTEGER)")
    //         .then((value) => print('detailsfactures table created'))
    //         .catchError((onError) => print(onError.toString()));
    //   },
    //   onOpen: (database) {
    //     print('database opened');
    //   },
    // );
  }
}
