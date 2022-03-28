import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketsystem/layout/market_controller.dart';
import 'package:marketsystem/shared/components/default_text_form.dart';
import 'package:marketsystem/shared/constant.dart';

class MarketLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MarketController>(
        init: Get.find<MarketController>(),
        builder: (controller) => Scaffold(
              appBar: AppBar(
                title: controller.issearchingInProducts
                    ? _buildSearchField(controller, 'search in products...',
                        isforproduct: true)
                    : controller.issearchingInStore
                        ? _buildSearchField(controller, "search in store...")
                        : Text(
                            controller.appbar_title[controller.currentIndex]
                                .toString(),
                          ),
                actions: controller.issearchingInProducts == false ||
                        controller.issearchingInStore
                    ? [
                        IconButton(
                            onPressed: () {
                              // NOTE check to search in store all time expect current index 0
                              if (controller.currentIndex == 0) {
                                controller.onChangeSearchInProductsStatus(true);
                              } else {
                                controller.onChangeSearchInStoreStatus(true);
                              }
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
                  //NOTE : if index equal 2 open NewPostScreen without change index

                  controller.onchangeIndex(index);
                },
                currentIndex: controller.currentIndex,
                items: controller.bottomItems,
              ),
            ));
  }

  _buildSearchField(MarketController c, String hint,
      {bool isforproduct = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: defaultTextFormField(
          //NOTE to open keyboard when pressing on search button
          focus: true,
          onchange: (value) {
            if (value!.length > 1) {
              if (isforproduct) {
                c.search_In_Products(value);
              } else {
                c.search_In_Store(value);
              }
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
              c.clearSearch();
            },
          )),
    );
  }
}
