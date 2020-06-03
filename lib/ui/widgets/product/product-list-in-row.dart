import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:haftaa/ListItem/CartItemData.dart';
import 'package:haftaa/product/auction-product.dart';
import 'package:haftaa/product/base-product.dart';
import 'package:haftaa/product/product-controller.dart';
import 'package:haftaa/product/request-product.dart';
import 'package:haftaa/product/sale-product.dart';
import 'package:haftaa/search/search.dart';
import 'package:haftaa/ui/CartUIComponent/Delivery.dart';
import 'package:haftaa/ui/widgets/loading.dart';
import 'package:haftaa/ui/widgets/no-data.dart';
import 'package:haftaa/ui/widgets/product/auction-product-item-row.dart';
import 'package:haftaa/ui/widgets/product/request-product-item-row.dart';
import 'package:haftaa/ui/widgets/product/sale-product-item-row.dart';

class ProductListItemInRow extends StatefulWidget {
  ProductSearchModel productSearchModel;

  ProductListItemInRow();
  ProductListItemInRow.search({this.productSearchModel});
  @override
  _ProductListItemInRowState createState() => _ProductListItemInRowState();
}

class _ProductListItemInRowState extends State<ProductListItemInRow> {
  final List<cartItem> items = new List();
  Future<List<BaseProduct>> _futureProducts;
  @override
  void initState() {
    super.initState();
    setState(() {
      _futureProducts =
          productController.search(widget.productSearchModel ?? null);
      items.add(
        cartItem(
          img: "assets/imgItem/flashsale3.jpg",
          id: 1,
          title: "Samsung Galaxy Note 9 8 GB RAM ",
          desc: "Internal 1 TB",
          price: "\$ 950",
        ),
      );
    });
  }

  int value = 1;
  int pay = 950;
  ProductController productController = ProductController();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureProducts,
      builder:
          (BuildContext context, AsyncSnapshot<List<BaseProduct>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Loading();
            break;
          default:
            if (snapshot.hasError) {
              return ErrorWidget('هناك خطأ. حاول مرة أخرى');
            } else if (!snapshot.hasData || snapshot.data.length == 0) {
              return NoData(title: 'لا يوجد عناصر بالمفضلة',);
            } else
              return dataList(snapshot);
        }
      },
    );
  }

  List<BaseProduct> products = new List();
  Widget dataList(AsyncSnapshot<List<BaseProduct>> snapshot) {
    products = snapshot.data;
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, position) {
        ///
        /// Widget for list view slide delete
        ///
        return productBasedOnType(products[position]);
      },
      scrollDirection: Axis.vertical,
    );
  }

  Widget productBasedOnType(BaseProduct product) {
    Widget prodWidget;
    if (product is SaleProduct) {
      prodWidget = SaleProductItemRow(
        product: product,
        onDeleteFromFavourite: () {
          products.remove(product);
        },
      );
    } else if (product is RequestProduct) {
      prodWidget = RequestProductItemRow(
        product: product,
        onDeleteFromFavourite: () {
          products.remove(product);
        },
      );
    } else if (product is AuctionProduct) {
      prodWidget = AuctionProductItemRow(
        product: product,
        onDeleteFromFavourite: () {
          products.remove(product);
        },
      );
    }
    return prodWidget;
  }
}
