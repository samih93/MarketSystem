import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:flutter/cupertino.dart';
import 'package:marketsystem/models/printermodel.dart';
import 'package:marketsystem/models/product.dart';
import 'package:marketsystem/services/printer/printer_api.dart';
import 'package:marketsystem/shared/constant.dart';
import 'package:marketsystem/shared/local/cash_helper.dart';
import 'package:marketsystem/shared/toast_message.dart';

class PrintManagementController extends ChangeNotifier {
  bool isprintautomatically = false;
  PrintManagementController() {
    isprintautomatically =
        CashHelper.getData(key: 'isprintautomatically') ?? false;
    notifyListeners();
  }

  onsetprintautomatically(bool value) {
    isprintautomatically = value;
    CashHelper.saveData(key: "isprintautomatically", value: value);
    if (value) {
      showToast(message: "enabled", status: ToastStatus.Success);
    } else {
      showToast(message: "disabled", status: ToastStatus.Success);
    }
    notifyListeners();
  }

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
          bool isconnected = false;
          if (mac == device_mac) isconnected = true;
          availableBluetoothDevices.add(PrinterModel(
              name: name, macAddress: mac, isconnected: isconnected));
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
  Future<void> setConnect(String? mac) async {
    if (mac != null) {
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
    }
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
