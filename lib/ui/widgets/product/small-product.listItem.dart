import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haftaa/ui/pages/auction-product-details.dart';
import 'package:haftaa/ui/pages/request-product-details.dart';
import 'package:haftaa/ui/pages/sale-product-details.dart';
import 'package:haftaa/product/auction-product.dart';
import 'package:haftaa/product/base-product.dart';
import 'package:haftaa/product/request-product.dart';
import 'package:haftaa/product/sale-product.dart';

class SmallProductListitem extends StatelessWidget {
  //String image, Rating, Salary, title, sale;
  BaseProduct product;
  SmallProductListitem(this.product);
  //SmallProductListitem({this.image, this.Rating, this.Salary, this.title, this.sale});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 5.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (_, __, ___) {
                if (product is SaleProduct) {
                  return new SaleProductDetails(product);
                } else if (product is RequestProduct) {
                  return new RequestProductDetails(product);
                } else if (product is AuctionProduct) {
                  return new AuctionProductDetails(product);
                }
              },
              transitionDuration: Duration(milliseconds: 900),

              /// Set animation Opacity in route to detailProduk layout
              transitionsBuilder:
                  (_, Animation<double> animation, __, Widget child) {
                return Opacity(
                  opacity: animation.value,
                  child: child,
                );
              }));
        },
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
                            image: NetworkImage(product.mainImage),
                            fit: BoxFit.cover)),
                  ),
                  Padding(padding: EdgeInsets.only(top: 15.0)),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Text(
                      product.title,
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
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Text(
                      product.arabicTypeName,
                      style: TextStyle(
                          fontFamily: "Sans",
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 5.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              '',
                              style: TextStyle(
                                  fontFamily: "Sans",
                                  color: Colors.black26,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.0),
                            ),
                            // Icon(
                            //   Icons.star,
                            //   color: Colors.yellow,
                            //   size: 14.0,
                            // )
                          ],
                        ),
                        Text(
                          '',
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
      ),
    );
  }
}
