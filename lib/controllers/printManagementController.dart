import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:flutter/cupertino.dart';
import 'package:marketsystem/models/printermodel.dart';
import 'package:marketsystem/models/product.dart';
import 'package:marketsystem/services/printer/printer_api.dart';
import 'package:marketsystem/shared/local/cash_helper.dart';

class PrintManagementController extends ChangeNotifier {
  List<PrinterModel> availableBluetoothDevices = [];

  bool isloadingsearch_for_device = false;
  Future<void> getBluetooth() async {
    availableBluetoothDevices = [];
    isloadingsearch_for_device = true;
    await BluetoothThermalPrinter.getBluetooths.then((value) {
      print("value :" + value.toString());
      if (value != null) {
        value.forEach((element) {
          List list = element.toString().split('#');
          String name = list[0];
          String mac = list[1];
          availableBluetoothDevices
              .add(PrinterModel(name: name, macAddress: mac));
        });
      }
      isloadingsearch_for_device = false;
      notifyListeners();
    }).catchError((error) {
      print(error.toString());
      isloadingsearch_for_device = false;
      notifyListeners();
    });
  }

  bool isloadingconnect = false;
  Future<void> setConnect(String mac) async {
    print(mac.toString() + " to connect");
    isloadingconnect = true;
    notifyListeners();
    await BluetoothThermalPrinter.connect(mac).then((value) {
      print("state connected $value");
      if (value == "true") {
        availableBluetoothDevices.forEach((element) {
          if (element.macAddress == mac) {
            element.isconnected = true;
          }
        });
        CashHelper.saveData(key: "device_mac", value: mac);
        isloadingconnect = false;
        notifyListeners();
      }
    }).catchError((error) {
      print("error :" + error.toString());
      isloadingconnect = false;
      notifyListeners();
    });
    print(isloadingconnect);
  }

  bool connected = false;

  Future<void> printTicket(List<ProductModel> products,
      {String? cash, String? change}) async {
    String? isConnected = await BluetoothThermalPrinter.connectionStatus;
    if (isConnected == "true") {
      List<int> bytes =
          await PrintApi.getTicket(products, cash: cash, change: change);
      final result = await BluetoothThermalPrinter.writeBytes(bytes);
      print("Print $result");
      connected = true;
      notifyListeners();
    } else {
      //Hadnle Not Connected Senario
      connected = false;
      notifyListeners();
    }
  }
}
