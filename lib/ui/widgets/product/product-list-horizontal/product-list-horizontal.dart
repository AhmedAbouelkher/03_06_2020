import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haftaa/Enums/enums.dart';
import 'package:haftaa/ui/pages/auction-product-details.dart';
import 'package:haftaa/ui/widgets/product/product-properties/product-governorate-widget.dart';
import 'package:haftaa/governorate/governorate.dart';
import 'package:haftaa/product/auction-product.dart';
import 'package:haftaa/product/base-product.dart';
import 'package:haftaa/product/product-controller.dart';
import 'package:haftaa/search/search.dart';

class ProductListHorizontal extends StatefulWidget {
  List<BaseProduct> products;
  String titleFirstWord;
  String titleSecondWord;

  ProductSearchModel searcModel;
  ProductListHorizontal(
      {this.products, this.titleFirstWord, this.titleSecondWord});

  ProductListHorizontal.Search(
      {this.titleFirstWord, this.titleSecondWord, this.searcModel});

  @override
  _ProductListHorizontalState createState() => _ProductListHorizontalState();
}

class _ProductListHorizontalState extends State<ProductListHorizontal> {
  ProductController productController = ProductController();
  Future<List<BaseProduct>> futureProducts;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureProducts = productController.search(widget.searcModel);
  }

  bool isNoData = false;
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double size = mediaQueryData.size.height;

    /// Declare device Size
    var deviceSize = MediaQuery.of(context).size;

    return isNoData
        ? Container()
        : Container(
      height: 390.0,
      decoration: BoxDecoration(
        /// To set Gradient in flashSale background
        gradient: LinearGradient(colors: [
          Color(0xFF7F7FD5).withOpacity(0.8),
          Color(0xFF86A8E7),
          Color(0xFF91EAE4)
        ]),
      ),

      /// To set FlashSale Scrolling horizontal
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    left: mediaQueryData.padding.left + 20),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: new BorderRadius.circular(30.0),
                    child: Image.asset(
                      "assets/img/flashsaleicon.png",
                      height: deviceSize.height * 0.087,
                    ),
                  ),
                  Text(
                    widget.titleFirstWord,
                    style: TextStyle(
                      fontFamily: "Popins",
                      fontSize: 30.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    widget.titleSecondWord,
                    style: TextStyle(
                      fontFamily: "Sans",
                      fontSize: 28.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: mediaQueryData.padding.top + 30),
                  ),
                  // Text(
                  //   "End sale in :",
                  //   style: TextStyle(
                  //     fontFamily: "Sans",
                  //     fontSize: 15.0,
                  //     fontWeight: FontWeight.w600,
                  //     color: Colors.white,
                  //   ),
                  // ),
                  Padding(
                    padding: EdgeInsets.only(top: 2.0),
                  ),

                  /// Get a countDown variable
                  Text(
                    // hourstime.toString() +
                    //     " : " +
                    //     minute.toString() +
                    //     " : " +
                    //     second.toString(),
                    '',
                    style: TextStyle(
                      fontFamily: "Sans",
                      fontSize: 19.0,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            ],
          ),
          Padding(padding: EdgeInsets.only(left: 40.0)),
          FutureBuilder(
            future: futureProducts,
            builder:
                (context, AsyncSnapshot<List<BaseProduct>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(),
                  );

                  break;
                default:
                  if (snapshot.hasError)
                    return Center(child: Text(snapshot.error));
                  else if (!snapshot.hasData ||
                      snapshot.data.length == 0) {
                    isNoData = true;
                    return Center(
                      child: Text('لا يوجد منتجات !'),
                    );
                  } else
                    return flashsellWidgets(snapshot.data);
              }
            },
          )
        ],
      ),
    );
  }

  Widget flashsellWidgets(List<BaseProduct> _products) {
    List<Widget> prodWidgets = new List<Widget>();

    _products.forEach((product) {
      prodWidgets.add(Padding(padding: EdgeInsets.only(left: 10.0)));
      prodWidgets.add(flashSaleItem(
        product: product,
        image: product.mainImage,
        title: product.title,
        normalprice: "\$ 50",
        discountprice: "\$ 30",
        ratingvalue: "(10)",
        place: product.governorate,
        stock: (product.type == ItemType.auction)
            ? 'يبدأ بـ ${(product as AuctionProduct).startPrice.toString()} ريال'
            : '',
        colorLine: 0xFF52B640,
        widthLine: 100.0,
      ));
    });

    prodWidgets.add(Padding(padding: EdgeInsets.only(right: 10.0)));
    return Row(
      children: prodWidgets,
    );
  }
}

/// Component FlashSaleItem
class flashSaleItem extends StatelessWidget {
  final String image;
  final String title;
  final String normalprice;
  final String discountprice;
  final String ratingvalue;
  final Future<Governorate> place;
  final String stock;
  final int colorLine;
  final double widthLine;
  BaseProduct product;
  flashSaleItem(
      {this.product,
        this.image,
        this.title,
        this.normalprice,
        this.discountprice,
        this.ratingvalue,
        this.place,
        this.stock,
        this.colorLine,
        this.widthLine});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: () {
                if (product is AuctionProduct) {
                  Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (_, __, ___) =>
                      new AuctionProductDetails(product),
                      transitionDuration: Duration(milliseconds: 900),

                      /// Set animation Opacity in route to detailProduk layout
                      transitionsBuilder:
                          (_, Animation<double> animation, __, Widget child) {
                        return Opacity(
                          opacity: animation.value,
                          child: child,
                        );
                      }));
                }
              },
              child: Container(
                height: 309.0,
                width: 145.0,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 140.0,
                      width: 145.0,
                      child: Image.network(
                        product.mainImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding:
                      EdgeInsets.only(right: 8.0, left: 3.0, top: 15.0),
                      child: Text(product.title,
                          style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Sans")),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(right: 10.0, top: 5.0),
                    //   child: Text(normalprice,
                    //       style: TextStyle(
                    //           fontSize: 10.5,
                    //           decoration: TextDecoration.lineThrough,
                    //           color: Colors.black54,
                    //           fontWeight: FontWeight.w600,
                    //           fontFamily: "Sans")),
                    // ),
                    Padding(
                      padding: EdgeInsets.only(right: 10.0, top: 5.0),
                      child: Text(
                          product.description.substring(
                              0,
                              (product.description.length > 40)
                                  ? 40
                                  : product.description.length),
                          style: TextStyle(
                              fontSize: 12.0,
                              color: Color(0xFF7F7FD5),
                              fontWeight: FontWeight.w800,
                              fontFamily: "Sans")),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0, top: 5.0),

                      // child: Row(
                      //   children: <Widget>[
                      //     Icon(
                      //       Icons.star,
                      //       size: 11.0,
                      //       color: Colors.yellow,
                      //     ),
                      //     Icon(
                      //       Icons.star,
                      //       size: 11.0,
                      //       color: Colors.yellow,
                      //     ),
                      //     Icon(
                      //       Icons.star,
                      //       size: 11.0,
                      //       color: Colors.yellow,
                      //     ),
                      //     Icon(
                      //       Icons.star,
                      //       size: 11.0,
                      //       color: Colors.yellow,
                      //     ),
                      //     Icon(
                      //       Icons.star_half,
                      //       size: 11.0,
                      //       color: Colors.yellow,
                      //     ),
                      //     Text(
                      //       ratingvalue,
                      //       style: TextStyle(
                      //           fontSize: 10.0,
                      //           fontWeight: FontWeight.w500,
                      //           fontFamily: "Sans",
                      //           color: Colors.black38),
                      //     ),
                      //   ],
                      // ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0, top: 5.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.location_on,
                            size: 15.0,
                            color: Colors.black38,
                          ),
                          ProductGovernorateWidget(
                              product.governorate,
                              TextStyle(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Sans",
                                  color: Colors.black38)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, right: 10.0),
                      child: Text(
                        (product.type == ItemType.auction)
                            ? 'يبدأ بـ ${(product as AuctionProduct).startPrice.toString()} ريال'
                            : '',
                        style: TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Sans",
                            color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, right: 10.0),
                      child: Container(
                        height: 5.0,
                        width: widthLine,
                        decoration: BoxDecoration(
                            color: Color(colorLine),
                            borderRadius:
                            BorderRadius.all(Radius.circular(4.0)),
                            shape: BoxShape.rectangle),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
