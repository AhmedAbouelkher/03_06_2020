import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:haftaa/models/image-file.dart';
import 'package:haftaa/provider/image-provider.dart';
import 'package:haftaa/ui/widgets/big-image-slider.dart';
import 'package:haftaa/ui/widgets/loading.dart';
import 'package:haftaa/ui/widgets/no-data.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class SmallImageSlider extends StatefulWidget {
  List<ImageFile> selectedSliderImages = new List();
  String newImagesDirectoryPath;
  updateImagesDirectoryPath(String value) {
    newImagesDirectoryPath = value;
  }

  Key key;
  SmallImageSlider(
      {this.title,
      this.newImagesDirectoryPath,
      @required this.onSelectImages,
      this.selectedSliderImages,
      this.key})
      : super(key: key) {
    sliderimagesStreamController.add(selectedSliderImages);
    // _sliderImages.add(ImageFile.fromURL(
    //     'https://firebasestorage.googleapis.com/v0/b/haftaa-564d5.appspot.com/o/image.jpg?alt=media&token=2aef381d-841b-4d37-a886-5121f02989d4'));
  }

  String title;
  void Function(List<ImageFile>) onSelectImages;
  @override
  _SmallImageSliderState createState() => _SmallImageSliderState();

  var sliderimagesStreamController = StreamController<List<ImageFile>>();

  Stream<List<ImageFile>> get sliderImageStream =>
      sliderimagesStreamController.stream;

  StreamSink<List<ImageFile>> get sliderImageSink =>
      sliderimagesStreamController.sink;
}

class _SmallImageSliderState extends State<SmallImageSlider> {
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void onAddImageTab() async {
    List<Asset> resultList = await UploadImageProvider.getImageList(5);
    resultList.forEach((asset) {
      widget.selectedSliderImages.add(ImageFile.fromAsset(asset));
    });
    widget.sliderImageSink.add(widget.selectedSliderImages);
    widget.onSelectImages(widget.selectedSliderImages);
    return;

    File file = await _pickImage();
    ImageFile imagefile = ImageFile.fromFile(file);
    widget.selectedSliderImages.add(imagefile);

    widget.sliderImageSink.add(widget.selectedSliderImages);
    // imagefile.imageURL = await _uploadImage(imagefile.imageFileObj,
    //     newImagesDirectoryPath, '${DateTime.now().millisecondsSinceEpoch}.png').catchError((onError){
    //       var dd;
    //     });
  }

  Future<File> _pickImage() async {
    return await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  Future<String> _uploadImage(File imageFile, String directoryPath,
      String uploadedImageFileName) async {
    StorageReference ref = FirebaseStorage.instance
        .ref()
        .child(directoryPath)
        .child(uploadedImageFileName);
    StorageUploadTask uploadTask = ref.putFile(imageFile);
    return await (await uploadTask.onComplete).ref.getDownloadURL();
  }

  var onClickWeekPromotion;

  @override
  Widget build(BuildContext context) {
    onClickWeekPromotion = () async {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BigImageSlider(widget.selectedSliderImages)),
      );

      // After the Selection Screen returns a result, hide any previous snackbars
      // and show the new result.
      setState(() {
        widget.selectedSliderImages = (result as List<ImageFile>);
        if (widget.selectedSliderImages.length == 0) {
          widget.selectedSliderImages
              .add(ImageFile.fromAssetPath("assets/imgItem/mackbook.jpg1"));
        }
        widget.sliderImageSink.add(widget.selectedSliderImages);
      });

      Scaffold.of(context)..removeCurrentSnackBar();
      //..showSnackBar(SnackBar(content: Text("$result")));

      // setState(() {
      //   shouldUpdate ? this._homeData = "updated" : null;
      // });

      // Navigator.of(context).push(PageRouteBuilder(
      //     pageBuilder: (_, __, ___) => new BigImageSlider(_sliderImages),
      //     transitionDuration: Duration(milliseconds: 750),
      //     transitionsBuilder:
      //         (_, Animation<double> animation, __, Widget child) {
      //       return Opacity(
      //         opacity: animation.value,
      //         child: child,
      //       );
      //     }));
    };

    return Container(
      color: Colors.white,
      height: 230.0,
      padding: EdgeInsets.only(bottom: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0, top: 15.0, bottom: 3.0),
              child: InkWell(
                  onTap: onAddImageTab,
                  child: Icon(
                    Icons.add_a_photo,
                    color: Colors.blue,
                    size: 35,
                  ))),
          Expanded(
            child: StreamBuilder<List<ImageFile>>(
              stream: widget.sliderImageStream,
              builder: (context, AsyncSnapshot<List<ImageFile>> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Loading.params(
                      loadingText: 'عرض الصور..',
                    );
                    break;
                  default:
                    if (snapshot.hasError) {
                      return ErrorWidget('هناك خطأ أثناء عرض الصور');
                    } else if (!snapshot.hasData ||
                        (snapshot.hasData && snapshot.data.length == 0)) {
                      return NoData(
                        
                        title: 'قم باختيار صوراً جديدة',
                        imagePaddingTop: 0.0,
                        imageHeight: 70,
                      );
                    } else {
                      List<ImageFile> files = snapshot.data;
                      return ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(top: 10.0),
                        scrollDirection: Axis.horizontal,
                        itemCount: files.length,
                        itemBuilder: (context, position) {
                          return Row(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(left: 10.0)),
                              InkWell(
                                  onTap: onClickWeekPromotion,
                                  child:
                                      ImageFile.getImageWidget(files[position]))
                            ],
                          );
                        },
                      );
                    }
                }
              },
            ),
          ),
          Text(
            widget.selectedSliderImages.length > 0
                ? ''
                : '* اختر صورة واحدة على الأقل',
            style: TextStyle(color: Colors.redAccent.shade700),
          ),
        ],
      ),
    );
  }

  List<Widget> _imageList(List<ImageFile> images) {
    var widgets = <Widget>[];

    // _sliderImages.add(ImageFile(
    //     imageURL:
    //         'https://firebasestorage.googleapis.com/v0/b/haftaa-564d5.appspot.com/o/image.jpg?alt=media&token=2aef381d-841b-4d37-a886-5121f02989d4'));

    widget.selectedSliderImages.forEach((imageFile) {
      widgets.add(Padding(padding: EdgeInsets.only(left: 10.0)));
      widgets.add(InkWell(
          onTap: onClickWeekPromotion,
          child: ImageFile.getImageWidget(imageFile)));
    });

    return widgets;
  }
}
