import 'dart:async';

import 'package:haftaa/locator.dart';
import 'package:haftaa/services/navigation_service.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLinkService {
  final NavigationService _navigationService = locator<NavigationService>();

  Future handleDynamicLinks(
      Function(String) onSuccess, Function(String) onError) async {
    // Get the initial dynamic link if the app is opened with a dynamic link
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    // handle link that has been retrieved
    _handleDeepLink(data);
    if (data == null) {
      onError('no PendingDynamicLinkData');
    }
    // Register a link callback to fire if the app is opened up from the background
    // using a dynamic link.
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      // handle link that has been retrieved
      var title = _handleDeepLink(dynamicLink);
      onSuccess(title);

      var ss;
    }, onError: (OnLinkErrorException e) async {
      print('Link Failed: ${e.message}');
      onError(e.message);
    });
  }

  String _handleDeepLink(PendingDynamicLinkData data) {
    final Uri deepLink = data?.link;
    var title;
    if (deepLink != null) {
      print('_handleDeepLink | deeplink: $deepLink');

      var isAd = deepLink.pathSegments.contains('KPo2');

      if (isAd) {
        title = deepLink.queryParameters['title'];

//        if (title != null) {
//          //get product from db
//
//          //check type
//
//          //navigate to product
//          _navigationService.navigateToPageRoute("onBoarding",
//              arguments: title);
//        }
      }
    }
    return title;
  }

  Future<String> createFirstPostLink(String title) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://filledstacks.page.link',
      link: Uri.parse('https://www.compound.com/post?title=$title'),
      androidParameters: AndroidParameters(
        packageName: 'com.filledstacks.compound',
      ),

      // Other things to add as an example. We don't need it now
      iosParameters: IosParameters(
        bundleId: 'com.example.ios',
        minimumVersion: '1.0.1',
        appStoreId: '123456789',
      ),
      googleAnalyticsParameters: GoogleAnalyticsParameters(
        campaign: 'example-promo',
        medium: 'social',
        source: 'orkut',
      ),
      itunesConnectAnalyticsParameters: ItunesConnectAnalyticsParameters(
        providerToken: '123456',
        campaignToken: 'example-promo',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'Example of a Dynamic Link',
        description: 'This link works whether app is installed or not!',
      ),
    );

    final Uri dynamicUrl = await parameters.buildUrl();

    return dynamicUrl.toString();
  }
}
