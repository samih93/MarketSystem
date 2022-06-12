import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:flutter/cupertino.dart';
import 'package:marketsystem/models/printermodel.dart';
import 'package:marketsystem/models/product.dart';
import 'package:marketsystem/services/printer/printer_api.dart';

class PrintManagementController extends ChangeNotifier {
  bool connected = false;
  List<PrinterModel> availableBluetoothDevices = [];

  Future<void> getBluetooth() async {
    availableBluetoothDevices = [];
    final List? bluetooths = await BluetoothThermalPrinter.getBluetooths;
    print("Print $bluetooths");
    if (bluetooths != null) {
      bluetooths.forEach((element) {
        List list = element.toString().split('#');
        String name = list[0];
        String mac = list[1];
        availableBluetoothDevices
            .add(PrinterModel(name: name, macAddress: mac));
      });
    }
    // String name = list[0];
    notifyListeners();
  }

  Future<void> setConnect(String mac) async {
    final String? result = await BluetoothThermalPrinter.connect(mac);

    print("state conneected $result");
    if (result == "true") {
      availableBluetoothDevices.forEach((element) {
        if (element.macAddress == mac) {
          element.isconnected = true;
        }
      });
      notifyListeners();
    }
  }

  Future<void> printTicket(List<ProductModel> products) async {
    String? isConnected = await BluetoothThermalPrinter.connectionStatus;
    if (isConnected == "true") {
      List<int> bytes = await PrintApi.getTicket(products);
      final result = await BluetoothThermalPrinter.writeBytes(bytes);
      print("Print $result");
    } else {
      //Hadnle Not Connected Senario
    }
  }
}
