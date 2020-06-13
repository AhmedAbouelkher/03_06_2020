import 'dart:async';

import 'package:flutter/material.dart';
import 'package:haftaa/Category/BaseCategory.dart';
import 'package:haftaa/Enums/enums.dart';
import 'package:haftaa/governorate/governorate.dart';
import 'package:haftaa/models/image-file.dart';
import 'package:haftaa/product/auction-product.dart';
import 'package:haftaa/product/base-product.dart';
import 'package:haftaa/product/product-controller.dart';
import 'package:haftaa/product/product-provider.dart';
import 'package:haftaa/product/request-product.dart';
import 'package:haftaa/product/sale-product.dart';
import 'package:haftaa/provider/image-provider.dart';
import 'package:haftaa/provider/provider.dart';
import 'package:haftaa/providers/phone_auth.dart';
import 'package:haftaa/region/region.dart';
import 'package:haftaa/settings/settings.dart';
import 'package:haftaa/ui/BottomNavigationBar.dart';
import 'package:haftaa/ui/pages/auction-product-details.dart';
import 'package:haftaa/ui/pages/request-product-details.dart';
import 'package:haftaa/ui/pages/sale-product-details.dart';
import 'package:haftaa/ui/widgets/cannot-edit.dart';
import 'package:haftaa/ui/widgets/category/category-list-dropdown.dart';
import 'package:haftaa/ui/widgets/custom-dropdownbutton.dart';
import 'package:haftaa/ui/widgets/governorate/governorate-list-dropdown.dart';
import 'package:haftaa/ui/widgets/region/RegionDropdownWidget.dart';
import 'package:haftaa/ui/widgets/small-image-slider.dart';
import 'package:haftaa/validation/validators.dart';
import 'package:provider/provider.dart';

class AddProduct extends StatefulWidget {
  BaseProduct product = BaseProduct();

  AddProduct.newOne() {}

  AddProduct.edit(this.product) {
    //smallImageSlider.updateImagesDirectoryPath('products/${this.product.id}');
  }

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  SmallImageSlider get smallImageSlider => SmallImageSlider(
        newImagesDirectoryPath: 'products/${product.id ?? ''}',
        title: 'صور المنتج',
        onSelectImages: (images) => onSelectImages(images),
        selectedSliderImages: this.selectedImages,
      );
  List<ImageFile> selectedImages = List<ImageFile>();

  void onSelectImages(List<ImageFile> images) {
    setState(() {
      selectedImages = images;
    });
    showSnackBar('لا تنسى تحديد الصورة الرئيسية', durationInSeconds: 1);
  }

  BaseProduct product;

  final productStatusKey = GlobalKey();
  ProductController productController = new ProductController();
  Governorate selected_Governorate;

  void onGovernorateSelectChanged(Governorate gov) {
    product.governorateId = gov.id;
    selected_Governorate = gov;
    regionDropdownWidget.loadRegions(gov.id);
  }

  void onGovernorateDeleteSelectedItem() {
    regionDropdownWidget.loadRegions(null);
  }

  BaseCategory selected_category;

  void onCategorySelectChanged(BaseCategory cat) {
    setState(() {
      product.categoryId = cat.id;
      selected_category = cat;
    });
  }

  bool productIsUsed;
  static Region selectedRegion;

  void onRegionSelectChanged(Region region) {
    selectedRegion = region;
  }

  RegionDropdownWidget regionDropdownWidget = RegionDropdownWidget.custom(
    selectedRegion: selectedRegion,
    selectionIsRequired: true,
    hintText: "اختر المنطقة",
    title: "المنطقة",
    onChange: (region) {
      selectedRegion = region;
    },
  );

  final _addProductFormkey = GlobalKey<FormState>();
  var titleTextController = TextEditingController();
  var descTextController = TextEditingController();

  Future<List<ImageFile>> uploadJustNewproductImages(String productid) async {
    Completer<List<ImageFile>> completer = Completer<List<ImageFile>>();
    List<ImageFile> imagesToUpload = selectedImages
        .where((imagefile) => imagefile.pathType == ImagePathType.fileAsset)
        .toList();

    imagesToUpload.forEach((ImageFile imagefile) async {
      var imagedata = imagefile.pathType == ImagePathType.fileAsset
          ? imagefile.FileAsset
          : null;
      await UploadImageProvider.uploadImageAsset(imagedata,
              'products/${productid}', '${DateTime.now().toString()}.png',
              quality: imagefile.isMainImage ? 50 : 90)
          .then((onValue) {
        imagefile.imageURL = onValue.toString();
        if (selectedImages
                .where((imageobj) => imageobj.imageURL == null)
                .length ==
            0) {
          if (!completer.isCompleted) {
            completer.complete(selectedImages);
          }
        }
      }).catchError((onError) {
        if (!completer.isCompleted) {
          completer.completeError(onError);
        }
      });
    });
    if (imagesToUpload.length == 0) {
      if (!completer.isCompleted) {
        completer.complete(selectedImages);
      }
    }
    return completer.future;
  }

  TextEditingController priceEditingController = TextEditingController();
  TextEditingController startPriceEditingController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    product = widget.product;

    dialogTitleStreamController.add('إضافة إعلان');
    if (product != null && product.id != null) {
      loadProductDataForEdit();
    }
  }

  bool _isEditingAvailable() {
    switch (product.type) {
      case ItemType.auction:
        if ((product as AuctionProduct).biddings.length > 0) {
          return false;
        }

        break;
      default:
    }
    return true;
  }

  var productStatuses = <DropdownMenuItem>[
    DropdownMenuItem(
      child: Text('مستعمل'),
      value: true,
    ),
    DropdownMenuItem(
      child: Text('جديد'),
      value: false,
    ),
  ];

  var productTypes = <DropdownMenuItem>[
    DropdownMenuItem(
      child: Text('بيع'),
      value: ItemType.sale,
    ),
    DropdownMenuItem(
      child: Text('شراء'),
      value: ItemType.request,
    ),
  ];

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    productController.dispose();
  }

  Key sliderImagesKey = new Key('sliderimages');

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

  StreamController<String> dialogTitleStreamController =
      StreamController<String>.broadcast();

  Stream<String> get dialogTitleStream => dialogTitleStreamController.stream;

  Sink<String> get dialogTitleSink => dialogTitleStreamController.sink;

  void showDialogLoading(BuildContext context, String loadingText) {
    isSaving = true;
    dialogTitleSink.add(loadingText);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('إضافة إعلان'),
              content: Form(
                onWillPop: () => _prompt(context),
                child: Container(
                  height: 150,
                  child: Column(
                    children: <Widget>[
                      CircularProgressIndicator(),
                      StreamBuilder(
                        stream: dialogTitleStream.asBroadcastStream(),
                        builder: (context, AsyncSnapshot<String> snapshot) {
                          return Text(
                              (snapshot == null || snapshot.data == null)
                                  ? loadingText
                                  : snapshot.data);
                        },
                      ),
                    ],
                  ),
                ),
              ));
        });
  }

  void changeDialogMessage(String message) {
    dialogTitleSink.add(message);
  }

  hideSnackBar(GlobalKey<ScaffoldState> scaffoldkey) {
    scaffoldkey.currentState.hideCurrentSnackBar();
  }

  showError(String errorText, {duationInSeconds}) {
    isSaving = false;
    Navigator.of(context, rootNavigator: true).pop();
    showSnackBar(errorText, durationInSeconds: duationInSeconds ?? 4);
  }

  hideLoadingDialog() {
    Navigator.of(context, rootNavigator: true).pop();
    dialogTitleSink.add('');
    isSaving = false;
  }

  final _scaffoldkey = GlobalKey<ScaffoldState>();
  bool isSaving = false;
  bool gettingProductdataForEditing = false;
  bool checkBoxValue = true;
  List<Map> defaultItemsList = [];

  loadProductDataForEdit() async {
    gettingProductdataForEditing = true;
    selected_category = await product.category;
    await product.governorate.then((gov) {
      selected_Governorate = gov;
      regionDropdownWidget.loadRegions(gov.id,
          defaultSelectedRegionID: product.regionId);
    });

    //special params
    switch (product.type) {
      case ItemType.sale:
        if ((product as SaleProduct).price != null) {
          priceEditingController.text =
              (product as SaleProduct).price.toString();
        }

        break;
      case ItemType.request:
        if ((product as RequestProduct).price != null) {
          priceEditingController.text =
              (product as RequestProduct).price.toString();
        }

        break;
      case ItemType.auction:
        if ((product as AuctionProduct).startPrice != null) {
          startPriceEditingController.text =
              (product as AuctionProduct).startPrice.toString();
        }

        break;
      default:
    }
    productIsUsed = product.used;
    if (product.description != null) {
      descTextController.text = product.description;
    }
    if (product.title != null) {
      titleTextController.text = product.title;
    }
    selectedImages = product.images.map<ImageFile>((imageURL) {
      ImageFile imagefile = ImageFile.fromURL(imageURL);
      imagefile.isMainImage = (imageURL == product.mainImage);
      return imagefile;
    }).toList();
    //await new Future.delayed(Duration(seconds: 2));
    setState(() {
      gettingProductdataForEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isEditingAvailable()) {
      return Scaffold(
        appBar: AppBar(
          leading: InkWell(
              onTap: () {
                Navigator.of(context).pop(false);
              },
              child: Icon(Icons.arrow_back)),
          elevation: 0.0,
          title: Text(
            product.title,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18.0,
                color: Colors.black54,
                fontFamily: "Gotik"),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Color(0xFF6991C7)),
        ),
        body: CannotEdit(
          title: 'لا يمكن التعديل حيث بدأت المزايدات بالفعل على هذا المزاد.',
        ),
//        floatingActionButton: FloatingActionButton(
//          elevation: 0.0,
//          backgroundColor: Colors.blueAccent,
//          foregroundColor: Colors.white,
//
//          child: Icon(Icons.save),
//          onPressed: () => product.id == null
//              ? saveNewProduct(context, _addProductFormkey)
//              : saveExsitedProduct(context, _addProductFormkey),
//
//        ),
      );
    }

    var formContent = SingleChildScrollView(
      child: gettingProductdataForEditing
          ? Container()
          : Container(
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
                child: Column(
                  children: <Widget>[
                    // Text(
                    //   "Where are your ordered items shipped ?",
                    //   style: TextStyle(
                    //       letterSpacing: 0.1,
                    //       fontWeight: FontWeight.w600,
                    //       fontSize: 25.0,
                    //       color: Colors.black54,
                    //       fontFamily: "Gotik"),
                    // ),
                    //Padding(padding: EdgeInsets.only(top: 50.0)),
                    Text(
                      'اختر من مكتبة الصور أو التقط صوراً جديدة',
                      textAlign: TextAlign.right,
                    ),
                    SmallImageSlider(
                      key: sliderImagesKey,
                      newImagesDirectoryPath: 'products/${product.id ?? ''}',
                      title: 'صور المنتج',
                      onSelectImages: (images) => onSelectImages(images),
                      selectedSliderImages: this.selectedImages,
                    ),
                    Padding(padding: EdgeInsets.only(top: 3.0)),

                    CategoriesDropdownWidget.Custom(
                      selectedCategory: selected_category,
                      selectionIsRequired: true,
                      hintText: "اختر القسم",
                      title: "القسم",
                      displayDropDownOnly: false,
                      onChange: (BaseCategory category) =>
                          onCategorySelectChanged(category),
                    ),
                    Padding(padding: EdgeInsets.only(top: 20.0)),
                    GovernorateDropdownWidget.custom(
                      selectedGovernorate: selected_Governorate,
                      selectionIsRequired: true,
                      hintText: "اختر المحافظة",
                      title: "المدينة",
                      onChange: (Governorate governorate) {
                        onGovernorateSelectChanged(governorate);
                      },
                      onDeleteSeelction: () => onGovernorateDeleteSelectedItem,
                    ),

                    regionDropdownWidget,
                    CustomDropdownWidget.Custom(
                      items: productTypes,
                      selectedValue: product.type,
                      validator: (value) => Validators.notNullValue(value,
                          customMessage: 'حدد الغرض من فضلك'),
                      hintText: 'حدد الغرض',
                      title: 'الغرض من الإعلان',
                      selectionIsRequired: true,
                      onChange: (value) {
                        setState(() {
                          product.type = value;
                        });
                      },
                    ),
//                    selected_category?.defaultItems != null &&
//                            (product.type == ItemType.sale ||
//                                product.type == ItemType.request) &&
//                            selected_category.defaultItems['price'] == true
//                        ? Container(
//                            child: Column(
//                              children: <Widget>[
//                                Padding(padding: EdgeInsets.only(top: 3.0)),
//                                TextFormField(
//                                  keyboardType: TextInputType.number,
//                                  controller: priceEditingController,
//                                  decoration: InputDecoration(
//                                      labelText: "السعر",
//                                      hintText: "السعر",
//                                      hintStyle:
//                                          TextStyle(color: Colors.black54)),
//                                  validator: (d) => Validators.valueNotLessZero(
//                                    d,
//                                  ),
//                                )
//                              ],
//                            ),
//                          )
//                        : new Container(),

//                    selected_category != null &&
//                            selected_category.defaultItems['used'] == true
//                        ? CustomDropdownWidget.Custom(
//                            items: productStatuses,
//                            selectedValue: productIsUsed,
//                            validator: (value) => Validators.notNullValue(value,
//                                customMessage: 'حدد الحالة من فضلك'),
//                            hintText: 'الحالة',
//                            title: 'حالة المنتج',
//                            selectionIsRequired: true,
//                            onChange: (value) {
//                              setState(() {
//                                productIsUsed = value;
//                              });
//                            },
//                          )
//                        : new Container(),

                    CheckboxListTile(
                      title: Text("أظهر رقم جوالي بصفحة هذا الإعلان"),
                      value: checkBoxValue,
                      onChanged: (bool newValue) {
                        setState(() {
                          checkBoxValue = newValue;
                        });
                      },
                      controlAffinity: ListTileControlAffinity
                          .leading, //  <-- leading Checkbox
                    ),

                    Padding(padding: EdgeInsets.only(top: 10.0)),
                    TextFormField(
                      controller: titleTextController,
                      // onChanged: (value) {
                      //   setState(() {
                      //   product.title = value;
                      //   });

                      // },
                      decoration: InputDecoration(
                          labelText: "عنوان الإعلان",
                          hintText: "إسم الإعلان",
                          hintStyle: TextStyle(color: Colors.black54)),
                      validator: (d) => Validators.notEmptyText(d,
                          customMessage: 'أدخل عنوان الإعلان'),
                    ),
                    Padding(padding: EdgeInsets.only(top: 20.0)),
                    TextFormField(
                      controller: descTextController,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          labelText: "الوصف",
                          hintText: "الوصف",
                          hintStyle: TextStyle(color: Colors.black54)),
                      validator: (value) => Validators.notEmptyText(value),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10.0)),

                    InkWell(
                      onTap: () => product.id == null
                          ? saveNewProduct(context, _addProductFormkey)
                          : saveExsitedProduct(context, _addProductFormkey),
                      child: Container(
                        height: 55.0,
                        width: 300.0,
                        decoration: BoxDecoration(
                            color: Colors.indigoAccent,
                            borderRadius:
                                BorderRadius.all(Radius.circular(40.0))),
                        child: Center(
                          child: Text(
                            "إضافة الإعلان",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16.5,
                                letterSpacing: 1.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    )
                  ],
                ),
              ),
            ),
    );

    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.of(context).pop(false);
            },
            child: Icon(Icons.arrow_back)),
        elevation: 0.0,
        title: Text(
          "إضافة إعلان",
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18.0,
              color: Colors.black54,
              fontFamily: "Gotik"),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Color(0xFF6991C7)),
      ),
      body: Form(
        key: _addProductFormkey,
        child: formContent,
        onWillPop: () => _prompt(context),
      ),
    );
  }

  Future<bool> _prompt(BuildContext context) {
    Completer<bool> ss = new Completer<bool>();

    ss.complete(isSaving ? false : true);
    return ss.future;
    return showDialog(
          context: context,
          child: new AlertDialog(
            title: new Text('إغلاق'),
            content: new Text('من فضلك انتظر حتى انتهاء العملية'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('حسناً'),
              ),
              // new FlatButton(
              //   onPressed: () => Navigator.of(context).pop(false),
              //   child: new Text('Yes'),
              // ),
            ],
          ),
        ) ??
        false;
  }

  navigateToProductPage() {
    var page;
    switch (product.type) {
      case ItemType.sale:
        page = new SaleProductDetails(product, widget.product.user);
        break;
      case ItemType.request:
        page = new RequestProductDetails(product);
        break;
      case ItemType.auction:
        page = new AuctionProductDetails(product);
        break;
      default:
    }
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => bottomNavigationBar()),
      ModalRoute.withName('/'),
    );
  }

  saveExsitedProduct(BuildContext context, GlobalKey formkey) async {
    //check if user loged in
    if (Provider.of<PhoneAuthDataProvider>(context, listen: false).isLoggedIn !=
        true) {
      showSnackBar('سجل دخول من فضلك');
      return;
    }

    //validate data
    if (!_addProductFormkey.currentState.validate() ||
        selectedImages.length <= 0) {
      showSnackBar('راجع البيانات من فضلك', durationInSeconds: 2);

      return;
    }
    if (selectedImages.where((image) => image.isMainImage == true).length <=
        0) {
      showSnackBar('من فضلك حدد الصورة الرئيسية', durationInSeconds: 1);
      return;
    }

//collection data in Map variable

    //create object based on product type
    switch (product.type) {
      case ItemType.sale:
        product = SaleProduct.fromMap(
            product.id, await getProductobjectFromFormData(false));
        break;
      case ItemType.request:
        product = RequestProduct.fromMap(
            product.id, await getProductobjectFromFormData(false));
        break;
      case ItemType.auction:
        product = AuctionProduct.fromMap(
            product.id, await getProductobjectFromFormData(false));
        break;
    }
    showDialogLoading(context, 'جاري تعديل الإعلان...');
    productController.update(product).then((v) async {
      await new Future.delayed(const Duration(seconds: 2));
      changeDialogMessage('جاري رفع الصور...');

      uploadJustNewproductImages(product.id)
          .then((imageListAfterUploading) async {
        await new Future.delayed(const Duration(seconds: 2));
        product.images = imageListAfterUploading.map<String>((f) {
          return f.imageURL;
        }).toList();

        //update product images

        changeDialogMessage('جاري حفظ الصور..');

        productController
            .updateproductImages(product.id, product.images)
            .then((onValue) async {
          await new Future.delayed(const Duration(seconds: 2));
          //update main image URL
          if (selectedImages
                  .where((image) => image.isMainImage == true)
                  .length >
              0) {
            changeDialogMessage('جاري إنهاء العملية...');

            productController
                .updateProductMainImage(
                    product.id,
                    selectedImages
                        .where((image) => image.isMainImage == true)
                        .first
                        .imageURL)
                .then((onValue) async {
              await new Future.delayed(const Duration(seconds: 2));
              product.mainImage = selectedImages
                  .where((image) => image.isMainImage == true)
                  .first
                  .imageURL;
              //done and show success message
              await new Future.delayed(const Duration(seconds: 2));
              dialogTitleSink.add('تم تعديل الإعلان بنجاح');
              showSnackBar('تم تعديل الإعلان بنجاح', durationInSeconds: 5);
              await new Future.delayed(const Duration(seconds: 2));
              hideLoadingDialog();
              navigateToProductPage();
            }).catchError((updateProductMainImageError) {
              showError('حدث خطأ أثناء حفظ الصورة الرئيسية .');
              //show error in main image update
            });
          } else {
            //success final message
            dialogTitleSink.add('تم تعديل الإعلان بنجاح');
            await new Future.delayed(const Duration(seconds: 2));
            showSnackBar('تم تعديل الإعلان بنجاح', durationInSeconds: 5);
            hideLoadingDialog();
            navigateToProductPage();
          }
        }).catchError((updateproductImagesError) {
          //error message
          showError('حدث خطأ أثناء حفظ الصور .');
        });
      }).catchError((uploadimagesError) {
        showError('حدث خطأ أثناء رفع الصور ${uploadimagesError.message ?? ''}');
      });
    }).catchError((addProductError) {
      //show error message
      showError('حدث خطأ أثناء تعديل الإعلان.');
    });
  }

  Future<Map> getProductobjectFromFormData(bool newProduct) async {
    Completer<Map> completer = Completer<Map>();
    Map productMap = Map();
    //collection data in Map variable
    productMap['title'] = titleTextController.text;
    productMap['categoryId'] = selected_category.id;
    productMap['governorateId'] = selected_Governorate.id;
    productMap['description'] = descTextController.text;
    productMap['regionID'] = regionDropdownWidget.selectedRegion.Id;
    productMap['available'] = true;
    productMap['used'] = productIsUsed;
    productMap['showMobileNumber'] = checkBoxValue;
    var nowTime = DateTime.now();
    if (newProduct) {
      productMap['userId'] =
          Provider.of<PhoneAuthDataProvider>(context, listen: false).user.uid;
      productMap['creationDate'] = nowTime.toUtc();
    } else {
      productMap['userId'] = product.userId;
      productMap['updateDate'] = nowTime.toUtc();
    }

    //create object based on product type
    switch (product.type) {
      case ItemType.sale:
        productMap['options'] = {
          'price': 0
         //'price': double.parse(priceEditingController.text)
        };
        productMap['type'] = 'sale';
        completer.complete(productMap);
        break;
      case ItemType.request:
        productMap['options'] = {
          'price': double.parse(priceEditingController.value.text)
        };
        productMap['type'] = 'request';
        completer.complete(productMap);
        break;
      case ItemType.auction:
        Settings settings =
            await Provider.of<ProductProvider>(context).settings;
        productMap['options'] = {
          'startPrice': double.parse(startPriceEditingController.value.text),
          'status': 'open',
          'auctionClosesAfterLastPostInHours':
              settings.auctionClosesAfterLastPostInHours,
          'defaultAuctionItemDaysPeriod': settings.defaultAuctionItemDaysPeriod,
          'theFirstPostMustBeMoreThanPercentage':
              settings.theFirstBiddingPostMustBeMoreThanPercentage
        };
        productMap['type'] = 'auction';
        completer.complete(productMap);
        break;
    }

    return completer.future;
  }

  saveNewProduct(BuildContext context, GlobalKey formkey) async {
    //set the user id
    if (Provider.of<PhoneAuthDataProvider>(context, listen: false).isLoggedIn !=
        true) {
      showSnackBar('سجل دخول من فضلك');
      return;
    }

//     Provider.of(context).auth.currentUser().then((User user) {
//       if (user == null) {
//         //show message not authenticate

//       } else {}
//     }).catchError((onError) {
//       var d;
// //show error message
//     });

    if (!_addProductFormkey.currentState.validate() ||
        selectedImages.length <= 0) {
      showSnackBar('راجع البيانات من فضلك', durationInSeconds: 2);

      return;
    }
    if (selectedImages.where((image) => image.isMainImage == true).length <=
        0) {
      showSnackBar('من فضلك حدد الصورة الرئيسية', durationInSeconds: 1);
      return;
    }

//collection data in Map variable

    //create object based on product type
    switch (product.type) {
      case ItemType.sale:
        product =
            SaleProduct.fromMap(null, await getProductobjectFromFormData(true));
        break;
      case ItemType.request:
        product = RequestProduct.fromMap(
            null, await getProductobjectFromFormData(true));
        break;
      case ItemType.auction:
        product = AuctionProduct.fromMap(
            null, await getProductobjectFromFormData(true));
        break;
    }

    //insert the basic data of the product
    showDialogLoading(context, 'جاري إضافة الإعلان...');

    productController.addProduct(product).then((newProductkey) async {
      await new Future.delayed(const Duration(seconds: 2));
      //get the new id
      setState(() {
        product.id = newProductkey;
      });

      changeDialogMessage('جاري رفع الصور...');
      await new Future.delayed(const Duration(seconds: 2));
      uploadJustNewproductImages(newProductkey)
          .then((imageListAfterUploading) async {
        product.images = imageListAfterUploading.map<String>((f) {
          return f.imageURL;
        }).toList();

        //update product images

        changeDialogMessage('جاري حفظ الصور..');
        await new Future.delayed(const Duration(seconds: 2));
        productController
            .updateproductImages(product.id, product.images)
            .then((onValue) async {
          //update main image URL
          if (selectedImages
                  .where((image) => image.isMainImage == true)
                  .length >
              0) {
            changeDialogMessage('جاري إنهاء العملية...');
            await new Future.delayed(const Duration(seconds: 2));
            productController
                .updateProductMainImage(
                    product.id,
                    selectedImages
                        .where((image) => image.isMainImage == true)
                        .first
                        .imageURL)
                .then((onValue) async {
              product.mainImage = selectedImages
                  .where((image) => image.isMainImage == true)
                  .first
                  .imageURL;
              //done and show success message
              await new Future.delayed(const Duration(seconds: 2));
              dialogTitleSink.add('تمت إضافة الإعلان بنجاح');
              showSnackBar('تمت إضافة الإعلان بنجاح', durationInSeconds: 5);
              await new Future.delayed(const Duration(seconds: 2));
              hideLoadingDialog();
              navigateToProductPage();
            }).catchError((updateProductMainImageError) {
              showError('حدث خطأ أثناء حفظ الصورة الرئيسية .');
              //show error in main image update
            });
          } else {
            //success final message
            dialogTitleSink.add('تمت إضافة الإعلان بنجاح');
            await new Future.delayed(const Duration(seconds: 2));
            showSnackBar('تمت إضافة الإعلان بنجاح', durationInSeconds: 5);
            hideLoadingDialog();
            navigateToProductPage();
          }
        }).catchError((updateproductImagesError) {
          //error message
          showError('حدث خطأ أثناء حفظ الصور .');
        });
      }).catchError((uploadimagesError) {
        showError('حدث خطأ أثناء رفع الصور ${uploadimagesError.message ?? ''}');
      });
    }).catchError((addProductError) {
      //show error message
      showError('حدث خطأ أثناء إضافة الإعلان.');
    });

    // Scaffold.of(context).showSnackBar(SnackBar(
    //   content: Text('inserting'),
    // ));

    // Navigator.of(context).pushReplacement(PageRouteBuilder(
    //     pageBuilder: (_, __, ___) => payment()));
  }
}
