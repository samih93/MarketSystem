import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:flutter/cupertino.dart';
import 'package:marketsystem/models/printermodel.dart';
import 'package:marketsystem/models/product.dart';
import 'package:marketsystem/screens/printer_settings/printer_settings_screen.dart';
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

  PageSize pageSize = PageSize.mm58; // default
  void onchagePageSize(value) {
    pageSize = value;
    notifyListeners();
  }

  // for printin on cash
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
    notifyListeners();
    await BluetoothThermalPrinter.getBluetooths.then((value) {
      print("value :" + value.toString());
      if (value!.length > 0) {
        value.forEach((element) async {
          List list = element.toString().split('#');
          String name = list[0];
          String mac = list[1];
          bool isconnected = false;

          await BluetoothThermalPrinter.connectionStatus.then((value) {
            if (value == "true" && mac == device_mac) isconnected = true;

            availableBluetoothDevices.add(PrinterModel(
                name: name, macAddress: mac, isconnected: isconnected));
          }).catchError((error) {
            print(error.toString());
            isloadingsearch_for_device = false;
            notifyListeners();
          });
        });
      } else {
        showToast(message: "enable bluetooth", status: ToastStatus.Error);
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
    print("mac :" + mac.toString());
    if (mac != null) {
      isloadingconnect = true;
      notifyListeners();

      await BluetoothThermalPrinter.connect(mac).then((value) {
        print("state connected $value");
        if (value == "true") {
          // change text to connected when this device is connected
          if (availableBluetoothDevices.length > 0)
            availableBluetoothDevices.forEach((element) {
              if (element.macAddress == mac) {
                element.isconnected = true;
              }
            });

          CashHelper.saveData(key: "device_mac", value: mac);
        }
        isloadingconnect = false;
        notifyListeners();
      }).catchError((error) {
        print("error :" + error.toString());
        isloadingconnect = false;
        notifyListeners();
      });
    }
  }

  Future<void> printTicket(List<ProductModel> products,
      {String? cash, String? change}) async {
    String? isConnected = await BluetoothThermalPrinter.connectionStatus;
    if (isConnected == "true") {
      List<int> bytes = await PrintApi.getTicket(products,
          cash: cash, change: change, pageSize: pageSize);
      final result = await BluetoothThermalPrinter.writeBytes(bytes);
      print("Print $result");
    } else {
      if (isprintautomatically == true)
        showToast(message: "Printer not connected", status: ToastStatus.Error);
    }
  }
}

enum PageSize { mm58, mm80 }
