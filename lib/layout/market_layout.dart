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
    var authController = Provider.of<AuthController>(context);
    print(authController.user);
    return Scaffold(
      drawer: _myDrawer(context),
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

  _myDrawer(BuildContext context) {
    AuthController _controller = Provider.of<AuthController>(context);
    String? _userImage = _controller.user?.user?.photoURL ?? null;
    return Drawer(
      child: Container(
        // decoration: BoxDecoration(),
        child: ListView(
          children: [
            DrawerHeader(
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
                      _controller.user == null
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
                    onTap: () {
                      if (_controller.user == null) {
                        _controller.signInWithGoogle().then((value) {
                          print(value.user!.displayName.toString());
                        });
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _controller.getDrawerTitle().toString(),
                          style:
                              TextStyle(color: Colors.white, letterSpacing: 2),
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
                  )
                ],
              ),
            ),
            ListTile(
              title: Text("Home"),
              leading: IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              onTap: () {},
            ),
            Divider(
              color: Colors.grey,
            ),
            ListTile(
              title: Text("Profile"),
              leading: Icon(Icons.account_circle),
              onTap: () {},
            ),
            Divider(
              color: Colors.grey,
            ),
            ListTile(
              title: Text("Contact"),
              leading: Icon(Icons.contact_page),
              onTap: () {},
            ),
            Divider(
              color: Colors.grey,
            ),
            if (_controller.user != null)
              ListTile(
                title: Text("SIGN OUT"),
                leading: Icon(
                  Icons.power_settings_new_outlined,
                  color: Colors.red,
                ),
                onTap: () async {
                  await _controller.google_signOut();
                },
              )
          ],
        ),
      ),
    );
  }
}
