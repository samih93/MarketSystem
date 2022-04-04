import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketsystem/controllers/layout_controller.dart';
import 'package:marketsystem/layout/market_controller.dart';
import 'package:marketsystem/shared/components/default_text_form.dart';
import 'package:marketsystem/shared/constant.dart';
import 'package:provider/provider.dart';

class MarketLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LayoutController>(builder: (context, controller, child) {
      return Scaffold(
        appBar: AppBar(
          title: controller.issearchingInProducts
              ? _buildSearchField(
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
                      icon: Icon(Icons.search))
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
    });
  }

  _buildSearchField(
    String hint,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: defaultTextFormField(
          //NOTE to open keyboard when pressing on search button
          focus: true,
          onchange: (value) {
            if (value!.length > 1) {
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
              //  c.clearSearch();
            },
          )),
    );
  }
}
