import 'package:flutter/material.dart';
import 'package:haftaa/Category/BaseCategory.dart';
import 'package:haftaa/core/enums.dart';
import 'package:haftaa/ui/HomeUIComponent/ChatItem.dart';
import 'package:haftaa/ui/pages/products-list.dart';
import 'package:haftaa/ui/widgets/category/category-list-dropdown.dart';
import 'package:haftaa/ui/widgets/custom-dropdownbutton.dart';
import 'package:haftaa/ui/widgets/governorate/governorate-list-dropdown.dart';

import 'package:haftaa/governorate/governorate.dart';
import 'package:haftaa/search/search.dart';

class AdvancedSearch extends StatefulWidget {
  bool searchBytitleOnly = false;

  AdvancedSearch.withOptions({this.searchBytitleOnly});

  AdvancedSearch();

  @override
  _AdvancedSearchState createState() => _AdvancedSearchState();

  ProductSearchModel productSearchModel = new ProductSearchModel();
}

class _AdvancedSearchState extends State<AdvancedSearch> {
  static TextEditingController productTitletextEditingController =
      TextEditingController();

  String productTypeSelectedValue;

  void productType_onChanged(String selectedValue) {
    setState(() {});
  }

  String titleSearchWord = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    productTitletextEditingController.addListener(() {
      titleSearchWord = productTitletextEditingController.text.toLowerCase();
    });
  }

  /// Sentence Text header "Hello i am Treva.........."
  var _textHello = Padding(
    padding: const EdgeInsets.only(right: 50.0, left: 20.0),
    child: Text(
      "مرحباً , عن ماذا تبحث ؟",
      style: TextStyle(
          letterSpacing: 0.1,
          fontWeight: FontWeight.w600,
          fontSize: 27.0,
          color: Colors.black54,
          fontFamily: "Gotik"),
    ),
  );

  /// Item TextFromField Search
  var _searchByName = Padding(
    padding: const EdgeInsets.only(top: 0.0, right: 20.0, left: 20.0),
    child: Container(
      height: 50.0,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15.0,
                spreadRadius: 0.0)
          ]),
      child: TextFormField(
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
        onFieldSubmitted: (d) {},
        controller: productTitletextEditingController,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(
            Icons.search,
            color: Color(0xFF6991C7),
            size: 28.0,
          ),
          hintText: "اكتب...",
          hintStyle: TextStyle(
              color: Colors.black54,
              fontFamily: "Gotik",
              fontWeight: FontWeight.w400),
        ),
      ),
    ),
  );

  /// Item Favorite Item with Card item
  var _favorite = Padding(
    padding: const EdgeInsets.only(top: 20.0),
    child: Container(
      height: 250.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Text(
              "Favorite",
              style: TextStyle(fontFamily: "Gotik", color: Colors.black26),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 20.0, bottom: 2.0),
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                /// Get class FavoriteItem
                Padding(padding: EdgeInsets.only(right: 20.0)),
                FavoriteItem(
                  image: "assets/imgItem/shoes1.jpg",
                  title: "Firrona Skirt!",
                  Salary: "\$ 10",
                  Rating: "4.8",
                  sale: "923 Sale",
                ),
                Padding(padding: EdgeInsets.only(right: 20.0)),
                FavoriteItem(
                  image: "assets/imgItem/acesoris1.jpg",
                  title: "Arpenaz 4",
                  Salary: "\$ 200",
                  Rating: "4.2",
                  sale: "892 Sale",
                ),
                Padding(padding: EdgeInsets.only(right: 20.0)),
                FavoriteItem(
                  image: "assets/imgItem/kids1.jpg",
                  title: "Mon Cheri Pingun",
                  Salary: "\$ 3",
                  Rating: "4.8",
                  sale: "110 Sale",
                ),
                Padding(padding: EdgeInsets.only(right: 10.0)),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  /// Popular Keyword Item
  var _suggestedText = Container(
    height: 145.0,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 20.0, top: 20.0),
          child: Text(
            "Populer Keyword",
            style: TextStyle(fontFamily: "Gotik", color: Colors.black26),
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 20.0)),
        Expanded(
            child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(right: 20.0)),
            KeywordItem(
              title: "Iphone X",
              title2: "Mackbook",
            ),
            KeywordItem(
              title: "Samsung",
              title2: "Apple",
            ),
            KeywordItem(
              title: "Note 9",
              title2: "Nevada",
            ),
            KeywordItem(
              title: "Watch",
              title2: "PC",
            ),
          ],
        ))
      ],
    ),
  );

  /// Popular Keyword Item
  var _productType = Container(
    height: 145.0,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 20.0, top: 20.0),
          child: Text(
            "الغرض",
            style: TextStyle(fontFamily: "Gotik", color: Colors.black26),
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 20.0)),
        Expanded(
            child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(right: 20.0)),

            ProductTypeButton(
              title: 'بيع',
            ),
            ProductTypeButton(
              title: 'شراء',
            ),
            ProductTypeButton(
              title: 'مزاد',
            ),
            // KeywordItem(
            //   title: "Iphone X",
            //   title2: "Mackbook",
            // ),
          ],
        ))
      ],
    ),
  );

  /// Popular Keyword Item
  var _productTypeDropdown = Container(
    height: 145.0,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 20.0, top: 20.0),
          child: Text(
            "الغرض",
            style: TextStyle(fontFamily: "Gotik", color: Colors.black26),
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 20.0)),
        DropdownButton<String>(
          onChanged: (ssss) {},
          hint: Text('اختر الغرض'),
          // value: productTypeSelectedValue,
          items: <String>['بيع', 'شراء', 'مزاد']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem(
              child: Text(value),
              value: value,
            );
          }).toList(),
        )
      ],
    ),
  );
  var productTypes = <DropdownMenuItem>[
    DropdownMenuItem(
      child: Text('بيع'),
      value: 'بيع',
    ),
    DropdownMenuItem(
      child: Text('شراء'),
      value: 'شراء',
    ),
    DropdownMenuItem(
      child: Text('مزاد'),
      value: 'مزاد',
    ),
  ];

  var productTypeDropdownWidget;

  String productIsUsed;
  var productStatuses = <DropdownMenuItem>[
    DropdownMenuItem(
      child: Text(
        'مستعمل',
      ),
      value: 'مستعمل',
    ),
    DropdownMenuItem(
      child: Text('جديد'),
      value: 'جديد',
    ),
  ];

  var productCategoriesDropdownWidget = CategoriesDropdownWidget.Custom(
    hintText: "اختر القسم",
    title: "القسم",
    displayDropDownOnly: false,
    onChange: (BaseCategory category) {
      var ss;
    },
  );
  Governorate selected_Governorate;

  void onGovernorateSelectChanged(Governorate gov) {
    selected_Governorate = gov;
  }

  var governoratsDropdownWidget;
  ProductSearchModel _searchModel = ProductSearchModel();

  Widget allSearchFields() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 20.0, top: 20.0),
          child: productStatusDropdownWidget,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20.0, top: 20.0),
          child: productTypeDropdownWidget,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20.0, top: 20.0),
          child: productCategoriesDropdownWidget,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20.0, top: 20.0),
          child: governoratsDropdownWidget,
        ),
      ],
    );
  }

  String selectedProductType;
  var productStatusDropdownWidget;

  void onGovernorateDeleteSelectedItem() {}

  @override
  Widget build(BuildContext context) {
    governoratsDropdownWidget = GovernorateDropdownWidget.custom(
      selectedGovernorate: selected_Governorate,
      selectionIsRequired: true,
      hintText: "اختر المحافظة",
      title: "المحافظة",
      onChange: (Governorate governorate) {
        onGovernorateSelectChanged(governorate);
      },
      onDeleteSeelction: () => onGovernorateDeleteSelectedItem,
    );
    productTypeDropdownWidget = CustomDropdownWidget.Custom(
      items: productTypes,
      selectedValue: selectedProductType,
      hintText: 'حدد الغرض',
      title: 'الغرض من الإعلان',
      selectionIsRequired: true,
      onChange: (value) {
        setState(() {
          selectedProductType = value;
        });
      },
    );

    productStatusDropdownWidget = CustomDropdownWidget.Custom(
      items: productStatuses,
      selectedValue: productIsUsed,
      hintText: 'الحالة',
      title: 'حالة المنتج',
      selectionIsRequired: true,
      onChange: (value) {
        setState(() {
          productIsUsed = value;
        });
      },
    );
    var bottomButtons = Column(
      children: <Widget>[
        InkWell(
          onTap: () {
            var snackbar = SnackBar(
              content: Text("Item Added"),
            );
            setState(() {
              //valueItemChart++;
            });
            //_key.currentState.showSnackBar(snackbar);
          },
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

                  /// Chat Icon
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (_, ___, ____) => new chatItem()));
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
                      doSearch();
                    },
                    child: Container(
                      height: 45.0,
                      width: 200.0,
                      decoration: BoxDecoration(
                        color: Colors.indigoAccent,
                      ),
                      child: Center(
                        child: Text(
                          "اعرض النتائج",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
    return Scaffold(
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          InkWell(
            onTap: doSearch,
            child: Container(
              height: 50.0,
              width: 280.0,
              decoration: BoxDecoration(
                  color: Color(0xFF6991C7),
                  borderRadius: BorderRadius.all(Radius.circular(25.0))),
              child: Center(
                  child: Text(
                "بحث",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16.0),
              )),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color(0xFF6991C7),
        ),
        // title: Text(
        //   "البحث",
        //   style: TextStyle(
        //       fontWeight: FontWeight.w700,
        //       fontSize: 18.0,
        //       color: Colors.black54,
        //       fontFamily: "Gotik"),
        // ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Flexible(
                child: SingleChildScrollView(
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.only(top: 1.0),
                      child: Column(
                        textDirection: TextDirection.rtl,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          /// Caliing a variable
                          //_textHello,
                          _searchByName,
                          //_suggestedText,
                          !widget.searchBytitleOnly
                              ? allSearchFields()
                              : Text(''),
                          Padding(
                              padding: EdgeInsets.only(bottom: 30.0, top: 2.0)),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          //   child: Container(
                          //     alignment: FractionalOffset.center,
                          //     height: 49.0,
                          //     width: 500.0,
                          //     decoration: BoxDecoration(
                          //       color: Color.fromRGBO(107, 112, 248, 1.0),
                          //       borderRadius: BorderRadius.circular(40.0),
                          //       boxShadow: [
                          //         BoxShadow(color: Colors.black26, blurRadius: 15.0)
                          //       ],
                          //     ),
                          //     child: Row(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       children: <Widget>[
                          //         Image.asset(
                          //           "assets/img/search.png",
                          //           height: 25.0,
                          //         ),
                          //         Padding(
                          //             padding:
                          //                 EdgeInsets.symmetric(horizontal: 7.0)),
                          //         FlatButton(
                          //           onPressed: () {
                          //             _searchModel =
                          //                 ProductSearchModel.FromSearchParams(
                          //                     category:
                          //                         productCategoriesDropdownWidget
                          //                             .selectedCategory,
                          //                     governorate: governoratsDropdownWidget
                          //                         .selectedGovernorate,
                          //                     productType: productTypeDropdownWidget
                          //                         .selectedValue,
                          //                     productUsingStatus:
                          //                         productStatusDropdownWidget
                          //                             .selectedValue,
                          //                     productTitle: null);

                          //             Navigator.of(context).push(PageRouteBuilder(
                          //                 pageBuilder: (_, __, ___) =>
                          //                     new ProductList(),
                          //                 transitionDuration:
                          //                     Duration(milliseconds: 900),

                          //                 /// Set animation Opacity in route to detailProduk layout
                          //                 transitionsBuilder: (_,
                          //                     Animation<double> animation,
                          //                     __,
                          //                     Widget child) {
                          //                   return Opacity(
                          //                     opacity: animation.value,
                          //                     child: child,
                          //                   );
                          //                 }));
                          //           },
                          //           child: Text(
                          //             "عرض النتائج",
                          //             style: TextStyle(
                          //                 color: Colors.white,
                          //                 fontSize: 15.0,
                          //                 fontWeight: FontWeight.w500,
                          //                 fontFamily: 'Sans'),
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          //_favorite,
                          Padding(
                              padding: EdgeInsets.only(bottom: 30.0, top: 2.0))
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              /// If user click icon chart SnackBar show
              /// this code to show a SnackBar
              /// and Increase a valueItemChart + 1

              //bottomButtons
            ],
          ),
        ],
      ),
    );
  }

  doSearch() {
    // Navigator.of(context).push(PageRouteBuilder(
    //     pageBuilder: (_, __, ___) =>
    //         new delivery()));

    _searchModel = ProductSearchModel.FromSearchParams(
        category: productCategoriesDropdownWidget.selectedCategory,
        governorate: selected_Governorate,
        productTypeInArabic: selectedProductType,
        productUsingStatus: productIsUsed,
        productTitle: titleSearchWord);

    Navigator.pop(context, _searchModel);
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) => ProductList(
    //             searchModel: _searchModel,
    //           )),
    // );

    //Navigator.pop(context,_searchModel);
    // Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => ProductList.Search(
    //               _searchModel,
    //               'بحث المنتجات',
    //               showCategoriesSlider: false,
    //             )));

    // Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(
    //         builder: (context) => ProductList.Search(_searchModel)),
    //     (Route<dynamic> route) => false);

    // Navigator.of(context).push(PageRouteBuilder(
    //     pageBuilder: (_, __, ___) => new ProductList(),
    //     transitionDuration: Duration(milliseconds: 900),

    //     /// Set animation Opacity in route to detailProduk layout
    //     transitionsBuilder: (_,
    //         Animation<double> animation,
    //         __,
    //         Widget child) {
    //       return Opacity(
    //         opacity: animation.value,
    //         child: child,
    //       );
    //     }));
  }
}

/// Popular Keyword Item class
class ProductTypeButton extends StatelessWidget {
  @override
  String title;

  ProductTypeButton({this.title});

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 4.0, right: 3.0),
          child: Container(
            height: 29.5,
            width: 90.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4.5,
                  spreadRadius: 1.0,
                )
              ],
            ),
            child: Center(
              child: FlatButton(
                child: Text(title),

                //overflow: TextOverflow.ellipsis,
                //style: TextStyle(color: Colors.black54, fontFamily: "Sans"),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Popular Keyword Item class
class KeywordItem extends StatelessWidget {
  @override
  String title, title2;

  KeywordItem({this.title, this.title2});

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 4.0, right: 3.0),
          child: Container(
            height: 29.5,
            width: 90.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4.5,
                  spreadRadius: 1.0,
                )
              ],
            ),
            child: Center(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black54, fontFamily: "Sans"),
              ),
            ),
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 15.0)),
        Container(
          height: 29.5,
          width: 90.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4.5,
                spreadRadius: 1.0,
              )
            ],
          ),
          child: Center(
            child: Text(
              title2,
              style: TextStyle(
                color: Colors.black54,
                fontFamily: "Sans",
              ),
            ),
          ),
        ),
      ],
    );
  }
}

///Favorite Item Card
class FavoriteItem extends StatelessWidget {
  String image, Rating, Salary, title, sale;

  FavoriteItem({this.image, this.Rating, this.Salary, this.title, this.sale});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 2.0),
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
                  height: 120.0,
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

class DropdownWidget extends StatefulWidget {
  List _menuItemlist;
  Function _onChange;
  String _title;
  String _hintText;
  String selectedValue;

  DropdownWidget({Key key}) : super(key: key) {}

  DropdownWidget.Custom(
      {List list,
      Function onChange,
      String title,
      String hintText,
      String selectedValue}) {
    _menuItemlist = list;
    _onChange = onChange;
    _title = title;
    _hintText = hintText;
  }

  @override
  _DropdownWidgetState createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 20.0, top: 20.0),
          child: Text(
            widget._title,
            style: TextStyle(fontFamily: "Gotik", color: Colors.black26),
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 20.0)),
        DropdownButton<String>(
          isExpanded: true,
          onChanged: (value) {
            setState(() {
              widget.selectedValue = value;
              widget._onChange;
            });
          },
          hint: Text(widget._hintText),
          value: widget.selectedValue,
          items: widget._menuItemlist,
          // items: <String>['بيع', 'شراء', 'مزاد']
          //     .map<DropdownMenuItem<String>>((String value) {
          //   return DropdownMenuItem(
          //     child: Text(value),
          //     value: value,
          //   );
          // }).toList(),
        )
      ],
    );
  }
}
