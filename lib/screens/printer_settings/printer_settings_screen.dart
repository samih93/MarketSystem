import 'package:flutter/material.dart';
import 'package:marketsystem/controllers/printManagementController.dart';
import 'package:marketsystem/services/printer/printer_api.dart';
import 'package:marketsystem/shared/styles.dart';
import 'package:provider/provider.dart';

class PrinterSettingScreen extends StatelessWidget {
  PrinterSettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Printer Configuration'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: myLinearGradient,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Search Paired Bluetooth"),
            TextButton(
              onPressed: () async {
                await context.read<PrintManagementController>()
                  ..getBluetooth();
              },
              child: Text("Search"),
            ),
            Consumer<PrintManagementController>(
                builder: (context, printcontroller, child) {
              return Container(
                height: 200,
                child: ListView.builder(
                  itemCount:
                      printcontroller.availableBluetoothDevices.length > 0
                          ? printcontroller.availableBluetoothDevices.length
                          : 0,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        // connect to mac address
                        printcontroller.setConnect(printcontroller
                            .availableBluetoothDevices[index].macAddress
                            .toString());
                      },
                      title: Text(
                          '${printcontroller.availableBluetoothDevices[index].name}'),
                      subtitle: printcontroller.availableBluetoothDevices[index]
                                  .isconnected ==
                              true
                          ? Text("Connected",
                              style: TextStyle(
                                color: Colors.green,
                              ))
                          : Text("Click to connect"),
                    );
                  },
                ),
              );
            }),
            SizedBox(
              height: 30,
            ),
            // TextButton(
            //   onPressed: connected ? this.printGraphics : null,
            //   child: Text("Print"),
            // ),
          ],
        ),
      ),
    );
  }
}
