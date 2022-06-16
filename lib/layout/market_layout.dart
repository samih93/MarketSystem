import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketsystem/controllers/auth_controller.dart';
import 'package:marketsystem/controllers/facture_controller.dart';
import 'package:marketsystem/controllers/layout_controller.dart';
import 'package:marketsystem/controllers/products_controller.dart';
import 'package:marketsystem/models/details_facture.dart';
import 'package:marketsystem/models/viewmodel/best_selling.dart';
import 'package:marketsystem/models/viewmodel/earn_spent_vmodel.dart';
import 'package:marketsystem/models/viewmodel/low_qty_model.dart';
import 'package:marketsystem/models/viewmodel/profitable_vmodel.dart';
import 'package:marketsystem/screens/dashboard/dashboard_screen.dart';
import 'package:marketsystem/screens/printer_settings/printer_settings_screen.dart';
import 'package:marketsystem/screens/receipts_screen/receipts_screen.dart';
import 'package:marketsystem/services/api/pdf_api.dart';
import 'package:marketsystem/shared/components/default_text_form.dart';
import 'package:marketsystem/shared/constant.dart';
import 'package:marketsystem/shared/styles.dart';
import 'package:marketsystem/shared/toast_message.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
//import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sqflite/sqflite.dart';

class MarketLayout extends StatelessWidget {
  final List<String> _report_title = [
    "Receipts",
    "Daily Sales",
    "Sales Between Two Dates",
    "Best Selling",
    "Most profitable Products",
    "Low Qty In Store",
    "Spent / Earn by Item",
    "Overview",
    "Delete Data",
    "Printer",
    "Backup",
    "Restore",
    "Pos System",
    "Rate us",
    "Support",
    "Share"
  ];

  final List<IconData> _report_icons = [
    Icons.receipt,
    Icons.report,
    Icons.report,
    Icons.loyalty_sharp,
    Icons.turn_sharp_right_outlined,
    Icons.warning_amber_rounded,
    Icons.currency_exchange_outlined,
    Icons.bar_chart_outlined,
    Icons.delete_forever_outlined,
    Icons.print,
    Icons.backup_outlined,
    Icons.settings_backup_restore_sharp,
    Icons.info_outline,
    Icons.star,
    Icons.email,
    Icons.share
  ];

  final List<Color> _icon_colors = [
    //Reports
    Colors.grey,
    Colors.orange.shade500,
    Colors.orange.shade500,
    Colors.green,
    Colors.purple,
    Colors.red,
    Colors.grey,
    Colors.purple.shade500,
    Colors.red.shade500,
    Colors.grey,

    //Cloud
    Colors.grey,
    Colors.grey,
    // About
    Colors.grey,
    Colors.grey,
    Colors.grey,
    Colors.grey,
  ];

  var datecontroller = TextEditingController();
  var startdatecontroller = TextEditingController();
  var enddatecontroller = TextEditingController();
  var nbOfProductsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<LayoutController>(context);
    return Scaffold(
      drawer: Consumer<AuthController>(builder: (context, controller, child) {
        return _myDrawer(controller, context);
      }),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: myLinearGradient,
          ),
        ),
        title: controller.issearchingInProducts
            ? _buildSearchField(
                context,
                'search in products...',
              )
            : Text(
                controller.appbar_title[controller.currentIndex].toString(),
              ),
        actions: controller.issearchingInProducts == false
            ? [
                IconButton(
                    onPressed: () {
                      controller.onChangeSearchInProductsStatus(true);
                    },
                    icon: Icon(Icons.search)),
              ]
            : [],
      ),
      body: controller.screens[controller.currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 30,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: defaultColor,
        onTap: (index) {
          print(index);

          controller.onchangeIndex(index);
        },
        currentIndex: controller.currentIndex,
        items: controller.bottomItems,
      ),
    );
  }

  _buildSearchField(
    BuildContext context,
    String hint,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: defaultTextFormField(
          //NOTE to open keyboard when pressing on search button
          focus: true,
          onchange: (value) {
            if (value!.length > 1) {
              context.read<ProductsController>().search_In_Products(value);
              //c.search_In_Products(value);
            }
          },
          inputtype: TextInputType.name,
          hinttext: hint,
          border: InputBorder.none,
          cursorColor: Colors.white,
          textColor: Colors.white,
          hintcolor: Colors.white54,
          suffixIcon: IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () {
              context.read<ProductsController>().clearSearch();
              context
                  .read<LayoutController>()
                  .onChangeSearchInProductsStatus(false);
            },
          )),
    );
  }

  _myDrawer(AuthController _controller, BuildContext context) {
    String? _userImage = currentuser != null ? currentuser?.photoURL : null;

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(gradient: myLinearGradient),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: _userImage != null
                                ? NetworkImage("$_userImage")
                                : AssetImage(
                                    "assets/images/default_image.png",
                                  ) as ImageProvider,
                            fit: BoxFit.fill),
                        //whatever image you can put here
                      ),
                    ),
                    currentuser == null
                        ? Icon(
                            Icons.cloud_off,
                            color: Colors.grey.shade600,
                            size: 35,
                          )
                        : Icon(
                            Icons.cloud_outlined,
                            color: Colors.green.shade800,
                            size: 35,
                          ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    if (currentuser == null) {
                      await _controller.signInWithGoogle().then((value) {
                        showToast(
                            message: _controller.statusLoginMessage,
                            status: _controller.toastLoginStatus);
                      });
                    }
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _controller.getDrawerTitle().toString(),
                              style: TextStyle(
                                  color: Colors.white, letterSpacing: 2),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              _controller.getDrawerSubTitle().toString(),
                              style: TextStyle(color: Colors.white60),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      if (_controller.isloadingLogin)
                        CircularProgressIndicator(
                          color: Colors.white,
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _listtileTitle("Reports", context),
                ..._report_title.map(
                  (element) => Column(
                    children: [
                      if (_report_title.indexOf(element) == 10)
                        _listtileTitle("Cloud", context),
                      if (_report_title.indexOf(element) == 12)
                        _listtileTitle("About", context),
                      ListTile(
                          title: Text(
                            element,
                            style: TextStyle(
                                color: (_report_title.indexOf(element) == 10 ||
                                            _report_title.indexOf(element) ==
                                                11) &&
                                        currentuser == null
                                    ? Colors.grey
                                    : (_report_title.indexOf(element) == 10 ||
                                                _report_title
                                                        .indexOf(element) ==
                                                    11) &&
                                            currentuser != null
                                        ? Colors.green.shade400
                                        : Colors.black),
                          ),
                          leading: Icon(
                              _report_icons[_report_title.indexOf(element)],
                              color:
                                  _icon_colors[_report_title.indexOf(element)]),
                          onTap: () async {
                            switch (_report_title.indexOf(element)) {
                              case 0:
                                showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.parse('2022-01-01'),
                                        lastDate: DateTime.parse('2040-01-01'))
                                    .then((value) {
                                  //Todo: handle date to string
                                  //print(DateFormat.yMMMd().format(value!));
                                  var tdate = value != null
                                      ? value.toString().split(' ')
                                      : null;

                                  if (tdate == null) {
                                    showToast(
                                        message:
                                            "date must be not empty or null ",
                                        status: ToastStatus.Error);
                                    //  print(datecontroller.text);
                                  } else {
                                    Get.to(() =>
                                        ReceiptsScreen(tdate[0].toString()));
                                  }
                                  //datecontroller.text = tdate[0];
                                });
                                break;
                              case 1:
                                datecontroller.clear();
                                showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.parse('2022-01-01'),
                                        lastDate: DateTime.parse('2040-01-01'))
                                    .then((value) async {
                                  //Todo: handle date to string
                                  //print(DateFormat.yMMMd().format(value!));
                                  var tdate = value != null
                                      ? value.toString().split(' ')[0]
                                      : null;
                                  if (tdate == null) {
                                    showToast(
                                        message:
                                            "date must be not empty or null ",
                                        status: ToastStatus.Error);
                                    //  print(datecontroller.text);
                                  } else {
                                    Navigator.pop(context);

                                    await context
                                        .read<FactureController>()
                                        .getReportByDate(tdate.toString())
                                        .then((value) {
                                      print(value.length.toString());
                                      _openReportByDateOrBetween(
                                          value, tdate.toString());
                                    });
                                  }
                                });

                                break;
                              case 2:
                                startdatecontroller.clear();
                                enddatecontroller.clear();
                                Alert(
                                    context: context,
                                    title: "Enter Dates",
                                    content: Column(
                                      children: <Widget>[
                                        defaultTextFormField(
                                            readonly: true,
                                            controller: startdatecontroller,
                                            inputtype: TextInputType.datetime,
                                            prefixIcon: Icon(Icons.date_range),
                                            ontap: () {
                                              showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime.parse(
                                                          '2022-01-01'),
                                                      lastDate: DateTime.parse(
                                                          '2040-01-01'))
                                                  .then((value) {
                                                //Todo: handle date to string
                                                //print(DateFormat.yMMMd().format(value!));
                                                var tdate =
                                                    value.toString().split(' ');
                                                startdatecontroller.text =
                                                    tdate[0];
                                              });
                                            },
                                            onvalidate: (value) {
                                              if (value!.isEmpty) {
                                                return "start date must not be empty";
                                              }
                                              return null;
                                            },
                                            text: "start date"),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        defaultTextFormField(
                                            readonly: true,
                                            controller: enddatecontroller,
                                            inputtype: TextInputType.datetime,
                                            prefixIcon: Icon(Icons.date_range),
                                            ontap: () {
                                              showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime.parse(
                                                          '2022-01-01'),
                                                      lastDate: DateTime.parse(
                                                          '2040-01-01'))
                                                  .then((value) {
                                                //Todo: handle date to string
                                                //print(DateFormat.yMMMd().format(value!));
                                                var tdate =
                                                    value.toString().split(' ');
                                                enddatecontroller.text =
                                                    tdate[0];
                                              });
                                            },
                                            onvalidate: (value) {
                                              if (value!.isEmpty) {
                                                return "end date must not be empty";
                                              }
                                              return null;
                                            },
                                            text: "end date"),
                                      ],
                                    ),
                                    buttons: [
                                      DialogButton(
                                        onPressed: () async {
                                          //  print(datecontroller.text);
                                          if ((startdatecontroller.text
                                                          .trim() ==
                                                      "null" ||
                                                  startdatecontroller.text
                                                          .trim() ==
                                                      "") ||
                                              (enddatecontroller.text.trim() ==
                                                      "null" ||
                                                  enddatecontroller.text
                                                          .trim() ==
                                                      "")) {
                                            showToast(
                                                message:
                                                    "start or enddate  must be not empty or null ",
                                                status: ToastStatus.Error);
                                          } else {
                                            Navigator.pop(context);

                                            await context
                                                .read<FactureController>()
                                                .getDetailsFacturesBetweenTwoDates(
                                                    startdatecontroller.text,
                                                    enddatecontroller.text)
                                                .then((value) {
                                              print(value.length.toString());
                                              _openReportByDateOrBetween(
                                                  value,
                                                  startdatecontroller.text
                                                      .toString(),
                                                  enddate:
                                                      enddatecontroller.text);
                                            });
                                          }
                                        },
                                        child: Text(
                                          "Ok",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      )
                                    ]).show();
                                break;
                              case 3:
                                Alert(
                                    context: context,
                                    title: "Nb of Displayed Product",
                                    content: Column(
                                      children: <Widget>[
                                        TextField(
                                          controller: nbOfProductsController,
                                          keyboardType: TextInputType.phone,
                                          decoration: InputDecoration(
                                            labelText: 'nb of products ',
                                          ),
                                        ),
                                      ],
                                    ),
                                    buttons: [
                                      DialogButton(
                                        onPressed: () async {
                                          if (nbOfProductsController.text
                                                  .trim() ==
                                              "")
                                            showToast(
                                                message:
                                                    "Nb of Displayed Product",
                                                status: ToastStatus.Error);
                                          else {
                                            Navigator.pop(context);

                                            int? nbofproduct = int.tryParse(
                                                nbOfProductsController.text);
                                            if (nbofproduct != null) {
                                              await context
                                                  .read<FactureController>()
                                                  .getBestSelling(
                                                      nbOfproduct:
                                                          nbOfProductsController
                                                              .text)
                                                  .then((value) {
                                                _openBestSellingReport(value);
                                              });

                                              nbOfProductsController.clear();
                                            } else {
                                              showToast(
                                                  message:
                                                      "nb of products must be an integer",
                                                  status: ToastStatus.Error);
                                            }
                                          }
                                        },
                                        child: Text(
                                          "Ok",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      )
                                    ]).show();

                                break;

                              case 4:
                                Alert(
                                    context: context,
                                    title: "Nb of Displayed Product",
                                    content: Column(
                                      children: <Widget>[
                                        TextField(
                                          controller: nbOfProductsController,
                                          keyboardType: TextInputType.phone,
                                          decoration: InputDecoration(
                                            labelText: 'nb of products ',
                                          ),
                                        ),
                                      ],
                                    ),
                                    buttons: [
                                      DialogButton(
                                        onPressed: () async {
                                          if (nbOfProductsController.text
                                                  .trim() ==
                                              "")
                                            showToast(
                                                message:
                                                    "Nb of Displayed Product",
                                                status: ToastStatus.Error);
                                          else {
                                            int? nbofproduct = int.tryParse(
                                                nbOfProductsController.text);
                                            if (nbofproduct != null) {
                                              Navigator.pop(context);

                                              await context
                                                  .read<FactureController>()
                                                  .getMostprofitableList(
                                                      nbOfproduct: nbofproduct
                                                          .toString())
                                                  .then((value) async {
                                                await _openMostProfitableReport(
                                                    value);
                                              });

                                              nbOfProductsController.clear();
                                            } else {
                                              showToast(
                                                  message:
                                                      "nb of products must be an integer",
                                                  status: ToastStatus.Error);
                                            }
                                          }
                                        },
                                        child: Text(
                                          "Ok",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      )
                                    ]).show();

                                break;

                              case 5:
                                Alert(
                                    context: context,
                                    title: "Nb of Displayed Product",
                                    content: Column(
                                      children: <Widget>[
                                        TextField(
                                          controller: nbOfProductsController,
                                          keyboardType: TextInputType.phone,
                                          decoration: InputDecoration(
                                            labelText: 'nb of products ',
                                          ),
                                        ),
                                      ],
                                    ),
                                    buttons: [
                                      DialogButton(
                                        onPressed: () async {
                                          if (nbOfProductsController.text
                                                  .trim() ==
                                              "")
                                            showToast(
                                                message:
                                                    "Nb of Displayed Product",
                                                status: ToastStatus.Error);
                                          else {
                                            int? nbofproduct = int.tryParse(
                                                nbOfProductsController.text);
                                            if (nbofproduct != null) {
                                              Navigator.pop(context);

                                              await context
                                                  .read<FactureController>()
                                                  .getLowQtyProductInStore(
                                                      nbofproduct.toString())
                                                  .then((value) async {
                                                await _openLowQtyReport(value);
                                              });

                                              nbOfProductsController.clear();
                                            } else {
                                              showToast(
                                                  message:
                                                      "nb of products must be an integer",
                                                  status: ToastStatus.Error);
                                            }
                                          }
                                        },
                                        child: Text(
                                          "Ok",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      )
                                    ]).show();

                                break;

                              case 6:
                                await context
                                    .read<FactureController>()
                                    .getEarnSpentGoupeByItem()
                                    .then((value) => {
                                          value.forEach((element) async {
                                            print(element.toJson());
                                            await _openEarnSpenReport(value);
                                          })
                                        });
                                break;
                              case 7:
                                showMonthPicker(
                                  context: context,
                                  firstDate:
                                      DateTime(DateTime.now().year - 1, 5),
                                  lastDate:
                                      DateTime(DateTime.now().year + 1, 9),
                                  initialDate: DateTime.now(),
                                  locale: Locale("en"),
                                ).then((date) {
                                  if (date != null) {
                                    print(date.toString());
                                    print("--------");

                                    //print(latestday_inCurrentMonth);

                                    Get.to(DashBoardScreen(date));
                                  }
                                });
                                break;
                              case 8:
                                var alertStyle = AlertStyle(
                                    animationDuration:
                                        Duration(milliseconds: 1));
                                Alert(
                                  style: alertStyle,
                                  context: context,
                                  type: AlertType.warning,
                                  title: "Delete Data",
                                  desc:
                                      "Are You Sure You Want To Delete All Data",
                                  buttons: [
                                    DialogButton(
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      color: Colors.blue.shade400,
                                    ),
                                    DialogButton(
                                      child: Text(
                                        "Delete",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                      onPressed: () async {
                                        await context
                                            .read<ProductsController>()
                                            .cleanDatabase()
                                            .then((value) {
                                          showToast(
                                              message: "Data Deleted",
                                              status: ToastStatus.Success);
                                          Navigator.pop(context);
                                        });
                                      },
                                      color: Colors.red.shade400,
                                    ),
                                  ],
                                ).show();

                                break;

                              case 9:
                                Get.to(PrinterSettingScreen());
                                break;

                              case 10:
                                if (currentuser == null)
                                  showToast(
                                      message: "Sign in to backup your Data",
                                      status: ToastStatus.Warning);
                                break;
                              case 11:
                                if (currentuser != null) {
                                  var alertStyle = AlertStyle(
                                      animationDuration:
                                          Duration(milliseconds: 1));
                                  // _controller
                                  //     .listGoogleDriveFiles()
                                  //     .then((value) {});

                                  // Alert(
                                  //   style: alertStyle,
                                  //   context: context,
                                  //   type: AlertType.warning,
                                  //   title: "Restore Data",
                                  //   desc:
                                  //       "Are You Sure You Want To Restore cloud Data",
                                  //   buttons: [
                                  //     DialogButton(
                                  //       child: Text(
                                  //         "Cancel",
                                  //         style: TextStyle(
                                  //             color: Colors.white,
                                  //             fontSize: 18),
                                  //       ),
                                  //       onPressed: () {
                                  //         Navigator.pop(context);
                                  //       },
                                  //       color: Colors.blue.shade400,
                                  //     ),
                                  //     DialogButton(
                                  //       child: Text(
                                  //         "Delete",
                                  //         style: TextStyle(
                                  //             color: Colors.white,
                                  //             fontSize: 18),
                                  //       ),
                                  //       onPressed: () {
                                  //         deleteDatabase().then((value) {
                                  //           Restart.restartApp();
                                  //         });
                                  //       },
                                  //       color: Colors.red.shade400,
                                  //     ),
                                  //   ],
                                  // ).show();
                                } else {
                                  showToast(
                                      message: "Sign in to Restore Your Data",
                                      status: ToastStatus.Warning,
                                      time: 3);
                                }
                            }
                          }),
                      if (_report_title.indexOf(element) == 9) Divider(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (currentuser != null)
            _controller.isloadingSignOut
                ? Center(child: CircularProgressIndicator())
                : ListTile(
                    tileColor: Colors.red.shade300,
                    title: Center(
                      child: Text(
                        "SIGN OUT",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // leading: Icon(
                    //   Icons.power_settings_new_outlined,
                    //   color: Colors.red,
                    // ),
                    onTap: () async {
                      var alertStyle = AlertStyle(
                          animationDuration: Duration(milliseconds: 1));
                      Alert(
                        style: alertStyle,
                        context: context,
                        type: AlertType.error,
                        title: "Log out",
                        desc: "Are you sure you want to exit",
                        buttons: [
                          DialogButton(
                            child: Text(
                              "Cancel",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            color: Colors.blue.shade400,
                          ),
                          DialogButton(
                            child: Text(
                              "confrim",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            onPressed: () async {
                              await _controller.google_signOut();
                              Navigator.pop(context);
                            },
                            color: Colors.red.shade400,
                          ),
                        ],
                      ).show();
                    },
                  )
        ],
      ),
    );
  }

  Future<void> _openReportByDateOrBetween(
      List<DetailsFactureModel> list, String startDate,
      {String? enddate}) async {
    final pdfFile = await PdfApi.generateReport(list,
        startDate: startDate, endDate: enddate);
    PdfApi.openFile(pdfFile);
  }

  Future<void> _openBestSellingReport(List<BestSellingVmodel> list) async {
    final pdfFile = await PdfApi.generateBestSellingReport(list);
    PdfApi.openFile(pdfFile);
  }

  Future<void> _openMostProfitableReport(List<ProfitableVModel> list) async {
    final pdfFile = await PdfApi.generateMostProfitableReport(list);
    PdfApi.openFile(pdfFile);
  }

  Future<void> _openEarnSpenReport(List<EarnSpentVmodel> list) async {
    final pdfFile = await PdfApi.generateEarnSpentReport(list);
    PdfApi.openFile(pdfFile);
  }

  Future<void> _openLowQtyReport(List<LowQtyVModel> list) async {
    final pdfFile = await PdfApi.generateLowQtyReport(list);
    PdfApi.openFile(pdfFile);
  }

  Future<void> deleteDatabase() => databaseFactory.deleteDatabase(databasepath);

  _listtileTitle(String title, BuildContext context) => Row(
        children: [
          SizedBox(
            width: 16,
          ),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(color: defaultColor, fontWeight: FontWeight.bold),
          ),
        ],
      );
}
