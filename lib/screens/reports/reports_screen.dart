// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:marketsystem/controllers/auth_controller.dart';
// import 'package:marketsystem/controllers/facture_controller.dart';
// import 'package:marketsystem/controllers/products_controller.dart';
// import 'package:marketsystem/models/details_facture.dart';
// import 'package:marketsystem/models/viewmodel/best_selling.dart';
// import 'package:marketsystem/models/viewmodel/earn_spent_vmodel.dart';
// import 'package:marketsystem/models/viewmodel/low_qty_model.dart';
// import 'package:marketsystem/models/viewmodel/profitable_vmodel.dart';
// import 'package:marketsystem/screens/dashboard/dashboard_screen.dart';
// import 'package:marketsystem/screens/receipts_screen/receipts_screen.dart';
// import 'package:marketsystem/services/api/pdf_api.dart';
// import 'package:marketsystem/shared/components/default_text_form.dart';
// import 'package:marketsystem/shared/constant.dart';
// import 'package:marketsystem/shared/styles.dart';
// import 'package:marketsystem/shared/toast_message.dart';
// //import 'package:month_picker_dialog/month_picker_dialog.dart';

// import 'package:provider/provider.dart';
// import 'package:restart_app/restart_app.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';
// import 'package:sqflite/sqflite.dart';

// class ReportsScreen extends StatelessWidget {
//   final List<String> _report_title = [
//     "Receipts",
//     "Daily Sales",
//     "Sales Between Two Dates",
//     "Best Selling",
//     "Most profitable Products",
//     "Low Qty In Store",
//     "Spent / Earn by Item",
//     "DashBoard",
//   ];

//   final List<IconData> _report_icons = [
//     Icons.receipt,
//     Icons.report,
//     Icons.report,
//     Icons.loyalty_sharp,
//     Icons.turn_sharp_right_outlined,
//     Icons.warning_amber_rounded,
//     Icons.currency_exchange_outlined,
//     Icons.dashboard_outlined,
//   ];

//   var datecontroller = TextEditingController();
//   var startdatecontroller = TextEditingController();
//   var enddatecontroller = TextEditingController();
//   var nbOfProductsController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider<FactureController>(
//       create: (_) => FactureController(),
//       child: Scaffold(
//         body: Consumer<FactureController>(
//           builder: (context, facturecontroller, child) {
//             return SingleChildScrollView(
//               child: Padding(
//                 padding: EdgeInsets.only(
//                     left: MediaQuery.of(context).size.width * 0.04,
//                     top: MediaQuery.of(context).size.width * 0.04),
//                 child: Wrap(
//                   crossAxisAlignment: WrapCrossAlignment.center,
//                   spacing:
//                       MediaQuery.of(context).size.width * 0.04, // horizontal
//                   runSpacing: 8, // vertical
//                   children: [
//                     ..._report_title.map(
//                       (element) => _report_item(
//                         element,
//                         _report_icons[_report_title.indexOf(element)],
//                         _report_title.indexOf(element),
//                         context,
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   _report_item(
//     String title,
//     IconData icon,
//     int index,
//     BuildContext context,
//   ) {
//     AuthController authController = Provider.of<AuthController>(context);
//     return GestureDetector(
//       onTap: () async {
//         switch (index) {
//           case 0:
//             showDatePicker(
//                     context: context,
//                     initialDate: DateTime.now(),
//                     firstDate: DateTime.parse('2022-01-01'),
//                     lastDate: DateTime.parse('2040-01-01'))
//                 .then((value) {
//               //Todo: handle date to string
//               //print(DateFormat.yMMMd().format(value!));
//               var tdate = value.toString().split(' ');
//               //datecontroller.text = tdate[0];
//               Get.to(() => ReceiptsScreen(tdate[0].toString()));
//             });
//             break;
//           case 1:
//             datecontroller.clear();

//             Alert(
//                 context: context,
//                 title: "Enter Date",
//                 content: Column(
//                   children: <Widget>[
//                     defaultTextFormField(
//                         readonly: true,
//                         controller: datecontroller,
//                         inputtype: TextInputType.datetime,
//                         prefixIcon: Icon(Icons.date_range),
//                         ontap: () {
//                           showDatePicker(
//                                   context: context,
//                                   initialDate: DateTime.now(),
//                                   firstDate: DateTime.parse('2022-01-01'),
//                                   lastDate: DateTime.parse('2040-01-01'))
//                               .then((value) {
//                             //Todo: handle date to string
//                             //print(DateFormat.yMMMd().format(value!));
//                             var tdate = value.toString().split(' ');
//                             datecontroller.text = tdate[0];
//                           });
//                         },
//                         onvalidate: (value) {
//                           if (value!.isEmpty) {
//                             return "date must not be empty";
//                           }
//                           return null;
//                         },
//                         text: "date"),
//                   ],
//                 ),
//                 buttons: [
//                   DialogButton(
//                     onPressed: () async {
//                       if (datecontroller.text.trim() == "null" ||
//                           datecontroller.text.trim() == "") {
//                         showToast(
//                             message: "date must be not empty or null ",
//                             status: ToastStatus.Error);
//                         print(datecontroller.text);
//                       } else {
//                         Navigator.pop(context);

//                         await context
//                             .read<FactureController>()
//                             .getReportByDate(datecontroller.text)
//                             .then((value) {
//                           print(value.length.toString());
//                           _openReportByDateOrBetween(
//                               value, datecontroller.text.toString());
//                         });
//                       }
//                     },
//                     child: Text(
//                       "Ok",
//                       style: TextStyle(color: Colors.white, fontSize: 20),
//                     ),
//                   )
//                 ]).show();
//             break;
//           case 2:
//             startdatecontroller.clear();
//             enddatecontroller.clear();
//             Alert(
//                 context: context,
//                 title: "Enter Dates",
//                 content: Column(
//                   children: <Widget>[
//                     defaultTextFormField(
//                         readonly: true,
//                         controller: startdatecontroller,
//                         inputtype: TextInputType.datetime,
//                         prefixIcon: Icon(Icons.date_range),
//                         ontap: () {
//                           showDatePicker(
//                                   context: context,
//                                   initialDate: DateTime.now(),
//                                   firstDate: DateTime.parse('2022-01-01'),
//                                   lastDate: DateTime.parse('2040-01-01'))
//                               .then((value) {
//                             //Todo: handle date to string
//                             //print(DateFormat.yMMMd().format(value!));
//                             var tdate = value.toString().split(' ');
//                             startdatecontroller.text = tdate[0];
//                           });
//                         },
//                         onvalidate: (value) {
//                           if (value!.isEmpty) {
//                             return "start date must not be empty";
//                           }
//                           return null;
//                         },
//                         text: "start date"),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     defaultTextFormField(
//                         readonly: true,
//                         controller: enddatecontroller,
//                         inputtype: TextInputType.datetime,
//                         prefixIcon: Icon(Icons.date_range),
//                         ontap: () {
//                           showDatePicker(
//                                   context: context,
//                                   initialDate: DateTime.now(),
//                                   firstDate: DateTime.parse('2022-01-01'),
//                                   lastDate: DateTime.parse('2040-01-01'))
//                               .then((value) {
//                             //Todo: handle date to string
//                             //print(DateFormat.yMMMd().format(value!));
//                             var tdate = value.toString().split(' ');
//                             enddatecontroller.text = tdate[0];
//                           });
//                         },
//                         onvalidate: (value) {
//                           if (value!.isEmpty) {
//                             return "end date must not be empty";
//                           }
//                           return null;
//                         },
//                         text: "end date"),
//                   ],
//                 ),
//                 buttons: [
//                   DialogButton(
//                     onPressed: () async {
//                       //  print(datecontroller.text);
//                       if ((startdatecontroller.text.trim() == "null" ||
//                               startdatecontroller.text.trim() == "") ||
//                           (enddatecontroller.text.trim() == "null" ||
//                               enddatecontroller.text.trim() == "")) {
//                         showToast(
//                             message:
//                                 "start or enddate  must be not empty or null ",
//                             status: ToastStatus.Error);
//                       } else {
//                         Navigator.pop(context);

//                         await context
//                             .read<FactureController>()
//                             .getDetailsFacturesBetweenTwoDates(
//                                 startdatecontroller.text,
//                                 enddatecontroller.text)
//                             .then((value) {
//                           print(value.length.toString());
//                           _openReportByDateOrBetween(
//                               value, startdatecontroller.text.toString(),
//                               enddate: enddatecontroller.text);
//                         });
//                       }
//                     },
//                     child: Text(
//                       "Ok",
//                       style: TextStyle(color: Colors.white, fontSize: 20),
//                     ),
//                   )
//                 ]).show();
//             break;
//           case 3:
//             Alert(
//                 context: context,
//                 title: "Nb of Displayed Product",
//                 content: Column(
//                   children: <Widget>[
//                     TextField(
//                       controller: nbOfProductsController,
//                       keyboardType: TextInputType.phone,
//                       decoration: InputDecoration(
//                         labelText: 'nb of products ',
//                       ),
//                     ),
//                   ],
//                 ),
//                 buttons: [
//                   DialogButton(
//                     onPressed: () async {
//                       if (nbOfProductsController.text.trim() == "")
//                         showToast(
//                             message: "Nb of Displayed Product",
//                             status: ToastStatus.Error);
//                       else {
//                         Navigator.pop(context);

//                         int? nbofproduct =
//                             int.tryParse(nbOfProductsController.text);
//                         if (nbofproduct != null) {
//                           await context
//                               .read<FactureController>()
//                               .getBestSelling(
//                                   nbOfproduct: nbOfProductsController.text)
//                               .then((value) {
//                             _openBestSellingReport(value);
//                           });

//                           nbOfProductsController.clear();
//                         } else {
//                           showToast(
//                               message: "nb of products must be an integer",
//                               status: ToastStatus.Error);
//                         }
//                       }
//                     },
//                     child: Text(
//                       "Ok",
//                       style: TextStyle(color: Colors.white, fontSize: 20),
//                     ),
//                   )
//                 ]).show();

//             break;

//           case 4:
//             Alert(
//                 context: context,
//                 title: "Nb of Displayed Product",
//                 content: Column(
//                   children: <Widget>[
//                     TextField(
//                       controller: nbOfProductsController,
//                       keyboardType: TextInputType.phone,
//                       decoration: InputDecoration(
//                         labelText: 'nb of products ',
//                       ),
//                     ),
//                   ],
//                 ),
//                 buttons: [
//                   DialogButton(
//                     onPressed: () async {
//                       if (nbOfProductsController.text.trim() == "")
//                         showToast(
//                             message: "Nb of Displayed Product",
//                             status: ToastStatus.Error);
//                       else {
//                         int? nbofproduct =
//                             int.tryParse(nbOfProductsController.text);
//                         if (nbofproduct != null) {
//                           Navigator.pop(context);

//                           await context
//                               .read<FactureController>()
//                               .getMostprofitableList(
//                                   nbOfproduct: nbofproduct.toString())
//                               .then((value) async {
//                             await _openMostProfitableReport(value);
//                           });

//                           nbOfProductsController.clear();
//                         } else {
//                           showToast(
//                               message: "nb of products must be an integer",
//                               status: ToastStatus.Error);
//                         }
//                       }
//                     },
//                     child: Text(
//                       "Ok",
//                       style: TextStyle(color: Colors.white, fontSize: 20),
//                     ),
//                   )
//                 ]).show();

//             break;

//           case 5:
//             Alert(
//                 context: context,
//                 title: "Nb of Displayed Product",
//                 content: Column(
//                   children: <Widget>[
//                     TextField(
//                       controller: nbOfProductsController,
//                       keyboardType: TextInputType.phone,
//                       decoration: InputDecoration(
//                         labelText: 'nb of products ',
//                       ),
//                     ),
//                   ],
//                 ),
//                 buttons: [
//                   DialogButton(
//                     onPressed: () async {
//                       if (nbOfProductsController.text.trim() == "")
//                         showToast(
//                             message: "Nb of Displayed Product",
//                             status: ToastStatus.Error);
//                       else {
//                         int? nbofproduct =
//                             int.tryParse(nbOfProductsController.text);
//                         if (nbofproduct != null) {
//                           Navigator.pop(context);

//                           await context
//                               .read<FactureController>()
//                               .getLowQtyProductInStore(nbofproduct.toString())
//                               .then((value) async {
//                             await _openLowQtyReport(value);
//                           });

//                           nbOfProductsController.clear();
//                         } else {
//                           showToast(
//                               message: "nb of products must be an integer",
//                               status: ToastStatus.Error);
//                         }
//                       }
//                     },
//                     child: Text(
//                       "Ok",
//                       style: TextStyle(color: Colors.white, fontSize: 20),
//                     ),
//                   )
//                 ]).show();

//             break;

//           case 6:
//             await context
//                 .read<FactureController>()
//                 .getEarnSpentGoupeByItem()
//                 .then((value) => {
//                       value.forEach((element) async {
//                         print(element.toJson());
//                         await _openEarnSpenReport(value);
//                       })
//                     });
//             break;
//           case 7:
//           // showMonthPicker(
//           //   context: context,
//           //   firstDate: DateTime(DateTime.now().year - 1, 5),
//           //   lastDate: DateTime(DateTime.now().year + 1, 9),
//           //   initialDate: DateTime.now(),
//           //   locale: Locale("en"),
//           // ).then((date) {
//           //   if (date != null) {
//           //     print(date.toString());
//           //     print("--------");

//           //     //print(latestday_inCurrentMonth);

//           //     Get.to(DashBoardScreen(date));
//           //   }
//           // });
//           // break;
//           case 8:
//             var alertStyle =
//                 AlertStyle(animationDuration: Duration(milliseconds: 1));
//             Alert(
//               style: alertStyle,
//               context: context,
//               type: AlertType.warning,
//               title: "Delete Data",
//               desc: "Are You Sure You Want To Delete All Data'",
//               buttons: [
//                 DialogButton(
//                   child: Text(
//                     "Cancel",
//                     style: TextStyle(color: Colors.white, fontSize: 18),
//                   ),
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   color: Colors.blue.shade400,
//                 ),
//                 DialogButton(
//                   child: Text(
//                     "Delete",
//                     style: TextStyle(color: Colors.white, fontSize: 18),
//                   ),
//                   onPressed: () async {
//                     await context
//                         .read<ProductsController>()
//                         .cleanDatabase()
//                         .then((value) {
//                       showToast(
//                           message: "Data Deleted", status: ToastStatus.Success);
//                       Navigator.pop(context);
//                     });
//                   },
//                   color: Colors.red.shade400,
//                 ),
//               ],
//             ).show();

//             break;
//           case 9:
//             if (currentuser != null) {
//               var alertStyle =
//                   AlertStyle(animationDuration: Duration(milliseconds: 1));
//               Alert(
//                 style: alertStyle,
//                 context: context,
//                 type: AlertType.warning,
//                 title: "Reload Data",
//                 desc: "Are You Sure You Want To Reload All Data'",
//                 buttons: [
//                   DialogButton(
//                     child: Text(
//                       "Cancel",
//                       style: TextStyle(color: Colors.white, fontSize: 18),
//                     ),
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     color: Colors.blue.shade400,
//                   ),
//                   DialogButton(
//                     child: Text(
//                       "Delete",
//                       style: TextStyle(color: Colors.white, fontSize: 18),
//                     ),
//                     onPressed: () {
//                       deleteDatabase().then((value) {
//                         Restart.restartApp();
//                       });
//                     },
//                     color: Colors.red.shade400,
//                   ),
//                 ],
//               ).show();
//             } else {
//               showToast(
//                   message: "Please Sign In with google to Restore Data",
//                   status: ToastStatus.Warning,
//                   time: 3);
//             }
//         }
//       },
//       child: Container(
//         width: MediaQuery.of(context).size.width * 0.44,
//         height: MediaQuery.of(context).size.width * 0.44,
//         decoration: BoxDecoration(
//             gradient: currentuser == null && index == 9
//                 ? myDisabledGradient
//                 : myLinearGradient,
//             borderRadius: BorderRadius.circular(8)),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 60, color: Colors.white),
//             SizedBox(
//               height: 10,
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 title,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(color: Colors.white, fontSize: 20),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _openReportByDateOrBetween(
//       List<DetailsFactureModel> list, String startDate,
//       {String? enddate}) async {
//     final pdfFile = await PdfApi.generateReport(list,
//         startDate: startDate, endDate: enddate);
//     PdfApi.openFile(pdfFile);
//   }

//   Future<void> _openBestSellingReport(List<BestSellingVmodel> list) async {
//     final pdfFile = await PdfApi.generateBestSellingReport(list);
//     PdfApi.openFile(pdfFile);
//   }

//   Future<void> _openMostProfitableReport(List<ProfitableVModel> list) async {
//     final pdfFile = await PdfApi.generateMostProfitableReport(list);
//     PdfApi.openFile(pdfFile);
//   }

//   Future<void> _openEarnSpenReport(List<EarnSpentVmodel> list) async {
//     final pdfFile = await PdfApi.generateEarnSpentReport(list);
//     PdfApi.openFile(pdfFile);
//   }

//   Future<void> _openLowQtyReport(List<LowQtyVModel> list) async {
//     final pdfFile = await PdfApi.generateLowQtyReport(list);
//     PdfApi.openFile(pdfFile);
//   }

//   Future<void> deleteDatabase() => databaseFactory.deleteDatabase(databasepath);
// }
