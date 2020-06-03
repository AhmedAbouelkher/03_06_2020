import 'package:flutter/material.dart';
import 'package:haftaa/bloc/product-bloc.dart';
import 'package:haftaa/product/base-product.dart';
import 'package:haftaa/search/search.dart';
import 'package:haftaa/ui/AcountUIComponent/Profile.dart';
import 'package:haftaa/ui/pages/products-list.dart';
import 'package:haftaa/ui/widgets/category/category-list-dropdown.dart';
import 'package:haftaa/ui/widgets/loading.dart';
import 'package:haftaa/ui/widgets/product/product-list-widget.dart';

class ProductSearch extends SearchDelegate<BaseProduct> {
  ProductBloc _productBloc = new ProductBloc(startLoadingWithCount: -1);

  @override
  dispose() {
    _productBloc.dispose();
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  ProductSearchModel _searchModel;
  @override
  Widget buildResults(BuildContext context) {
    _productBloc.dispose();
    ProductSearchModel search =
        _searchModel ?? ProductSearchModel.FromSearchParams();
    search.title = query;
    return Container(
      child: ProductListWidget(
        searchModel: search,
        titleQuery: query,
        onSearchPopup: (searchModel) {
          _searchModel = searchModel;
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.length < 2) {
      return Center(
        child: Text('ابدأ البحث'),
      );
    }
    return StreamBuilder<List<BaseProduct>>(
      stream: _productBloc.productsObservable,
      builder: (context, AsyncSnapshot<List<BaseProduct>> snapshot) {
        if (snapshot.hasData) {
          final results = snapshot.data.where((product) =>
          (product.title.toLowerCase().contains(query) ||
              product.description.toLowerCase().contains(query)));
          return ListView(
            children: results.map<Widget>((product) {
              return ListTile(
                onTap: () {
                  close(context, product);
                },
                title: Text(product.title),
                leading: Icon(Icons.history),
                subtitle: Text(product.description),
              );
            }).toList(),
          );
        } else {
          return Loading.params(
            loadingText: 'لحظات للتحميل',
          );
        }
      },
    );
  }
}
