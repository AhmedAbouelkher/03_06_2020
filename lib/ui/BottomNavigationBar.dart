import 'package:flutter/material.dart';
import 'package:haftaa/Enums/enums.dart';
import 'package:haftaa/product/product-provider.dart';
import 'package:haftaa/provider/provider.dart';
import 'package:haftaa/providers/phone_auth.dart';
import 'package:haftaa/services/dynamic_link_service.dart';
import 'package:haftaa/ui/BrandUIComponent/BrandLayout.dart';
import 'package:haftaa/ui/HomeUIComponent/Home.dart';
import 'package:haftaa/ui/AcountUIComponent/Profile.dart';
import 'package:haftaa/ui/pages/auction-product-details.dart';
import 'package:haftaa/ui/pages/favourit-list.dart';
import 'package:haftaa/ui/pages/request-product-details.dart';
import 'package:haftaa/ui/pages/sale-product-details.dart';
import 'package:provider/provider.dart';

import '../locator.dart';
import 'AcountUIComponent/AboutApps.dart';
import 'AcountUIComponent/Notification.dart';

class bottomNavigationBar extends StatefulWidget {
  @override
  _bottomNavigationBarState createState() => _bottomNavigationBarState();
}

class _bottomNavigationBarState extends State<bottomNavigationBar> {
  int currentIndex = 0;

  /// Set a type current number a layout class
  Widget callPage(int current, BuildContext context) {
    switch (current) {
      case 0:
        return new Menu();
      case 1:
        return new brand();
      case 2:
        return new FavouritList();

        break;
      case 3:
        return new Profile();
        break;
      default:
        return Menu();
    }
  }

  final DynamicLinkService _dynamicLinkService = locator<DynamicLinkService>();
  static ProductProvider productProvider;
  static NavigatorState navigator;

  @override
  void didChangeDependencies() {
    _dynamicLinkService.handleDynamicLinks((title) {
      if (title == null || title == '') {
      } else {
        //get product
        var ddd;

        redirectToProduct(title);

        //check type

        //redirect to details
      }
    }, (error) {
      var ff;
    });
  }

  redirectToProduct(String id) async {
    var product = await productProvider.getProductById(id);
    var page;
    switch (product.type) {
      case ItemType.sale:
        page = new SaleProductDetails(product, product.user);
        break;
      case ItemType.request:
        page = new RequestProductDetails(product);

        break;
      case ItemType.auction:
        page = new AuctionProductDetails(product);

        break;
    }
    navigator.push(PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionDuration: Duration(milliseconds: 900),

        /// Set animation Opacity in route to detailProduk layout
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return Opacity(
            opacity: animation.value,
            child: child,
          );
        }));
  }

  //ProductBloc productBloc = new ProductBloc();
// @override
// void dispose(){
//   super.dispose();
//   productBloc.dispose();
// }
  /// Build BottomNavigationBar Widget
  @override
  Widget build(BuildContext context) {
    productProvider = Provider.of<ProductProvider>(context);
    navigator = Navigator.of(context);
    Provider.of<PhoneAuthDataProvider>(context, listen: true).currentuser();

    //Provider.of(context).productBloc = productBloc;
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/img/headerProfile.png"),
                      fit: BoxFit.cover)),
              child: null,
            ),
            ListTile(
              title: Text("إعلاناتي"),
              leading: Icon(Icons.list, color: Color(0xff8985ab)),
              onTap: () {





                setState(() {});
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text("تصفح الإعلانات"),
              leading: Icon(
                Icons.home,
                color: Color(0xff8985ab),
              ),
              onTap: () {
                Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (_, __, ___) => new bottomNavigationBar()));
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text(
                "الإعلانات المفضلة",
              ),
              leading: Icon(
                Icons.favorite_border,
                color: Color(0xff8985ab),
              ),
              onTap: () {
                Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (_, __, ___) => new FavouritList()));
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text(
                " الإشعارات",
              ),
              leading: SizedBox(
                  width: 24,
                  height: 24,
                  child: Image.asset(
                    "assets/icon/notification.png",
                  )),
              onTap: () {
                setState(() {
                  if (Provider.of<PhoneAuthDataProvider>(context, listen: false)
                      .isLoggedIn ==
                      true) {
                    Navigator.of(context).push(PageRouteBuilder(
                        pageBuilder: (_, __, ___) => new notification()));
                  } else {
                    Navigator.pushNamed(context, 'choose-login');
                  }
                });
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text("عن التطبيق"),
              leading: Icon(Icons.title, color: Color(0xff8985ab)),
              onTap: () {

                setState(() {
                  Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (_, __, ___) => new aboutApps()));
                });
                Navigator.of(context).pop();
              },
            ),
            Provider.of<PhoneAuthDataProvider>(context, listen: true)
                .isLoggedIn
                ? ListTile(
              title: Text(
                "تسجيل خروج",
              ),
              leading: SizedBox(
                  width: 24,
                  height: 24,
                  child: Image.asset(
                    "assets/icon/aboutapp.png",
                  )),
              onTap: () async{
                await Provider.of<PhoneAuthDataProvider>(context,
                    listen: false)
                    .signOut()
                    .then((onValue) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            bottomNavigationBar()),
                    ModalRoute.withName('/'),
                  );
                });
                setState(() {});
                Navigator.of(context).pop();
              },
            )
                : Container(),
          ],
        ),
      ),
      appBar: AppBar(
        title: Center(
            child: Text(
              'سوق الهفتاء',
              style: TextStyle(color: Colors.white),
            )),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    const Color(0xFFA3BDED),
                    const Color(0xFF6991C7),
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp)),
        ),
      ),
      body: callPage(currentIndex, context),
      bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
              canvasColor: Colors.white,
              textTheme: Theme.of(context).textTheme.copyWith(
                  caption: TextStyle(color: Colors.black26.withOpacity(0.15)))),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            fixedColor: Color(0xFF6991C7),
            onTap: (value) {
              currentIndex = value;
              setState(() {});
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    size: 23.0,
                  ),
                  title: Text(
                    "الرئيسية",
                    style: TextStyle(fontFamily: "Berlin", letterSpacing: 0.5),
                  )),
              BottomNavigationBarItem(
                  icon: Icon(Icons.category),
                  title: Text(
                    "الأقسام",
                    style: TextStyle(fontFamily: "Berlin", letterSpacing: 0.5),
                  )),
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  title: Text(
                    "المفضلة",
                    style: TextStyle(fontFamily: "Berlin", letterSpacing: 0.5),
                  )),
              // BottomNavigationBarItem(
              //     icon: Icon(Icons.shopping_cart),
              //     title: Text(
              //       "Cart",
              //       style: TextStyle(fontFamily: "Berlin", letterSpacing: 0.5),
              //     )),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                    size: 24.0,
                  ),
                  title: Text(
                    "القائمة",
                    style: TextStyle(fontFamily: "Berlin", letterSpacing: 0.5),
                  )),
            ],
          )),
    );
  }
}
