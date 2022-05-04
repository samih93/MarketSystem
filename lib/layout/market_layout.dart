import 'package:flutter/material.dart';
import 'package:marketsystem/controllers/auth_controller.dart';
import 'package:marketsystem/controllers/layout_controller.dart';
import 'package:marketsystem/controllers/products_controller.dart';
import 'package:marketsystem/shared/components/default_text_form.dart';
import 'package:marketsystem/shared/constant.dart';
import 'package:marketsystem/shared/styles.dart';
import 'package:provider/provider.dart';

class MarketLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<LayoutController>(context);
    return Scaffold(
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
                  iconSize: 35,
                  icon: Icon(Icons.g_mobiledata_outlined),
                  onPressed: () {
                    context
                        .read<AuthController>()
                        .signInWithGoogle()
                        .then((value) {});
                  },
                ),
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
}
