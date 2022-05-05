import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:marketsystem/controllers/auth_controller.dart';
import 'package:marketsystem/controllers/facture_controller.dart';
import 'package:marketsystem/controllers/layout_controller.dart';
import 'package:marketsystem/controllers/products_controller.dart';
import 'package:marketsystem/models/details_facture.dart';
import 'package:marketsystem/models/user.dart';
import 'package:marketsystem/models/viewmodel/best_selling.dart';
import 'package:marketsystem/models/viewmodel/earn_spent_vmodel.dart';
import 'package:marketsystem/models/viewmodel/low_qty_model.dart';
import 'package:marketsystem/models/viewmodel/profitable_vmodel.dart';
import 'package:marketsystem/screens/dashboard/dashboard_screen.dart';
import 'package:marketsystem/screens/receipts_screen/receipts_screen.dart';
import 'package:marketsystem/services/api/pdf_api.dart';
import 'package:marketsystem/shared/components/default_text_form.dart';
import 'package:marketsystem/shared/constant.dart';
import 'package:marketsystem/shared/local/cash_helper.dart';
import 'package:marketsystem/shared/styles.dart';
import 'package:marketsystem/shared/toast_message.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sqflite/sqflite.dart';

class MarketLayout extends StatelessWidget {
  final List<String> _report_title = [
    "Push current Data",
    "Delete Data",
    "Reload cloud Data"
  ];

  final List<IconData> _report_icons = [
    Icons.publish_sharp,
    Icons.delete_forever_outlined,
    Icons.replay
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
    String? _userImage =
        _controller.userModel != null ? _controller.userModel?.photoURL : null;

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
                    _controller.userModel == null
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
                    if (_controller.userModel == null) {
                      await _controller.signInWithGoogle().then((value) {
                        showToast(
                            message: _controller.statusLoginMessage,
                            status: _controller.toastStatus);
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
                ..._report_title.map(
                  (element) => Column(
                    children: [
                      ListTile(
                          title: Text(
                            element,
                            style: TextStyle(
                                color: _report_title.indexOf(element) == 9 &&
                                        _controller.userModel == null
                                    ? Colors.grey
                                    : Colors.black),
                          ),
                          leading: Icon(
                              _report_icons[_report_title.indexOf(element)]),
                          onTap: () async {
                            switch (_report_title.indexOf(element)) {
                              case 0:
                                showToast(
                                    message: "Sign in to push your Data",
                                    status: ToastStatus.Warning);
                                break;

                              case 1:
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
                              case 2:
                                if (_controller.userModel != null) {
                                  var alertStyle = AlertStyle(
                                      animationDuration:
                                          Duration(milliseconds: 1));
                                  Alert(
                                    style: alertStyle,
                                    context: context,
                                    type: AlertType.warning,
                                    title: "Reload Data",
                                    desc:
                                        "Are You Sure You Want To Reload cloud Data",
                                    buttons: [
                                      DialogButton(
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
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
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                        onPressed: () {
                                          deleteDatabase().then((value) {
                                            Restart.restartApp();
                                          });
                                        },
                                        color: Colors.red.shade400,
                                      ),
                                    ],
                                  ).show();
                                } else {
                                  showToast(
                                      message: "Please Sign In to Reload Data",
                                      status: ToastStatus.Warning,
                                      time: 3);
                                }
                            }
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_controller.userModel != null)
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListTile(
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
                  await _controller.google_signOut();
                },
              ),
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
}
