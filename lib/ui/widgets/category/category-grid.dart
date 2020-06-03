import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CategoryGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// Category Component in bottom of flash sale
    var categoryImageBottom = Container(
      height: 310.0,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0, top: 20.0),
            child: Text(
              "Category",
              style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Sans"),
            ),
          ),
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(top: 15.0)),
                      CategoryItemValue(
                        image: "assets/imgItem/category2.png",
                        title: "Fashion Man",
                        //tap: onClickCategory,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      CategoryItemValue(
                        image: "assets/imgItem/category1.png",
                        title: "Fashion Girl",
                        //tap: onClickCategory,
                      ),
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 10.0)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(top: 15.0)),
                    CategoryItemValue(
                      image: "assets/imgItem/category3.png",
                      title: "Smartphone",
                      //tap: onClickCategory,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
                    CategoryItemValue(
                      image: "assets/imgItem/category4.png",
                      title: "Computer",
                     // tap: onClickCategory,
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(left: 10.0)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(top: 15.0)),
                    CategoryItemValue(
                      image: "assets/imgItem/category5.png",
                      title: "Sport",
                      //tap: onClickCategory,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
                    CategoryItemValue(
                      image: "assets/imgItem/category6.png",
                      title: "Fashion Kids",
                      //tap: onClickCategory,
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(left: 10.0)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(top: 15.0)),
                    CategoryItemValue(
                      image: "assets/imgItem/category7.png",
                      title: "Health",
                      //tap: onClickCategory,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
                    CategoryItemValue(
                      image: "assets/imgItem/category8.png",
                      title: "Makeup",
                     // tap: onClickCategory,
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );

    return categoryImageBottom;
  }
}

/// Component category item bellow FlashSale
class CategoryItemValue extends StatelessWidget {
  String image, title;
  GestureTapCallback tap;

  CategoryItemValue({
    this.image,
    this.title,
    this.tap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tap,
      child: Container(
        height: 105.0,
        width: 160.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(3.0)),
          image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(3.0)),
            color: Colors.black.withOpacity(0.25),
          ),
          child: Center(
              child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Berlin",
              fontSize: 18.5,
              letterSpacing: 0.7,
              fontWeight: FontWeight.w800,
            ),
          )),
        ),
      ),
    );
  }
}
