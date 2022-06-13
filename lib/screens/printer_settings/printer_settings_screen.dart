import 'package:flutter/material.dart';
import 'package:marketsystem/controllers/printManagementController.dart';
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Search Paired Bluetooth",
                  style: TextStyle(color: Colors.grey.shade800, fontSize: 20),
                ),
                TextButton(
                  onPressed: () async {
                    await context.read<PrintManagementController>()
                      ..getBluetooth();
                  },
                  child: Text("Search"),
                ),
              ],
            ),

            Consumer<PrintManagementController>(
                builder: (context, printcontroller, child) {
              return Expanded(
                child: Container(
                  height: 200,
                  child: printcontroller.isloadingsearch_for_device
                      ? Center(child: CircularProgressIndicator())
                      : printcontroller.availableBluetoothDevices.length == 0
                          ? Center(
                              child: Text(
                              "devices not found",
                              style: TextStyle(color: Colors.grey),
                            ))
                          : Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                if (printcontroller.isloadingconnect == true)
                                  CircularProgressIndicator(),
                                ListView.builder(
                                  itemCount: printcontroller
                                              .availableBluetoothDevices
                                              .length >
                                          0
                                      ? printcontroller
                                          .availableBluetoothDevices.length
                                      : 0,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      onTap: () async {
                                        // connect to mac address
                                        await printcontroller.setConnect(
                                            printcontroller
                                                .availableBluetoothDevices[
                                                    index]
                                                .macAddress
                                                .toString());
                                      },
                                      title: Text(
                                          '${printcontroller.availableBluetoothDevices[index].name}'),
                                      subtitle: printcontroller
                                                  .availableBluetoothDevices[
                                                      index]
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
                              ],
                            ),
                ),
              );
            }),

            Text("Page Size"),
            ListTile(
              title: const Text('58 mm'),
              leading: Radio(
                value: PageSize.mm58,
                groupValue: context.read<PrintManagementController>().pageSize,
                onChanged: (PageSize? value) {
                  context
                      .read<PrintManagementController>()
                      .onchagePageSize(value);
                },
              ),
            ),
            ListTile(
              title: const Text('82 mm'),
              leading: Radio(
                value: PageSize.mm80,
                groupValue: context.read<PrintManagementController>().pageSize,
                onChanged: (PageSize? value) {
                  context
                      .read<PrintManagementController>()
                      .onchagePageSize(value);
                },
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Automatically print receipt"),
                Switch(
                  onChanged: (bool value) {
                    context
                        .read<PrintManagementController>()
                        .onsetprintautomatically(value);
                  },
                  value: context
                      .watch<PrintManagementController>()
                      .isprintautomatically,
                ),
              ],
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
