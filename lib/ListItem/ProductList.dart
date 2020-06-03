import 'package:flutter/material.dart';
import 'package:haftaa/product/base-product.dart';

import 'package:haftaa/product/product-controller.dart';

class ProductList extends StatefulWidget {
  ProductController productController = ProductController();
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: null,
      builder:
          (BuildContext context, AsyncSnapshot<List<BaseProduct>> snapshot) {
        //print(snapshot.connectionState);
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          // TODO: Handle this case.
            break;
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
            // TODO: Handle this case.
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Text('Error');
            } else {
              List<BaseProduct> products = snapshot.data;
              print(products.length);
              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, position) {
                  return Row(
                    children: <Widget>[
                      // Text(products[position].title),
                      // Text(products[position].description)
                    ],
                  );
                },
              );
            }
            break;
        }
      },
    );
  }
}
