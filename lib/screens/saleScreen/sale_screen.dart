import 'package:flutter/material.dart';
import 'package:marketsystem/shared/styles.dart';

class SaleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

  _build_items() => Expanded(
        child: ListView.separated(
            itemBuilder: (context, index) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Pepsi"),
                    Text("25000 LL"),
                    Text("4"),
                  ],
                ),
            separatorBuilder: (context, index) => Divider(),
            itemCount: 10),
      );

  _build_header() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "item",
            style: headerProductTable,
          ),
          Text(
            "Price",
            style: headerProductTable,
          ),
          Text(
            "Qty",
            style: headerProductTable,
          ),
        ],
      );

  // _build_cashRow() => Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         GestureDetector(
  //           onTap: () {
  //             qrViewcontroller!.resumeCamera();
  //             setState(() {
  //               barCode = null;
  //             });
  //           },
  //           child: CircleAvatar(
  //             radius: 25,
  //             backgroundColor: defaultColor,
  //             child: Icon(
  //               Icons.check,
  //               size: 25,
  //               color: Colors.white,
  //             ),
  //           ),
  //         ),
  //         SizedBox(
  //           width: 15,
  //         ),
  //         GestureDetector(
  //           onTap: () {
  //             qrViewcontroller!.resumeCamera();
  //             setState(() {
  //               barCode = null;
  //             });
  //           },
  //           child: CircleAvatar(
  //             radius: 25,
  //             backgroundColor: defaultColor,
  //             child: Icon(
  //               Icons.replay_outlined,
  //               size: 25,
  //               color: Colors.white,
  //             ),
  //           ),
  //         ),
  //       ],
  //     );
}
