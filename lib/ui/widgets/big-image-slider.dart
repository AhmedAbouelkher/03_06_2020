import 'package:flutter/material.dart';
import 'package:haftaa/Library/carousel_pro/carousel_pro.dart';
import 'package:haftaa/models/image-file.dart';

class BigImageSlider extends StatefulWidget {
  List<ImageFile> images;
  BigImageSlider(this.images);

  @override
  _BigImageSliderState createState() => _BigImageSliderState();
}

class _BigImageSliderState extends State<BigImageSlider> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('عرض الصور'),
      ),
      body: new Carousel(
        dotColor: Colors.black26,
        dotIncreaseSize: 1.7,
        dotBgColor: Colors.transparent,
        autoplay: false,
        boxFit: BoxFit.cover,
        images: List.generate(widget.images.length, (index) {
          return widget.images[index].pathType != null
              ? Container(
                  color: Colors.blueAccent.shade200,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 100),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height-300,
                          child: ImageFile.getImageWidget(widget.images[index])),
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
                              child: Row(
                                children: <Widget>[
                                  Text('حذف'),
                                  Icon(Icons.close)
                                ],
                              ),
                              onPressed: () {
                                setState(() {
                                  widget.images.remove(widget.images[index]);
                                  //Navigator.pop(context, widget.images);
                                });
                              },
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RaisedButton(
                                child: Row(
                                  children: <Widget>[
                                    Text('جعلها الرئيسية'),
                                    Icon(widget.images[index].isMainImage
                                        ? Icons.star
                                        : Icons.star_border)
                                  ],
                                ),
                                onPressed: () {
                                  setState(() {
                                    widget.images
                                        .where((image) =>
                                            image != widget.images[index])
                                        .forEach((image) {
                                      image.isMainImage = false;
                                    });

                                    widget.images[index].isMainImage =
                                        !widget.images[index].isMainImage;
                                  });
                                },
                              )),
                        ],
                      )
                    ],
                  ))
              : Container();
        }),
        // [
        //   AssetImage("assets/imgItem/mackbook.jpg"),
        //   AssetImage("assets/imgItem/mackbook.jpg"),
        //   AssetImage("assets/imgItem/mackbook.jpg"),
        //   AssetImage("assets/imgItem/mackbook.jpg"),
        //   AssetImage("assets/imgItem/mackbook.jpg"),
        // ],
      ),
    );
  }
}
