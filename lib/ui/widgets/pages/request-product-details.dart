import 'package:haftaa/Library/carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:haftaa/providers/phone_auth.dart';
import 'package:haftaa/ui/pages/products-list.dart';
import 'package:haftaa/provider/provider.dart';
import 'package:haftaa/ui/pages/add-product.dart';
import 'package:haftaa/ui/widgets/product/favorite-button.dart';
import 'package:haftaa/ui/widgets/product/product-grid-horezontal.dart';
import 'package:haftaa/ui/widgets/product/product-properties/product-category-widget.dart';
import 'package:haftaa/ui/widgets/product/product-properties/product-governorate-widget.dart';
import 'package:haftaa/ui/widgets/product/product-properties/product-region-widget.dart';
import 'package:haftaa/ui/widgets/product/product-properties/product-user-widget.dart';
import 'package:haftaa/ui/widgets/product/product-speedial.dart';
import 'package:haftaa/ui/widgets/share/share-buttons.dart';
import 'package:haftaa/product/request-product.dart';
//import 'package:haftaa/product/sale-product.dart';

import 'package:haftaa/ui/CartUIComponent/CartLayout.dart';
import 'package:haftaa/ui/HomeUIComponent/ChatItem.dart';

import 'package:haftaa/ui/colors/colors.dart';
import 'package:haftaa/search/search.dart';
import 'package:haftaa/user/user.dart';
import 'package:provider/provider.dart';

//import 'package:haftaa/product/base-product.dart';

/// Custom Text Header
var _txtCustomHead = TextStyle(
  color: Colors.black54,
  fontSize: 17.0,
  fontWeight: FontWeight.w600,
  fontFamily: "Gotik",
);

/// Custom Text Detail
var _txtCustomSub = TextStyle(
  color: Colors.black38,
  fontSize: 13.5,
  fontWeight: FontWeight.w500,
  fontFamily: "Gotik",
);

class RequestProductDetails extends StatefulWidget {
  @override
  final RequestProduct requestProduct;

  RequestProductDetails(this.requestProduct);

  _RequestProductDetailsState createState() =>
      _RequestProductDetailsState(requestProduct);
}

class _RequestProductDetailsState extends State<RequestProductDetails> {
  /// Declare class in FlashSaleItem.dart
  final RequestProduct product;

  _RequestProductDetailsState(this.product);

  @override
  static BuildContext ctx;
  int valueItemChart = 0;
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  /// Create a bottomSheet "ViewMore" in description
  void _bottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return SingleChildScrollView(
            child: Container(
              color: Colors.black26,
              child: Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Container(
                  height: 1500.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0))),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(top: 20.0)),
                      Center(
                          child: Text(
                        "Description",
                        style: _subHeaderCustomStyle,
                      )),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, right: 20.0, left: 20.0, bottom: 20.0),
                        child: Text(product.description, style: _detailText),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  /// Variable for custom Text
  static var _customTextStyle = TextStyle(
    color: Colors.black87,
    fontFamily: "Gotik",
    fontSize: 17.0,
    fontWeight: FontWeight.w800,
  );

  /// Variable Custom Text for Header text
  static var _subHeaderCustomStyle = TextStyle(
      color: Colors.black54,
      fontWeight: FontWeight.w700,
      fontFamily: "Gotik",
      fontSize: 16.0);

  /// Variable Custom Text for Detail text
  static var _detailText = TextStyle(
      fontFamily: "Gotik",
      color: Colors.black54,
      letterSpacing: 0.3,
      wordSpacing: 0.5);

  /// Component any widget for FlashSaleDetail
  Widget build(BuildContext context) {
    final ProductSearchModel _productSearchModel =
        ProductSearchModel.FromSearchParams(
      categoryId: product.categoryId,
      // productTypeInArabic: 'بيع'
    );
    var _suggestedItem = new ProductGridHorizontal(
        searchModel: _productSearchModel,
        expectedProduct: product,
        hideWidgetWhenEmpty: true);
    return Scaffold(
      floatingActionButton: new ProductSpeeDial(product.user),
      key: _key,
      appBar: AppBar(
        actions: <Widget>[
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                  PageRouteBuilder(pageBuilder: (_, __, ___) => new cart()));
            },
            child: Stack(
              alignment: AlignmentDirectional(-1.0, -0.8),
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SystemShareButton(
                        "ألق نظرة على ${product.title} على سوق الهفتاء"),
                    WhatsappShareButton(
                        "ألق نظرة على ${product.title} على سوق الهفتاء")
                  ],
                )

                // IconButton(
                //     onPressed: null,
                //     icon: Icon(
                //       Icons.shopping_cart,
                //       color: Colors.black26,
                //     )),
                // CircleAvatar(
                //   radius: 10.0,
                //   backgroundColor: Colors.red,
                //   child: Text(
                //     valueItemChart.toString(),
                //     style: TextStyle(color: Colors.white, fontSize: 13.0),
                //   ),
                // ),
              ],
            ),
          ),
        ],
        elevation: 0.5,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "مطلوب | ${product.title}",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black54,
            fontSize: 17.0,
            fontFamily: "Gotik",
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  /// ImageSlider in header
                  Container(
                      height: 300.0,
                      child: Hero(
                        tag: "hero-flashsale-${product.id}",
                        child: Material(
                          child: new Carousel(
                            dotColor: Colors.black26,
                            dotIncreaseSize: 1.7,
                            dotBgColor: Colors.transparent,
                            autoplay: false,
                            boxFit: BoxFit.cover,
                            // images: [
                            //   AssetImage(requestProduct.mainImage),
                            //   AssetImage(requestProduct.mainImage),
                            //   AssetImage(requestProduct.mainImage),
                            // ],
                            images:
                                List.generate(product.images.length, (index) {
                              return new NetworkImage(product.images[index]);
                            })
                                  ..add(new NetworkImage(product.mainImage)),
                          ),
                        ),
                      )),

                  ///Label FlashSale in bottom header
                  Container(
                    height: 50.0,
                    width: 1000.0,
                    color: ThemeColors.requestProductTitleBar,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(padding: EdgeInsets.only(right: 20.0)),
                            Image.asset(
                              "assets/icon/flashSaleIcon.png",
                              height: 25.0,
                            ),
                            Padding(padding: EdgeInsets.only(right: 10.0)),
                            Text(
                              "مطلوب للشراء",
                              style: _customTextStyle.copyWith(
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: ProductCategoryWidget(
                              product.category,
                              _customTextStyle.copyWith(
                                  color: Colors.white, fontSize: 13.5)),
                        ),
                      ],
                    ),
                  ),

                  /// White Background for Title, Price and Ratting
                  Container(
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                        color: Color(0xFF656565).withOpacity(0.15),
                        blurRadius: 1.0,
                        spreadRadius: 0.2,
                      )
                    ]),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0, top: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            product.title,
                            style: _customTextStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Padding(padding: EdgeInsets.only(top: 5.0)),
                          Text(
                            //"${requestProduct.governorate == null ? '' : requestProduct.governorate.title} | ${requestProduct.region == null ? '' : requestProduct.region.title}"
                            '',
                            style: _customTextStyle.copyWith(
                                fontSize: 14.0, color: Colors.black26),
                          ),
                          Padding(padding: EdgeInsets.only(top: 5.0)),
                          Text(
                            "${product.price.toString()} ريال",
                            style: _customTextStyle.copyWith(
                                color: Colors.redAccent, fontSize: 20.0),
                          ),
                          Padding(padding: EdgeInsets.only(top: 10.0)),
                          Divider(
                            color: Colors.black12,
                            height: 1.0,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  height: 30.0,
                                  width: 75.0,
                                  decoration: BoxDecoration(
                                    color: Colors.lightGreen,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        product.used ? 'مستعمل' : 'جديد',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      // Padding(
                                      //     padding: EdgeInsets.only(right: 8.0)),
                                      // Icon(
                                      //   Icons.star,
                                      //   color: Colors.white,
                                      //   size: 19.0,
                                      // ),
                                    ],
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: (Provider.of<PhoneAuthDataProvider>(
                                                        context,
                                                        listen: false)
                                                   .isLoggedIn&&
                                            Provider.of<PhoneAuthDataProvider>(
                                                        context,
                                                        listen: false)
                                                    .user
                                                    .uid ==
                                                product.userId)
                                        ? RaisedButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                side: BorderSide(
                                                    color: Colors.teal)),
                                            color: Colors.blueAccent,
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  PageRouteBuilder(
                                                      pageBuilder: (_, __,
                                                              ___) =>
                                                          new AddProduct.edit(
                                                              product)));
                                            },
                                            child: Row(
                                              children: <Widget>[
                                                Text('تعديل'),
                                                Icon(Icons.edit)
                                              ],
                                            ),
                                          )
                                        : Container()),

                                ProductFavoriteButton(product),
                                // Padding(
                                //   padding: const EdgeInsets.only(right: 10.0),
                                //   child: Text(
                                //     requestProduct.ratingvalue,
                                //     style: TextStyle(
                                //         color: Colors.black26,
                                //         fontSize: 12.0,
                                //         fontWeight: FontWeight.w500),
                                //   ),
                                // )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  /// Background white for other product properties
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Container(
                      height: 250.0,
                      width: 600.0,
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                          color: Color(0xFF656565).withOpacity(0.15),
                          blurRadius: 1.0,
                          spreadRadius: 0.2,
                        )
                      ]),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20.0, right: 20.0, left: 60.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "القسم",
                                  style: _txtCustomSub,
                                ),
                                ProductCategoryWidget(
                                    product.category,
                                    _txtCustomHead.copyWith(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20.0, right: 20.0, left: 60.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "المحافظة",
                                  style: _txtCustomSub,
                                ),
                                ProductGovernorateWidget(
                                    product.governorate,
                                    _txtCustomHead.copyWith(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.w600))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20.0, right: 20.0, left: 60.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("المنطقة", style: _txtCustomSub),
                                ProductRegionWidget(
                                    product.region,
                                    _txtCustomHead.copyWith(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.w600))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20.0, right: 20.0, left: 60.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("صاحب المنتج", style: _txtCustomSub),
                                ProductUserWidget(
                                    product.user,
                                    _txtCustomHead.copyWith(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.w600))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  /// Detail Product
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 10.0),
                  //   child: Container(
                  //     height: 205.0,
                  //     width: 600.0,
                  //     decoration:
                  //         BoxDecoration(color: Colors.white, boxShadow: [
                  //       BoxShadow(
                  //         color: Color(0xFF656565).withOpacity(0.15),
                  //         blurRadius: 1.0,
                  //         spreadRadius: 0.2,
                  //       )
                  //     ]),
                  //     child: Padding(
                  //       padding: EdgeInsets.only(top: 20.0),
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: <Widget>[
                  //           Padding(
                  //             padding: const EdgeInsets.only(right: 20.0),
                  //             child: Text(
                  //               "details",
                  //               style: _subHeaderCustomStyle,
                  //             ),
                  //           ),
                  //           Padding(
                  //             padding: const EdgeInsets.only(
                  //                 top: 20.0,
                  //                 right: 20.0,
                  //                 bottom: 10.0,
                  //                 right: 20.0),
                  //             child: Text(
                  //               'requestProduct.detailProduct',
                  //               style: _detailText,
                  //               textDirection: TextDirection.ltr,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  /// Description
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Container(
                      height: 205.0,
                      width: 600.0,
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                          color: Color(0xFF656565).withOpacity(0.15),
                          blurRadius: 1.0,
                          spreadRadius: 0.2,
                        )
                      ]),
                      child: Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: Text(
                                "نبذة",
                                style: _subHeaderCustomStyle,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 15.0,
                                  right: 20.0,
                                  bottom: 10.0,
                                  left: 20.0),
                              child:
                                  Text(product.description, style: _detailText),
                            ),
                            Center(
                              child: InkWell(
                                onTap: () {
                                  _bottomSheet();
                                },
                                child: Text(
                                  "تفاصيل",
                                  style: TextStyle(
                                    color: Colors.indigoAccent,
                                    fontSize: 15.0,
                                    fontFamily: "Gotik",
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),

                  ///Call a variable suggested Item(Top Rated Product Card) in bottom of description
                  _suggestedItem
                ],
              ),
            ),
          ),

          /// If user click icon chart SnackBar show
          /// this code to show a SnackBar
          /// and Increase a valueItemChart + 1
          InkWell(
            onTap: () {
              var snackbar = SnackBar(
                content: Text("Item Added"),
              );
              setState(() {
                valueItemChart++;
              });
              _key.currentState.showSnackBar(snackbar);
            },

            /// Shopping Cart in bottom layout
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Container(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      height: 40.0,
                      width: 60.0,
                      decoration: BoxDecoration(
                          color: Colors.white12.withOpacity(0.1),
                          border: Border.all(color: Colors.black12)),
                      child: Center(
                        child: Image.asset(
                          "assets/icon/shopping-cart.png",
                          height: 23.0,
                        ),
                      ),
                    ),

                    /// Icon Message in bottom layout with Flexible
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(PageRouteBuilder(
                            pageBuilder: (_, ___, ____) => new Chatitem()));
                      },
                      child: Container(
                        height: 40.0,
                        width: 60.0,
                        decoration: BoxDecoration(
                            color: Colors.white12.withOpacity(0.1),
                            border: Border.all(color: Colors.black12)),
                        child: Center(
                          child: Image.asset("assets/icon/message.png",
                              height: 20.0),
                        ),
                      ),
                    ),

                    /// Button Pay
                    InkWell(
                      onTap: () {
                        product.user.then((user) {
                          ProductSearchModel _searchModel =
                              ProductSearchModel.FromSearchParams(
                                  userID: user.id);

                          Navigator.of(context).push(
                            PageRouteBuilder(
                                pageBuilder: (_, __, ___) =>
                                    new ProductList.Search(_searchModel,
                                        'المستخدم (${user.name})'),
                                transitionDuration: Duration(milliseconds: 600),
                                transitionsBuilder: (_,
                                    Animation<double> animation,
                                    __,
                                    Widget child) {
                                  return Opacity(
                                    opacity: animation.value,
                                    child: child,
                                  );
                                }),
                          );
                        });
                      },
                      child: Container(
                        height: 45.0,
                        width: 200.0,
                        decoration: BoxDecoration(
                          color: Colors.indigoAccent,
                        ),
                        child: Center(
                          child: ProductUserWidget(
                              product.user,
                              TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

/// class Item for card in "top rated products"
class FavoriteItem extends StatelessWidget {
  String image, Rating, Salary, title, sale;

  FavoriteItem({this.image, this.Rating, this.Salary, this.title, this.sale});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF656565).withOpacity(0.15),
                blurRadius: 4.0,
                spreadRadius: 1.0,
//           offset: Offset(4.0, 10.0)
              )
            ]),
        child: Wrap(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: 150.0,
                  width: 150.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(7.0),
                          topRight: Radius.circular(7.0)),
                      image: DecorationImage(
                          image: AssetImage(image), fit: BoxFit.cover)),
                ),
                Padding(padding: EdgeInsets.only(top: 15.0)),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0, left: 15.0),
                  child: Text(
                    title,
                    style: TextStyle(
                        letterSpacing: 0.5,
                        color: Colors.black54,
                        fontFamily: "Sans",
                        fontWeight: FontWeight.w500,
                        fontSize: 13.0),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 1.0)),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0, left: 15.0),
                  child: Text(
                    Salary,
                    style: TextStyle(
                        fontFamily: "Sans",
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(right: 15.0, left: 15.0, top: 5.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            Rating,
                            style: TextStyle(
                                fontFamily: "Sans",
                                color: Colors.black26,
                                fontWeight: FontWeight.w500,
                                fontSize: 12.0),
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 14.0,
                          )
                        ],
                      ),
                      Text(
                        sale,
                        style: TextStyle(
                            fontFamily: "Sans",
                            color: Colors.black26,
                            fontWeight: FontWeight.w500,
                            fontSize: 12.0),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
