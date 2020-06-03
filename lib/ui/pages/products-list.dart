import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:haftaa/bloc/product-bloc.dart';
import 'package:haftaa/product/auction-product.dart';
import 'package:haftaa/product/request-product.dart';
import 'package:haftaa/product/sale-product.dart';
import 'package:haftaa/ui/HomeUIComponent/advanced-search.dart';
import 'package:haftaa/ui/widgets/loading.dart';
import 'package:haftaa/product/base-product.dart';
import 'package:haftaa/search/search.dart';
import 'package:haftaa/ui/widgets/no-data.dart';
import 'package:haftaa/ui/widgets/product/auction-product-itemGrid.dart';
import 'package:haftaa/ui/widgets/product/product-list-widget.dart';
import 'package:haftaa/ui/widgets/product/request-product-itemGrid.dart';
import 'package:haftaa/ui/widgets/product/sale-product-itemGrid.dart';

class ProductList extends StatefulWidget {
  //Future<List<BaseProduct>> _productsFuture;
  //ProductController productController =ProductController();
  ProductSearchModel searchModel;
  String pageTitle;
  String titleQuery;
  // ProductBloc _productBloc;
  ProductList(
      {this.searchModel,
        this.pageTitle,
        this.showCategoriesSlider,
        this.titleQuery}) {
    // _productBloc =
    //     new ProductBloc(searchModel: searchModel, startLoadingWithCount: -1);
  }
  bool showCategoriesSlider = true;
  ProductList.Search(this.searchModel, this.pageTitle,
      {this.showCategoriesSlider}) {
    // _productBloc =
    //     new ProductBloc(searchModel: searchModel, startLoadingWithCount: -1);
  }

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  // var grid;

  // var _search = Container(
  //     height: 50.0,
  //     decoration: BoxDecoration(
  //         color: Colors.white,
  //         border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1.0)),
  //     child: Padding(
  //       padding: const EdgeInsets.only(left: 20.0),
  //       child: Theme(
  //         data: ThemeData(hintColor: Colors.transparent),
  //         child: TextFormField(
  //           decoration: InputDecoration(
  //               border: InputBorder.none,
  //               icon: Icon(
  //                 Icons.search,
  //                 color: Colors.black38,
  //                 size: 18.0,
  //               ),
  //               hintText: "Search Items Promotion",
  //               hintStyle: TextStyle(color: Colors.black38, fontSize: 14.0)),
  //         ),
  //       ),
  //     ));
  @override
  dispose() {
    super.dispose();
    // widget._productBloc.dispose();
  }

  List<BaseProduct> list;
  final _fontCostumSheetBotomHeader = TextStyle(
      fontFamily: "Berlin",
      color: Colors.black54,
      fontWeight: FontWeight.w600,
      fontSize: 16.0);
  final _fontCostumSheetBotom = TextStyle(
      fontFamily: "Sans",
      color: Colors.black45,
      fontWeight: FontWeight.w400,
      fontSize: 16.0);

  /// Create Modal BottomSheet (SortBy)
  void _modalBottomSheetSort() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return SingleChildScrollView(
            child: new Container(
              height: 320.0,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 20.0)),
                  Text("رتب بـ", style: _fontCostumSheetBotomHeader),
                  Padding(padding: EdgeInsets.only(top: 20.0)),
                  Container(
                    width: 500.0,
                    color: Colors.black26,
                    height: 0.5,
                  ),
                  Padding(padding: EdgeInsets.only(top: 25.0)),
                  InkWell(
                      onTap: () {
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (BuildContext context) => new Menu()));
                      },
                      child: Text(
                        "الأحدث",
                        style: _fontCostumSheetBotom,
                      )),
                  Padding(padding: EdgeInsets.only(top: 25.0)),
                  Text(
                    "الأقل سعرا",
                    style: _fontCostumSheetBotom,
                  ),
                  Padding(padding: EdgeInsets.only(top: 25.0)),
                  Text(
                    "الأعلى سعرا",
                    style: _fontCostumSheetBotom,
                  ),
                  // Padding(padding: EdgeInsets.only(top: 25.0)),
                  // Text(
                  //   "Price: High-Low",
                  //   style: _fontCostumSheetBotom,
                  // ),
                  // Padding(padding: EdgeInsets.only(top: 25.0)),
                  // Text(
                  //   "Price: Log-High",
                  //   style: _fontCostumSheetBotom,
                  // ),
                  Padding(padding: EdgeInsets.only(top: 25.0)),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.pageTitle ?? '',
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16.0,
              color: Colors.black54,
              fontFamily: "Gotik"),
        ),
        iconTheme: IconThemeData(color: Color(0xFF6991C7)),
        elevation: 0.0,
      ),
      body: ProductListWidget(
        searchModel: widget.searchModel,
        showCategoriesSlider: widget.showCategoriesSlider,
      ),
    );
  }
}
