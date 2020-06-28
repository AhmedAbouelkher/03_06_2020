import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:haftaa/product/base-product.dart';

class ProductReviews extends StatefulWidget {
  final BaseProduct product;
  ProductReviews(this.product);
  @override
  _ProductReviewsState createState() => _ProductReviewsState();
}

class _ProductReviewsState extends State<ProductReviews> {
  double rating = 3.5;
  int starCount = 5;
  static var _subHeaderCustomStyle = TextStyle(
      color: Colors.black54,
      fontWeight: FontWeight.w700,
      fontFamily: "Gotik",
      fontSize: 16.0);

  /// Custom Text for Detail title
  static var _detailText = TextStyle(
      fontFamily: "Gotik",
      color: Colors.black54,
      letterSpacing: 0.3,
      wordSpacing: 0.5);

  Widget _line(){
    return  Container(
      height: 0.9,
      width: double.infinity,
      color: Colors.black12,
    );
  }
  @override
  Widget build(BuildContext context) {

    //widget.product.getProductComments();

    return   Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        height:415.0,
        width: 600.0,
        decoration:
        BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: Color(0xFF656565).withOpacity(0.15),
            blurRadius: 1.0,
            spreadRadius: 0.2,
          )
        ]),
        child: Padding(
          padding: EdgeInsets.only(top: 20.0,left: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Reviews',style: _subHeaderCustomStyle,),
                  Padding(
                    padding: const EdgeInsets.only(left:20.0,top: 15.0,bottom: 15.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                          child: Padding(
                              padding:EdgeInsets.only(top:2.0,right: 3.0),
                              child: Text('View All',style: _subHeaderCustomStyle.copyWith(color: Colors.indigoAccent,fontSize: 14.0),)),
                          onTap: () {
//                            Navigator.of(context).push(PageRouteBuilder(pageBuilder: (_,__,___)=>ReviewsAll()));
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0,top: 2.0),
                          child: Icon(Icons.arrow_forward_ios,size: 18.0,color: Colors.black54,),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        StarRating(
                          size: 25.0,
                          starCount: 5,
                          rating: 4.0,
                          color: Colors.yellow,
                        ),
                        SizedBox(width: 5.0),
                        Text('8 Reviews')
                      ]),
                ],
              ),
              Padding(padding: EdgeInsets.only(left: 0.0,right: 20.0,top: 15.0,bottom: 7.0),
                child: _line(),
              ),
              _buildRating('18 Nov 2018',
                  'Item delivered in good condition. I will recommend to other buyer.',
                      (rating) {
                    setState(() {
                      this.rating = rating;
                    });
                  },
                  "assets/avatars/avatar-1.jpg"
              ),
              Padding(padding: EdgeInsets.only(left: 0.0,right: 20.0,top: 15.0,bottom: 7.0),
                child: _line(),
              ),
              _buildRating('18 Nov 2018',
                  'Item delivered in good condition. I will recommend to other buyer.',
                      (rating) {
                    setState(() {
                      this.rating = rating;
                    });
                  },
                  "assets/avatars/avatar-4.jpg"
              ),
              Padding(padding: EdgeInsets.only(left: 0.0,right: 20.0,top: 15.0,bottom: 7.0),
                child: _line(),
              ),
              _buildRating('18 Nov 2018',
                  'Item delivered in good condition. I will recommend to other buyer.',
                      (rating) {
                    setState(() {
                      this.rating = rating;
                    });
                  },
                  "assets/avatars/avatar-2.jpg"
              ),
              Padding(padding: EdgeInsets.only(bottom: 20.0)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRating(String date, String details, Function changeRating,String image) {
    return ListTile(
      leading: Container(
        height: 45.0,
        width: 45.0,
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(image),fit: BoxFit.cover),
            borderRadius: BorderRadius.all(Radius.circular(50.0))
        ),
      ),
      title: Row(
        children: <Widget>[
          StarRating(
              size: 20.0,
              rating: 3.5,
              starCount: 5,
              color: Colors.yellow,
              onRatingChanged: changeRating),
          SizedBox(width: 8.0),
          Text(
            date,
            style: TextStyle(fontSize: 12.0),
          )
        ],
      ),
      subtitle: Text(details,style: _detailText,),
    );
  }

}
