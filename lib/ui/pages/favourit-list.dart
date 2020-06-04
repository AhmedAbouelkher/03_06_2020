import 'package:flutter/material.dart';
import 'package:haftaa/ListItem/CartItemData.dart';
import 'package:haftaa/providers/phone_auth.dart';
import 'package:haftaa/ui/CartUIComponent/Delivery.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:haftaa/ui/LoginOrSignup/ChoseLoginOrSignup.dart';
import 'package:haftaa/provider/provider.dart';
import 'package:haftaa/search/search.dart';
import 'package:haftaa/ui/widgets/loading.dart';
import 'package:haftaa/ui/widgets/login-please.dart';

import 'package:haftaa/ui/widgets/product/product-list-in-row.dart';
import 'package:provider/provider.dart';

class FavouritList extends StatefulWidget {
  @override
  _FavouritListState createState() => _FavouritListState();
}

class _FavouritListState extends State<FavouritList> {
  final List<cartItem> items = new List();

  @override
  void initState() {
    super.initState();
  }

  final _scaffoldkey = GlobalKey<ScaffoldState>();

  void showSnackBar(String message,
      {SnackBarAction action, int durationInSeconds}) {
    final snackBarContent = SnackBar(
      duration: Duration(seconds: durationInSeconds ?? 3),
      content: Text(message),
      action: SnackBarAction(
          label: 'حسناً',
          onPressed: _scaffoldkey.currentState.hideCurrentSnackBar),
    );
    _scaffoldkey.currentState.showSnackBar(snackBarContent);
  }

  // navigateToRoot() async {
  //   showSnackBar('سجل الدخول من فضلك');
  //   await new Future.delayed(Duration(seconds: 1));
  //   Navigator.pushReplacementNamed(context, 'root');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Color(0xFF6991C7)),
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            "الإعلانات المفضلة",
            style: TextStyle(
                fontFamily: "Gotik",
                fontSize: 18.0,
                color: Colors.black54,
                fontWeight: FontWeight.w700),
          ),
          elevation: 0.0,
        ),
        body: Provider.of<PhoneAuthDataProvider>(context, listen: false)
                .isLoggedIn
            ? ProductListItemInRow.search(
                productSearchModel: ProductSearchModel.FromSearchParams(
                    userIDWhoMakesFavorite: Provider.of<PhoneAuthDataProvider>(
                            context,
                            listen: false)
                        .user
                        .uid),
              )
            : LoginPlease());
  }
}
