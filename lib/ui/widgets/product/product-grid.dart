import 'dart:async';
import 'package:flutter/material.dart';
import 'package:haftaa/product/auction-product.dart';
import 'package:haftaa/product/base-product.dart';
import 'package:haftaa/product/product-provider.dart';
import 'package:haftaa/product/request-product.dart';
import 'package:haftaa/product/sale-product.dart';

import 'package:haftaa/provider/provider.dart';
import 'package:haftaa/ui/widgets/loading.dart';
import 'package:haftaa/ui/widgets/product/auction-product-itemGrid.dart';
import 'package:haftaa/ui/widgets/product/sale-product-itemGrid.dart';
import 'package:haftaa/ui/widgets/product/request-product-itemGrid.dart';
import 'package:haftaa/product/product-controller.dart';
import 'package:haftaa/search/search.dart';
import 'package:provider/provider.dart';

class ProductGrid extends StatefulWidget {
  ProductGrid();

  Stream productStream;
  ProductSearchModel _searchModel = ProductSearchModel();
  ProductController _productController;

  ProductGrid.search(this._searchModel) {
    _productController =
        ProductController.getParameters(searchModel: this._searchModel);
  }

  @override
  _ProductGridState createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  //Stream productStream;

  _ProductGridState();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<List<BaseProduct>> _productsFuture;

  //ProductController productController = new ProductController();

  Widget productListWidget(List<BaseProduct> productList) {
    return GridView.count(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 17.0,
        childAspectRatio: 0.545,
        crossAxisCount: 2,
        primary: false,
        children: List.generate(productList.length, (index) {
          // return ProductItemGrid(productList[index]);
          if (productList[index] is SaleProduct) {
            return SaleProductItemGrid(productList[index]);
          } else if (productList[index] is AuctionProduct) {
            return AuctionProductItemGrid(productList[index]);
          } else if (productList[index] is RequestProduct) {
            return RequestProductItemGrid(productList[index]);
          }
          // else if (productList[index] is BaseProduct) {
          //   return ProductItemGrid(productList[index]);
          // }
        }));
  }

  @override
  void initState() {
    // _productsFuture = productController.loadProducts();
    //productStream = widget.productStream;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // listScrollController.removeListener(_scrollListener);
  }

  BaseProduct lastProduct;

  @override
  Widget build(BuildContext context) {
    var productList = Provider.of<ProductProvider>(context).productList;
    return

        ///  Grid item in bottom of Category
        SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Padding(
            //   padding: const EdgeInsets.only(left: 20.0, top: 20.0),
            //   child: TextFormField(
            //     initialValue: widget._searchModel == null
            //         ? ''
            //         : widget._searchModel.Title == null
            //             ? ''
            //             : widget._searchModel.Title,
            //     textDirection: TextDirection.rtl,
            //     onFieldSubmitted: (value) {
            //       ProductSearchModel searchParams =
            //           ProductSearchModel.FromSearchParams(productTitle: value);

            //       Navigator.of(context).pushAndRemoveUntil(
            //           MaterialPageRoute(
            //               builder: (context) =>
            //                   Menu.fromSearchParams(searchParams)),
            //           (Route<dynamic> route) => false);

            //       // Navigator.of(context).push(PageRouteBuilder(
            //       //     pageBuilder: (_, __, ___) =>
            //       //         new Menu.fromSearchParams(searchParams),
            //       //     transitionDuration: Duration(milliseconds: 900),

            //       //     /// Set animation Opacity in route to detailProduk layout
            //       //     transitionsBuilder:
            //       //         (_, Animation<double> animation, __, Widget child) {
            //       //       return Opacity(
            //       //         opacity: animation.value,
            //       //         child: child,
            //       //       );
            //       //     }));
            //     },
            //     decoration: InputDecoration(
            //         border: InputBorder.none,
            //         icon: Icon(
            //           Icons.search,
            //           color: Colors.black38,
            //           size: 18.0,
            //         ),
            //         hintText: "بحث في المنتجات",
            //         hintStyle:
            //             TextStyle(color: Colors.black38, fontSize: 14.0)),
            //   ),
            // ),

            //lastProduct = snapshot.data.last;

            GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              primary: false,
              itemCount: productList.length,
              itemBuilder: (context, index) {
                if (productList[index] is SaleProduct) {
                  return SaleProductItemGrid(productList[index]);
                } else if (Provider.of<ProductProvider>(context)
                    .productList[index] is AuctionProduct) {
                  return AuctionProductItemGrid(productList[index]);
                } else if (Provider.of<ProductProvider>(context)
                    .productList[index] is RequestProduct) {
                  return RequestProductItemGrid(productList[index]);
                } else {
                  return Center(
                    child: Text(''),
                  );
                }
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 17.0,
                childAspectRatio: 0.545,
                crossAxisCount: 2,
              ),
            ),

            // FutureBuilder(
            //   future: _productsFuture,
            //   builder: (context, AsyncSnapshot<List<BaseProduct>> snapshot) {
            //     switch (snapshot.connectionState) {
            //       case ConnectionState.none:
            //       case ConnectionState.waiting:
            //         return Center(
            //           child: CircularProgressIndicator(),
            //         );
            //         break;
            //       default:
            //         if (snapshot.hasError)
            //           return new Center(
            //             child: Text('Error: ${snapshot.error}'),
            //           );
            //         else if (!snapshot.hasData || snapshot.data.length == 0)
            //           return Center(
            //             child: Text('لا يوجد منتجات !'),
            //           );
            //         else
            //           return GridView.count(
            //               shrinkWrap: true,
            //               padding: EdgeInsets.symmetric(
            //                   horizontal: 10.0, vertical: 20.0),
            //               crossAxisSpacing: 10.0,
            //               mainAxisSpacing: 17.0,
            //               childAspectRatio: 0.545,
            //               crossAxisCount: 2,
            //               primary: false,
            //               children:
            //                   List.generate(snapshot.data.length, (index) {
            //                 if (snapshot.data[index] is SaleProduct) {
            //                   return SaleProductItemGrid(snapshot.data[index]);
            //                 } else if (snapshot.data[index] is AuctionProduct) {
            //                   return AuctionProductItemGrid(
            //                       snapshot.data[index]);
            //                 } else if (snapshot.data[index] is RequestProduct) {
            //                   return RequestProductItemGrid(
            //                       snapshot.data[index]);
            //                 }
            //               }));
            //     }
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  Widget productGrid(List<BaseProduct> list) {
    return GridView.count(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 17.0,
        childAspectRatio: 0.545,
        crossAxisCount: 2,
        primary: false,
        children: List.generate(list.length, (index) {
          if (list[index] is SaleProduct) {
            return SaleProductItemGrid(list[index]);
          } else if (list[index] is AuctionProduct) {
            return AuctionProductItemGrid(list[index]);
          } else if (list[index] is RequestProduct) {
            return RequestProductItemGrid(list[index]);
          }
        }));
  }
}
