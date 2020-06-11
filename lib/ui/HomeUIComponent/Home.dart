import 'package:cached_network_image/cached_network_image.dart';
import 'package:haftaa/authentication/auth.dart';
import 'package:haftaa/Library/carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:haftaa/ListItem/HomeGridItemRecomended.dart';
import 'package:haftaa/product/auction-product.dart';
import 'package:haftaa/product/product-provider.dart';
import 'package:haftaa/product/request-product.dart';
import 'package:haftaa/product/sale-product.dart';
import 'package:haftaa/ui/pages/auction-product-details.dart';
import 'package:haftaa/ui/pages/request-product-details.dart';
import 'package:haftaa/ui/pages/sale-product-details.dart';
import 'package:haftaa/ui/widgets/category/category-icons-grid/category-icons-grid.dart';
import 'package:haftaa/ui/widgets/product/product-list-horizontal/product-list-horizontal.dart';
import 'package:haftaa/ui/HomeUIComponent/AppbarGradient.dart';
import 'package:haftaa/Library/countdown/countdown.dart';
import 'package:haftaa/ui/HomeUIComponent/CategoryDetail.dart';
import 'package:haftaa/ui/HomeUIComponent/DetailProduct.dart';
import 'package:haftaa/ui/HomeUIComponent/FlashSale.dart';
import 'package:haftaa/ui/HomeUIComponent/MenuDetail.dart';
import 'package:haftaa/ui/HomeUIComponent/PromotionDetail.dart';
import 'package:haftaa/ui/widgets/product/product-grid.dart';
import 'package:haftaa/provider/provider.dart';
import 'package:haftaa/search/search.dart';
import 'package:provider/provider.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

/// Component all widget in home
class _MenuState extends State<Menu> with TickerProviderStateMixin {
  /// Declare class GridItem from HomeGridItemReoomended.dart in folder ListItem
  GridItem gridItem;

  bool isStarted = false;
  var hourssub, minutesub, secondsub;

  /// CountDown for timer
  CountDown hours, minutes, seconds;
  int hourstime, minute, second = 0;

  /// Set for StartStopPress CountDown
  onStartStopPress() {
    if (this.secondsub == null) {
      secondsub = seconds.stream.listen(null);
      secondsub.onData((Duration d) {
        print(d);
        setState(() {
          second = d.inSeconds;
        });
      });
    }
    if (this.minutesub == null) {
      minutesub = minutes.stream.listen(null);
      minutesub.onData((Duration d) {
        print(d);
        setState(() {
          minute = d.inMinutes;
        });
      });
    }
    if (this.hourssub == null) {
      hourssub = hours.stream.listen(null);
      hourssub.onData((Duration d) {
        print(d);
        setState(() {
          hourstime = d.inHours;
        });
      });
    }
  }

  ScrollController listScrollController;

  /// To set duration initState auto start if FlashSale Layout open
  @override
  void initState() {
//    hours = new CountDown(new Duration(hours: 24));
//    minutes = new CountDown(new Duration(hours: 1));
//    seconds = new CountDown(new Duration(minutes: 1));
//
//    //onStartStopPress();
//    listScrollController = new ScrollController();
//    listScrollController.addListener(_scrollListener);
    // TODO: implement initState
    super.initState();
  }

  void _scrollListener() {
    print(listScrollController.position.extentAfter);
    if (listScrollController.position.extentAfter < 100) {
      Provider.of<ProductProvider>(context).loadMoreProducts(2);
    }
  }

  @override
  void dispose() {
    super.dispose();
    listScrollController.removeListener(_scrollListener);
  }

  onClickMenuIcon(context) {
    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (_, __, ___) => new menuDetail(),
        transitionDuration: Duration(milliseconds: 750),

        /// Set animation with opacity
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return Opacity(
            opacity: animation.value,
            child: child,
          );
        }));
  }

  onClickWeekPromotion(context) {
    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (_, __, ___) => new promoDetail(),
        transitionDuration: Duration(milliseconds: 750),
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return Opacity(
            opacity: animation.value,
            child: child,
          );
        }));
  }

  onClickCategory(context) {
    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (_, __, ___) => new categoryDetail(),
        transitionDuration: Duration(milliseconds: 750),
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return Opacity(
            opacity: animation.value,
            child: child,
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    var categoryIconGrid = CategoryIconsGrid();
    var productGrid = ProductGrid();

    return Scaffold(
      /// Use Stack to costume a appbar
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            controller: listScrollController,
            child: Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(
                        top: mediaQueryData.padding.top + 58.5)),

                /// Call var imageSlider
                buildProductSlider(context),
                categoryIconGrid,

                /// Call var categoryIcon
                //categoryIcon,
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                ),

                /// Call a Grid variable, this is item list in Recomended item

                /// Call var PromoHorizontalList
                //PromoHorizontalList,

                //auctionList,
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                ),
                productGrid,

                /// Call var a FlashSell, i am sorry Typo :v
                //FlashSell,

                // categoryImageBottom,
                // Padding(
                //   padding: EdgeInsets.only(bottom: 10.0),
                // ),
              ],
            ),
          ),

          /// Get a class AppbarGradient
          /// This is a Appbar in home activity

          AppbarGradient(),
        ],
      ),
    );

    /// Declare device Size
    var deviceSize = MediaQuery.of(context).size;

    /// CategoryIcon Component
    var categoryIcon = Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 20.0),
      alignment: AlignmentDirectional.centerStart,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0, top: 0.0),
            child: Text(
              "أقسام",
              style: TextStyle(
                  fontSize: 13.5,
                  fontFamily: "Sans",
                  fontWeight: FontWeight.w700),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 20.0)),

          /// Get class CategoryIconValue
          CategoryIconValue(
            tap1: onClickMenuIcon(context),
            icon1: "assets/icon/camera.png",
            title1: "ماشية",
            tap2: onClickMenuIcon(context),
            icon2: "assets/icon/food.png",
            title2: "ماعز",
            tap3: onClickMenuIcon(context),
            icon3: "assets/icon/handphone.png",
            title3: "جمال",
            tap4: onClickMenuIcon(context),
            icon4: "assets/icon/game.png",
            title4: "سيارات",
          ),
          Padding(padding: EdgeInsets.only(top: 23.0)),
          CategoryIconValue(
            icon1: "assets/icon/fashion.png",
            tap1: onClickMenuIcon(context),
            title1: "أجهزة",
            icon2: "assets/icon/health.png",
            tap2: onClickMenuIcon(context),
            title2: "غسالات",
            icon3: "assets/icon/pc.png",
            tap3: onClickMenuIcon(context),
            title3: "لابتوب",
            icon4: "assets/icon/mesin.png",
            tap4: onClickMenuIcon(context),
            title4: "سماعات",
          ),
          Padding(padding: EdgeInsets.only(top: 23.0)),
          CategoryIconValue(
            icon1: "assets/icon/otomotif.png",
            tap1: onClickMenuIcon(context),
            title1: "كمبيوتر",
            icon2: "assets/icon/sport.png",
            tap2: onClickMenuIcon(context),
            title2: "ماوس",
            icon3: "assets/icon/ticket.png",
            tap3: onClickMenuIcon(context),
            title3: "تلفاز",
            icon4: "assets/icon/book.png",
            tap4: onClickMenuIcon(context),
            title4: "شاشات",
          ),
          Padding(padding: EdgeInsets.only(bottom: 30.0))
        ],
      ),
    );

    /// ListView a WeekPromotion Component
    var PromoHorizontalList = buildOriginalPromoListFromTheme(context);

    ProductSearchModel auctionSearh =
        ProductSearchModel.FromSearchParams(productTypeInArabic: 'مزاد');
    var auctionList = ProductListHorizontal.Search(
      titleFirstWord: 'مزادات',
      titleSecondWord: 'مفتوحة',
      searcModel: auctionSearh,
    );

    /// FlashSale component
    var FlashSell = buildFlashSellFromTheme(mediaQueryData, deviceSize);

    /// Category Component in bottom of flash sale
    var categoryImageBottom = buildCategoryImageBottomTheme(context);

    ///  Grid item in bottom of Category
    var gridOriginal = buildGridOriginalTheme();
  }

  SingleChildScrollView buildGridOriginalTheme() {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 20.0),
              child: Text(
                "Recomended",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 17.0,
                ),
              ),
            ),

            /// To set GridView item
            GridView.count(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 17.0,
                childAspectRatio: 0.545,
                crossAxisCount: 2,
                primary: false,
                children: List.generate(
                  gridItemArray.length,
                  (index) => ItemGrid(gridItemArray[index]),
                ))
          ],
        ),
      ),
    );
  }

  Container buildCategoryImageBottomTheme(BuildContext context) {
    return Container(
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
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(top: 15.0)),
                      CategoryItemValue(
                        image: "assets/imgItem/category2.png",
                        title: "Fashion Man",
                        tap: onClickCategory(context),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      CategoryItemValue(
                        image: "assets/imgItem/category4.png",
                        title: "Computer",
                        tap: onClickCategory(context),
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
                      tap: onClickCategory(context),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
                    CategoryItemValue(
                      image: "assets/imgItem/category4.png",
                      title: "Computer",
                      tap: onClickCategory(context),
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
                      tap: onClickCategory(context),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
                    CategoryItemValue(
                      image: "assets/imgItem/category6.png",
                      title: "Fashion Kids",
                      tap: onClickCategory(context),
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
                      tap: onClickCategory(context),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
                    CategoryItemValue(
                      image: "assets/imgItem/category8.png",
                      title: "Makeup",
                      tap: onClickCategory(context),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Container buildFlashSellFromTheme(
      MediaQueryData mediaQueryData, Size deviceSize) {
    return Container(
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
                padding:
                    EdgeInsets.only(left: mediaQueryData.padding.left + 20),
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
                    "مزادات",
                    style: TextStyle(
                      fontFamily: "Popins",
                      fontSize: 30.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "مفتوحة",
                    style: TextStyle(
                      fontFamily: "Sans",
                      fontSize: 28.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: mediaQueryData.padding.top + 30),
                  ),
                  Text(
                    "End sale in :",
                    style: TextStyle(
                      fontFamily: "Sans",
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 2.0),
                  ),

                  /// Get a countDown variable
                  Text(
                    hourstime.toString() +
                        " : " +
                        minute.toString() +
                        " : " +
                        second.toString(),
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

          /// Get a component flashSaleItem class
          flashSaleItem(
            image: "assets/imgItem/mackbook.jpg",
            title: "Apple Macbook Pro 13 with Touch Bar",
            normalprice: "\$ 2,020",
            discountprice: "\$ 1,300",
            ratingvalue: "(56)",
            place: "United Kingdom",
            stock: "9 Available",
            colorLine: 0xFFFFA500,
            widthLine: 50.0,
          ),
          Padding(padding: EdgeInsets.only(left: 10.0)),
          flashSaleItem(
            image: "assets/imgItem/flashsale2.jpg",
            title: "7 Level Karina Dress Sweet Pesta",
            normalprice: "\$ 14",
            discountprice: "\$ 10",
            ratingvalue: "(16)",
            place: "United Kingdom",
            stock: "24 Available",
            colorLine: 0xFF52B640,
            widthLine: 100.0,
          ),
          Padding(padding: EdgeInsets.only(left: 10.0)),
          flashSaleItem(
            image: "assets/imgItem/flashsale3.jpg",
            title: "Samsung Galaxy Note 9 8GB - 512GB",
            normalprice: "\$ 1,000",
            discountprice: "\$ 950",
            ratingvalue: "(20)",
            place: "United Kingdom",
            stock: "14 Available",
            colorLine: 0xFF52B640,
            widthLine: 90.0,
          ),
          Padding(padding: EdgeInsets.only(left: 10.0)),
          flashSaleItem(
            image: "assets/imgItem/flashsale4.jpg",
            title: "Harry Potter Spesial Edition ",
            normalprice: "\$ 25",
            discountprice: "\$ 20",
            ratingvalue: "(22)",
            place: "United Kingdom",
            stock: "5 Available",
            colorLine: 0xFFFFA500,
            widthLine: 30.0,
          ),
          Padding(padding: EdgeInsets.only(left: 10.0)),
          flashSaleItem(
            image: "assets/imgItem/flashsale5.jpg",
            title: "Pro Evolution Soccer 2019 Steam Original PC Games",
            normalprice: "\$ 50",
            discountprice: "\$ 30",
            ratingvalue: "(10)",
            place: "United Kingdom",
            stock: "30 Available",
            colorLine: 0xFF52B640,
            widthLine: 100.0,
          ),
          Padding(padding: EdgeInsets.only(left: 10.0)),
        ],
      ),
    );
  }

  Container buildOriginalPromoListFromTheme(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 230.0,
      padding: EdgeInsets.only(bottom: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0, top: 15.0, bottom: 3.0),
              child: Text(
                "مزادات مفتوحة",
                style: TextStyle(
                    fontSize: 15.0,
                    fontFamily: "Sans",
                    fontWeight: FontWeight.w700),
              )),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 10.0),
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                Padding(padding: EdgeInsets.only(left: 20.0)),
                InkWell(
                    onTap: onClickWeekPromotion(context),
                    child: Image.asset("assets/imgPromo/Discount1.png")),
                Padding(padding: EdgeInsets.only(left: 10.0)),
                InkWell(
                    onTap: onClickWeekPromotion(context),
                    child: Image.asset("assets/imgPromo/Discount3.png")),
                Padding(padding: EdgeInsets.only(left: 10.0)),
                InkWell(
                    onTap: onClickWeekPromotion(context),
                    child: Image.asset("assets/imgPromo/Discount2.png")),
                Padding(padding: EdgeInsets.only(left: 10.0)),
                InkWell(
                    onTap: onClickWeekPromotion(context),
                    child: Image.asset("assets/imgPromo/Discount4.png")),
                Padding(padding: EdgeInsets.only(left: 10.0)),
                InkWell(
                    onTap: onClickWeekPromotion(context),
                    child: Image.asset("assets/imgPromo/Discount5.png")),
                Padding(padding: EdgeInsets.only(left: 10.0)),
                InkWell(
                    onTap: onClickWeekPromotion(context),
                    child: Image.asset("assets/imgPromo/Discount6.png")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container buildProductSlider(BuildContext context) {
    var sliderProducts = Provider.of<ProductProvider>(context)
        .productList
        .where((element) => element.displayInMobileHome == true)
        .toList();
    var images = [];
    images.addAll(List.generate(
        sliderProducts.length,
        (index) => Stack(
          children: <Widget>[
            Container(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: sliderProducts[index].mainImage,
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                ),
              ),
            ),
            Center(child: Container(
                decoration: BoxDecoration(
                    color: Colors.black26
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10 , right: 10),
                  child: Text(sliderProducts[index].title,style: TextStyle(
                      color: Colors.white,fontSize: 20
                  ),),
                )
            ),
            ),

          ],
        )));

    // NetworkImage(sliderProducts[index].mainImage)));

    /// ImageSlider in header
    var imageSlider = Container(
      height: 182.0,
      child: new Carousel(
        onImageTap: (imageIndex) {
          var detailsPage;

          if (sliderProducts[imageIndex] is SaleProduct) {
            detailsPage = new SaleProductDetails(
                sliderProducts[imageIndex], sliderProducts[imageIndex].user);
          } else if (sliderProducts[imageIndex] is AuctionProduct) {
            detailsPage = new AuctionProductDetails(sliderProducts[imageIndex]);
          } else if (sliderProducts[imageIndex] is RequestProduct) {
            detailsPage = new RequestProductDetails(sliderProducts[imageIndex]);
          }

          Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (_, __, ___) => detailsPage,
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
        boxFit: BoxFit.cover,
        dotColor: Color(0xFF6991C7).withOpacity(0.8),
        dotSize: 5.5,
        dotSpacing: 16.0,
        dotBgColor: Colors.transparent,
        showIndicator: true,
        overlayShadow: true,
        overlayShadowColors: Colors.white.withOpacity(0.9),
        overlayShadowSize: 0.9,
        images: images,
      ),
    );
    return imageSlider;
  }
}

/// ItemGrid in bottom item "Recomended" item
class ItemGrid extends StatelessWidget {
  /// Get data from HomeGridItem.....dart class
  GridItem gridItem;

  ItemGrid(this.gridItem);

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return InkWell(
      onTap: () {
        Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (_, __, ___) => new detailProduk(gridItem),
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
                /// Set Animation image to detailProduk layout
                Hero(
                  tag: "hero-grid-${gridItem.id}",
                  child: Material(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(PageRouteBuilder(
                            opaque: false,
                            pageBuilder: (BuildContext context, _, __) {
                              return new Material(
                                color: Colors.black54,
                                child: Container(
                                  padding: EdgeInsets.all(30.0),
                                  child: InkWell(
                                    child: Hero(
                                        tag: "hero-grid-${gridItem.id}",
                                        child: Image.asset(
                                          gridItem.img,
                                          width: 300.0,
                                          height: 300.0,
                                          alignment: Alignment.center,
                                          fit: BoxFit.contain,
                                        )),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              );
                            },
                            transitionDuration: Duration(milliseconds: 500)));
                      },
                      child: Container(
                        height: mediaQueryData.size.height / 3.3,
                        width: 200.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(7.0),
                                topRight: Radius.circular(7.0)),
                            image: DecorationImage(
                                image: AssetImage(gridItem.img),
                                fit: BoxFit.cover)),
                      ),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 7.0)),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Text(
                    gridItem.title,
                    overflow: TextOverflow.ellipsis,
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
                    gridItem.price,
                    style: TextStyle(
                        fontFamily: "Sans",
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            gridItem.rattingValue,
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
                        gridItem.itemSale,
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

/// Component FlashSaleItem
class flashSaleItem extends StatelessWidget {
  final String image;
  final String title;
  final String normalprice;
  final String discountprice;
  final String ratingvalue;
  final String place;
  final String stock;
  final int colorLine;
  final double widthLine;

  flashSaleItem(
      {this.image,
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
                Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (_, __, ___) => new flashSale(),
                    transitionsBuilder:
                        (_, Animation<double> animation, __, Widget child) {
                      return Opacity(
                        opacity: animation.value,
                        child: child,
                      );
                    },
                    transitionDuration: Duration(milliseconds: 850)));
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
                      child: Image.asset(
                        image,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(right: 8.0, left: 3.0, top: 15.0),
                      child: Text(title,
                          style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Sans")),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 10.0, top: 5.0),
                      child: Text(normalprice,
                          style: TextStyle(
                              fontSize: 10.5,
                              decoration: TextDecoration.lineThrough,
                              color: Colors.black54,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Sans")),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 10.0, top: 5.0),
                      child: Text(discountprice,
                          style: TextStyle(
                              fontSize: 12.0,
                              color: Color(0xFF7F7FD5),
                              fontWeight: FontWeight.w800,
                              fontFamily: "Sans")),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0, top: 5.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.star,
                            size: 11.0,
                            color: Colors.yellow,
                          ),
                          Icon(
                            Icons.star,
                            size: 11.0,
                            color: Colors.yellow,
                          ),
                          Icon(
                            Icons.star,
                            size: 11.0,
                            color: Colors.yellow,
                          ),
                          Icon(
                            Icons.star,
                            size: 11.0,
                            color: Colors.yellow,
                          ),
                          Icon(
                            Icons.star_half,
                            size: 11.0,
                            color: Colors.yellow,
                          ),
                          Text(
                            ratingvalue,
                            style: TextStyle(
                                fontSize: 10.0,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Sans",
                                color: Colors.black38),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0, top: 5.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.location_on,
                            size: 11.0,
                            color: Colors.black38,
                          ),
                          Text(
                            place,
                            style: TextStyle(
                                fontSize: 10.0,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Sans",
                                color: Colors.black38),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, right: 10.0),
                      child: Text(
                        stock,
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

/// Component item Menu icon bellow a ImageSlider
class CategoryIconValue extends StatelessWidget {
  String icon1, icon2, icon3, icon4, title1, title2, title3, title4;
  GestureTapCallback tap1, tap2, tap3, tap4;

  CategoryIconValue(
      {this.icon1,
      this.tap1,
      this.icon2,
      this.tap2,
      this.icon3,
      this.tap3,
      this.icon4,
      this.tap4,
      this.title1,
      this.title2,
      this.title3,
      this.title4});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        InkWell(
          onTap: tap1,
          child: Column(
            children: <Widget>[
              Image.asset(
                icon1,
                height: 19.2,
              ),
              Padding(padding: EdgeInsets.only(top: 7.0)),
              Text(
                title1,
                style: TextStyle(
                  fontFamily: "Sans",
                  fontSize: 10.0,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ),
        InkWell(
          onTap: tap2,
          child: Column(
            children: <Widget>[
              Image.asset(
                icon2,
                height: 26.2,
              ),
              Padding(padding: EdgeInsets.only(top: 0.0)),
              Text(
                title2,
                style: TextStyle(
                  fontFamily: "Sans",
                  fontSize: 10.0,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ),
        InkWell(
          onTap: tap3,
          child: Column(
            children: <Widget>[
              Image.asset(
                icon3,
                height: 22.2,
              ),
              Padding(padding: EdgeInsets.only(top: 4.0)),
              Text(
                title3,
                style: TextStyle(
                  fontFamily: "Sans",
                  fontSize: 10.0,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ),
        InkWell(
          onTap: tap4,
          child: Column(
            children: <Widget>[
              Image.asset(
                icon4,
                height: 19.2,
              ),
              Padding(padding: EdgeInsets.only(top: 7.0)),
              Text(
                title4,
                style: TextStyle(
                  fontFamily: "Sans",
                  fontSize: 10.0,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
