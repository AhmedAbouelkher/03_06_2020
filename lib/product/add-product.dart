import 'package:flutter/material.dart';
import 'package:haftaa/product/product-controller.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController _productTitleController = TextEditingController();

  ProductController productController = ProductController();
  final _formKey = GlobalKey<FormState>();




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('add product'),
      ),
      body: Container(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text('Add Product'),
                TextFormField(
                  controller: _productTitleController,
                  decoration: InputDecoration(hintText: 'عنوان المنتج'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'sfd fds fdsf dsf';
                    }
                    return null;
                  },
                ),
                RaisedButton(
                  child: Text('Add'),
                  onPressed: () async {
                    await productController.getProducts();

                    // if (_formKey.currentState.validate()) {
                    //   await productController
                    //       .addProductToFirebase(_productTitleController.text);
                    //   // If the form is valid, display a snackbar. In the real world,
                    //   // you'd often call a server or save the information in a database.

                    //   // Scaffold.of(context).showSnackBar(
                    //   //     SnackBar(content: Text('Processing Data')));

                    // }
                  },
                ),
                ListView(
                  
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _productTitleController.dispose();
    super.dispose();
  }
}
