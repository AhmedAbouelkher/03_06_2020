import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:haftaa/ui/pages/request-product-details.dart';
import 'package:haftaa/ui/widgets/product/small-product.listItem.dart';
import 'package:haftaa/product/base-product.dart';
import 'package:haftaa/product/product-controller.dart';
import 'package:haftaa/search/search.dart';

class ProductGridHorizontal extends StatefulWidget {
  BaseProduct expectedProduct;
  ProductSearchModel searchModel = ProductSearchModel();
  bool hideWidgetWhenEmpty = false;
  ProductGridHorizontal(
      {this.searchModel, this.expectedProduct, this.hideWidgetWhenEmpty});

  @override
  _ProductGridHorizontalState createState() => _ProductGridHorizontalState();
}

class _ProductGridHorizontalState extends State<ProductGridHorizontal> {
  Future<List<BaseProduct>> _productsFuture;
  ProductController productController = ProductController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _productsFuture = productController.loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _productsFuture,
      builder: (context, AsyncSnapshot<List<BaseProduct>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
            break;
          default:
            if (snapshot.hasError)
              return new Center(
                child: Text('Error: ${snapshot.error}'),
              );
            else if (!snapshot.hasData || snapshot.data.length == 0) {
              return widget.hideWidgetWhenEmpty
                  ? Container()
                  : Center(
                child: Text('لا يوجد منتجات مشابهه'),
              );
            } else {
              if (snapshot.data.length == 1 &&
                  widget.expectedProduct != null &&
                  snapshot.data[0].id == widget.expectedProduct.id) {
                return widget.hideWidgetWhenEmpty
                    ? Container()
                    : Center(
                  child: Text('لا يوجد منتجات مشابهه'),
                );
              } else {
                return getListWidget(context, snapshot.data);
              }
            }
        }
      },
    );
  }

  Widget getListWidget(BuildContext context, List<BaseProduct> prodList) {
    return

      /// Variable Component UI use in bottom layout "Top Rated Products"
      Padding(
          padding: const EdgeInsets.only(
              left: 15.0, right: 20.0, top: 30.0, bottom: 20.0),
          child: Container(
            height: 280.0,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "عناصر مشابهه",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: "Gotik",
                          fontSize: 15.0),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        "عرض الكل",
                        style: TextStyle(
                            color: Colors.indigoAccent.withOpacity(0.8),
                            fontFamily: "Gotik",
                            fontWeight: FontWeight.w700),
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: productListView(context, prodList),
                )
              ],
            ),
          ));
  }

  Widget productListView(BuildContext context, List<BaseProduct> prodList) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 20.0, bottom: 2.0),
      scrollDirection: Axis.horizontal,
      itemCount: prodList.length,
      itemBuilder: (BuildContext context, int index) {
        if (widget.expectedProduct != null) {
          if (widget.expectedProduct.id != prodList[index].id) {
            return SmallProductListitem(prodList[index]);
          } else {
            return Container();
          }
        } else {
          return SmallProductListitem(prodList[index]);
        }
      },
    );
  }
}
