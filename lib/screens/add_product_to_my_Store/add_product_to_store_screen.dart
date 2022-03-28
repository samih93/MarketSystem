import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:marketsystem/layout/market_controller.dart';
import 'package:marketsystem/models/product.dart';

class AddProductToMyStoreScreen extends StatelessWidget {
  var marketController = Get.find<MarketController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Product To Store"),
      ),
      body: TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
            autofocus: true,
            style: DefaultTextStyle.of(context)
                .style
                .copyWith(fontStyle: FontStyle.italic),
            decoration: InputDecoration(border: OutlineInputBorder())),
        suggestionsCallback: (pattern) async {
          return marketController.search_In_Store(pattern);
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text((suggestion as ProductModel).name.toString()),
            subtitle: Text('\$${(suggestion as ProductModel).name.toString()}'),
          );
        },
        onSuggestionSelected: (Object? suggestion) {},
        // onSuggestionSelected: (suggestion) {
        //   Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) => ProductPage(product: suggestion)
        //   ));
        // },
      ),
    );
  }
}
