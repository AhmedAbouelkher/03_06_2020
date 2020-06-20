import 'package:flutter/material.dart';
import 'package:haftaa/provider/provider.dart';
import 'package:haftaa/providers/phone_auth.dart';
import 'package:haftaa/ui/BrandUIComponent/BrandLayout.dart';
import 'package:haftaa/ui/HomeUIComponent/Home.dart';
import 'package:haftaa/ui/AcountUIComponent/Profile.dart';
import 'package:haftaa/ui/pages/favourit-list.dart';
import 'package:provider/provider.dart';

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

  //ProductBloc productBloc = new ProductBloc();
// @override
// void dispose(){
//   super.dispose();
//   productBloc.dispose();
// }
  /// Build BottomNavigationBar Widget
  @override
  Widget build(BuildContext context) {
    Provider.of<PhoneAuthDataProvider>(context, listen: true).currentuser();

    //Provider.of(context).productBloc = productBloc;
    return Scaffold(
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
