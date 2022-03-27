import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketsystem/layout/market_controller.dart';
import 'package:marketsystem/shared/constant.dart';

class MarketLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MarketController>(
        init: Get.find<MarketController>(),
        builder: (controller) => Scaffold(
              appBar: AppBar(
                title: Text(
                  controller.appbar_title[controller.currentIndex].toString(),
                ),
                actions: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.search))
                ],
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
}
