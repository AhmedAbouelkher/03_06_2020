import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:haftaa/bloc/product-bloc.dart';
import 'package:haftaa/product/auction-product.dart';
import 'package:haftaa/product/product-provider.dart';
import 'package:haftaa/product/request-product.dart';
import 'package:haftaa/product/sale-product.dart';
import 'package:haftaa/ui/HomeUIComponent/advanced-search.dart';
import 'package:haftaa/ui/widgets/loading.dart';
import 'package:haftaa/product/base-product.dart';
import 'package:haftaa/search/search.dart';
import 'package:haftaa/ui/widgets/product/auction-product-itemGrid.dart';
import 'package:haftaa/ui/widgets/product/request-product-itemGrid.dart';
import 'package:haftaa/ui/widgets/product/sale-product-itemGrid.dart';
import 'package:provider/provider.dart';

class ProductListWidget extends StatefulWidget {
  //Future<List<BaseProduct>> _productsFuture;
  //ProductController productController =ProductController();
  void Function(ProductSearchModel) onSearchPopup;
  ProductSearchModel searchModel;
  String pageTitle;
  String titleQuery;
  ProductBloc _productBloc;

  ProductListWidget(
      {this.searchModel,
      this.pageTitle,
      this.showCategoriesSlider,
      this.titleQuery,
      this.onSearchPopup}) {
    _productBloc =
        new ProductBloc(searchModel: searchModel, startLoadingWithCount: -1);
  }

  bool showCategoriesSlider = true;

  ProductListWidget.Search(this.searchModel, this.pageTitle,
      {this.showCategoriesSlider}) {
    _productBloc =
        new ProductBloc(searchModel: searchModel, startLoadingWithCount: -1);
  }

  @override
  _ProductListWidgetState createState() => _ProductListWidgetState();
}

class _ProductListWidgetState extends State<ProductListWidget> {
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
    widget._productBloc.dispose();
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
    var list = Provider.of<ProductProvider>(context).productList;

    var column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              InkWell(
                onTap: _modalBottomSheetSort,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Icon(Icons.arrow_drop_down),
                    Padding(padding: EdgeInsets.only(right: 10.0)),
                    Text(
                      "رتب",
                      style: _fontCostumSheetBotomHeader,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    height: 45.9,
                    width: 1.0,
                    decoration: BoxDecoration(color: Colors.black12),
                  )
                ],
              ),
              InkWell(
                onTap: () async {
                  //Navigator.pop(context);
                  var searchModel = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdvancedSearch()),
                  );
                  widget.searchModel = searchModel;
                  widget.onSearchPopup(searchModel);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Icon(Icons.blur_on),
                    Padding(padding: EdgeInsets.only(right: 0.0)),
                    Text(
                      "خيارات البحث",
                      style: _fontCostumSheetBotomHeader,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
            child: Container(
          child: Column(
            children: <Widget>[
              // (widget.showCategoriesSlider == null || widget.showCategoriesSlider)
              //     ? CategoryListOneRow(widget._searchModel == null
              //         ? ""
              //         : (widget._searchModel.CategoryID == null
              //             ? ""
              //             : widget._searchModel.CategoryID))
              //     : Container(),

              GridView.count(
                  shrinkWrap: true,
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 17.0,
                  childAspectRatio: 0.545,
                  crossAxisCount: 2,
                  primary: false,
                  children: List.generate(list.length, (index) {
                    if (list[index] is SaleProduct) {
                      return SaleProductItemGrid(list[index]);
                    } else if (list[index] is AuctionProduct) {
                      return AuctionProductItemGrid(list[index]);
                    } else if (list[index] is RequestProduct) {
                      return RequestProductItemGrid(list[index]);
                    } else {
                      return Center(child: Text('يوجد عنصر غير متطابق'));
                    }
                  })),
            ],
          ),
        )),
      ],
    );

    return SingleChildScrollView(child: column);
  }
}
