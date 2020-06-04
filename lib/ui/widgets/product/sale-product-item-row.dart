import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:haftaa/product/base-product.dart';
import 'package:haftaa/provider/provider.dart';
import 'package:haftaa/providers/phone_auth.dart';
import 'package:haftaa/ui/CartUIComponent/Delivery.dart';
import 'package:haftaa/ui/pages/sale-product-details.dart';
import 'package:haftaa/user/user-controller.dart';
import 'package:provider/provider.dart';

class SaleProductItemRow extends StatelessWidget {
  UserController _userController = UserController();
  BaseProduct product;
  VoidCallback onDeleteFromFavourite;

  SaleProductItemRow({this.product, this.onDeleteFromFavourite});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      delegate: new SlidableDrawerDelegate(),
      actionExtentRatio: 0.25,
      // actions: <Widget>[
      //   new IconSlideAction(
      //     caption: 'Archive',
      //     color: Colors.blue,
      //     icon: Icons.archive,
      //     onTap: () {
      //       ///
      //       /// SnackBar show if cart Archive
      //       ///
      //       Scaffold.of(context).showSnackBar(SnackBar(
      //         content: Text("Items Cart Archive"),
      //         duration: Duration(seconds: 2),
      //         backgroundColor: Colors.blue,
      //       ));
      //     },
      //   ),
      // ],
      secondaryActions: <Widget>[
        new IconSlideAction(
          key: Key(product.id.toString()),
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            (product.favUsers as Map).remove(
                Provider.of<PhoneAuthDataProvider>(context, listen: false)
                    .user
                    .uid);

            _userController
                .removeUserFromProductFav(
                    product.id,
                    Provider.of<PhoneAuthDataProvider>(context, listen: false)
                        .user
                        .uid)
                .then((newFavID) {
              onDeleteFromFavourite();
            });

            ///
            /// SnackBar show if cart delet
            ///
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("تم الحذف من مفضلتك"),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.redAccent,
            ));
          },
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.only(top: 1.0, left: 13.0, right: 13.0),

        /// Background Constructor for card
        child: Container(
            height: 220.0,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12.withOpacity(0.1),
                  blurRadius: 3.5,
                  spreadRadius: 0.4,
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(10.0),

                        /// Image item
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12.withOpacity(0.1),
                                      blurRadius: 0.5,
                                      spreadRadius: 0.1)
                                ]),
                            child: Image.network(
                              product.mainImage,
                              height: 130.0,
                              width: 120.0,
                              fit: BoxFit.cover,
                            ))),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 25.0, left: 10.0, right: 5.0),
                        child: Column(
                          /// Text Information Item
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              product.title,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontFamily: "Sans",
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Padding(padding: EdgeInsets.only(top: 10.0)),
                            Text(
                              '${product.descriptionSubString(35)}..',
                              style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                                fontSize: 12.0,
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(top: 0.0)),
                            Text(product.arabicTypeName),
                            // Padding(
                            //   padding:
                            //       const EdgeInsets.only(top: 18.0, left: 0.0),
                            //   child: Container(
                            //     width: 112.0,
                            //     decoration: BoxDecoration(
                            //         color: Colors.white70,
                            //         border: Border.all(
                            //             color:
                            //                 Colors.black12.withOpacity(0.1))),
                            //     child: Row(
                            //       mainAxisAlignment:
                            //           MainAxisAlignment.spaceAround,
                            //       children: <Widget>[
                            //         /// Decrease of value item
                            //         InkWell(
                            //           onTap: () {

                            //           },
                            //           child: Container(
                            //             height: 30.0,
                            //             width: 30.0,
                            //             decoration: BoxDecoration(
                            //                 border: Border(
                            //                     right: BorderSide(
                            //                         color: Colors.black12
                            //                             .withOpacity(0.1)))),
                            //             child: Center(child: Text("-")),
                            //           ),
                            //         ),
                            //         Padding(
                            //           padding: const EdgeInsets.symmetric(
                            //               horizontal: 18.0),
                            //           child: Text(1.toString()),
                            //         ),

                            //         /// Increasing value of item
                            //         InkWell(
                            //           onTap: () {

                            //           },
                            //           child: Container(
                            //             height: 30.0,
                            //             width: 28.0,
                            //             decoration: BoxDecoration(
                            //                 border: Border(
                            //                     left: BorderSide(
                            //                         color: Colors.black12
                            //                             .withOpacity(0.1)))),
                            //             child: Center(child: Text("+")),
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 8.0)),
                Divider(
                  height: 2.0,
                  color: Colors.black12,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 9.0, left: 10.0, right: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),

                        /// Total price of item buy
                        child: Text(
                          product.arabicTypeName,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 15.5,
                              fontFamily: "Sans"),
                        ),
                        // Text(
                        //   "Total : \$ " + "43.34",
                        //   style: TextStyle(
                        //       color: Colors.black,
                        //       fontWeight: FontWeight.w500,
                        //       fontSize: 15.5,
                        //       fontFamily: "Sans"),
                        // ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(PageRouteBuilder(
                              pageBuilder: (_, __, ___) =>
                                  new SaleProductDetails(product,product.user),
                              transitionDuration: Duration(milliseconds: 900),

                              /// Set animation Opacity in route to detailProduk layout
                              transitionsBuilder: (_,
                                  Animation<double> animation,
                                  __,
                                  Widget child) {
                                return Opacity(
                                  opacity: animation.value,
                                  child: child,
                                );
                              }));
                          // Navigator.of(context).push(PageRouteBuilder(
                          //     pageBuilder: (_, __, ___) => delivery()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Container(
                            height: 40.0,
                            width: 120.0,
                            decoration: BoxDecoration(
                              color: Color(0xFFA3BDED),
                            ),
                            child: Center(
                              child: Text(
                                "التفاصيل",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Sans",
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
