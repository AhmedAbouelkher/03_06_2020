import 'package:flutter/material.dart';

class aboutApps extends StatefulWidget {
  @override
  _aboutAppsState createState() => _aboutAppsState();
}

class _aboutAppsState extends State<aboutApps> {
  @override
  static var _txtCustomHead = TextStyle(
    color: Colors.black54,
    fontSize: 17.0,
    fontWeight: FontWeight.w600,
    fontFamily: "Gotik",
  );

  static var _txtCustomSub = TextStyle(
    color: Colors.black38,
    fontSize: 15.0,
    fontWeight: FontWeight.w500,
    fontFamily: "Gotik",
  );

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "تطبيقنا تطبيق الهفتاء",
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15.0,
              color: Colors.black54,
              fontFamily: "Gotik"),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Color(0xFF6991C7)),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Divider(
                  height: 0.5,
                  color: Colors.black12,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0, right: 15.0),
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      "assets/launcher/rsz_icon_hourse.png",
                      height: 50.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "سوق الهفتاء",
                            style: _txtCustomSub.copyWith(
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "عروض بيع وشراء ومزادات على كيفك",
                            style: _txtCustomSub,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Divider(
                  height: 0.5,
                  color: Colors.black12,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "أهلا بك. تطبيقنا تطبيق الهفتاء هو سوق إلكتروني مفتوح تقدر من خلالة عرض شيء للبيع أو حتى طلب شيء للشراء "
                  "بالإضافة إلى قسم المزادات. حيث تستطيع عرض شيء للمزاد العلني حيث تستقبل المزايدات والعروض "
                  "يوفر التطبيق ميزة التواصل المباشر بينك وبين الطرف الآخر لتسهيل وتسريع عملية البيع بينكما "
                  "تم بناء التطبيق بأحدث تكنلوجيا وأساليب البرمجة الحديثة التي تضمن سرعة واستقرار وسرية البيانات لأعلى درجة "
                  // "1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with "
                  // "desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
                  ,
                  style: _txtCustomSub,
                  textAlign: TextAlign.justify,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
