import 'package:firebase_database/firebase_database.dart';

class Settings {
  int _auctionClosesAfterLastPostInHours,
      _defaultAuctionItemDaysPeriod,
      _defaultRequestItemDaysPeriod,
      _defaultSaleItemDaysPeriod;
  double _theFirstBiddingPostMustBeMoreThanPercentage;

  int get auctionClosesAfterLastPostInHours =>
      _auctionClosesAfterLastPostInHours;

  int get defaultAuctionItemDaysPeriod => _defaultAuctionItemDaysPeriod;

  double get theFirstBiddingPostMustBeMoreThanPercentage =>
      _theFirstBiddingPostMustBeMoreThanPercentage;

  int get defaultRequestItemDaysPeriod => _defaultRequestItemDaysPeriod;

  int get defaultSaleItemDaysPeriod => _defaultSaleItemDaysPeriod;

  Settings.fromSnapshot(DataSnapshot snapshot) {
    if (snapshot.value['auction'] != null) {
      _auctionClosesAfterLastPostInHours =
          snapshot.value['auction']['auctionClosesAfterLastPostInHours'] is int
              ? int.parse(snapshot.value['auction']
                      ['auctionClosesAfterLastPostInHours']
                  .toString())
              : null;

      _defaultAuctionItemDaysPeriod = snapshot.value['auction']
              ['defaultAuctionItemDaysPeriod'] is int
          ? int.parse(snapshot.value['auction']['defaultAuctionItemDaysPeriod'].toString())
          : null;

      _theFirstBiddingPostMustBeMoreThanPercentage = (snapshot.value['auction']
                  ['theFirstPostMustBeMoreThanPercentage'] is int ||
              snapshot.value['auction']['theFirstPostMustBeMoreThanPercentage']
                  is double)
          ? double.parse(snapshot.value['auction']
                  ['theFirstPostMustBeMoreThanPercentage']
              .toString())
          : null;
    }

    _defaultRequestItemDaysPeriod = snapshot
            .value['defaultRequestItemDaysPeriod'] is int
        ? int.parse(snapshot.value['defaultRequestItemDaysPeriod'].toString())
        : null;

    _defaultSaleItemDaysPeriod =
        snapshot.value['defaultSaleItemDaysPeriod'] is int
            ? int.parse(snapshot.value['defaultSaleItemDaysPeriod'].toString())
            : null;
  }
}
