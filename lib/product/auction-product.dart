import 'package:firebase_database/firebase_database.dart';
import 'package:haftaa/Enums/enums.dart';
import 'package:haftaa/product/auction-bidding.dart';
import 'package:haftaa/product/base-product.dart';

class AuctionProduct extends BaseProduct {
  double _startPrice;
  DateTime _endDate;
  int _finalPeriodHours;
  AuctionStatus _status;
  String _winnerUserId;
  int _auctionClosesAfterLastPostInHours;
  int _defaultAuctionItemDaysPeriod;
  double _theFirstPostMustBeMoreThanPercentage;
  List<AuctionBidding> _biddings = List<AuctionBidding>();

  List<AuctionBidding> get biddings => _biddings;
  double get startPrice => _startPrice;
  DateTime get endDate => _endDate;
  int get finalPeriodHours => _finalPeriodHours;
  AuctionStatus get status => _status;
  String get winnerUserId => _winnerUserId;
  int get auctionClosesAfterLastPostInHours =>
      _auctionClosesAfterLastPostInHours;
  int get defaultAuctionItemDaysPeriod => _defaultAuctionItemDaysPeriod;
  double get theFirstPostMustBeMoreThanPercentage =>
      _theFirstPostMustBeMoreThanPercentage;

  AuctionProduct.fromMap(dynamic key, Map mapedData)
      : super.fromMap(key, mapedData) {
    if (mapedData['options'] != null) {
      _startPrice = mapedData['options']['startPrice'] == null
          ? 0.0
          : double.parse(mapedData['options']['startPrice'].toString());

      _endDate = mapedData['options']['endDate'] == null
          ? null
          : DateTime.parse(mapedData['options']['endDate']);

      _finalPeriodHours = mapedData['options']['finalPeriodHours'] == null
          ? null
          : int.parse(mapedData['options']['finalPeriodHours'].toString());

      switch (mapedData['options']['status'].toString()) {
        case 'open':
          _status = AuctionStatus.open;
          break;
        case 'closed':
          _status = AuctionStatus.closed;
          break;
        default:
      }

      _winnerUserId = mapedData['options']['winnerUserId'] == null
          ? null
          : mapedData['options']['winnerUserId'].toString();

      _auctionClosesAfterLastPostInHours = mapedData['options']
      ['auctionClosesAfterLastPostInHours'] is int
          ? int.parse(mapedData['options']['auctionClosesAfterLastPostInHours']
          .toString())
          : null;
      _defaultAuctionItemDaysPeriod = mapedData['options']
      ['defaultAuctionItemDaysPeriod'] is int
          ? int.parse(
          mapedData['options']['defaultAuctionItemDaysPeriod'].toString())
          : null;
      _theFirstPostMustBeMoreThanPercentage = (mapedData['options']
      ['theFirstPostMustBeMoreThanPercentage'] is int ||
          mapedData['options']['theFirstPostMustBeMoreThanPercentage']
          is double)
          ? double.parse(mapedData['options']
      ['theFirstPostMustBeMoreThanPercentage']
          .toString())
          : null;
//todo: create User object and get it here
    }

    if (mapedData['biddings'] != null) {
      //todo fill _biddings list
      final Map data = mapedData['biddings'];
      _biddings = data.entries.map<AuctionBidding>((mapItem) {
        return AuctionBidding.fromMap(mapItem.key, mapItem.value);
      }).toList();

    }
  }

  AuctionProduct.fromSnapshot(DataSnapshot snapshot)
      : super.fromSnapshot(snapshot) {
    if (snapshot.value['options'] != null) {
      _startPrice = snapshot.value['options']['startPrice'] == null
          ? 0.0
          : double.parse(snapshot.value['options']['startPrice'].toString());

      _endDate = snapshot.value['options']['endDate'] == null
          ? null
          : DateTime.parse(snapshot.value['options']['endDate']);

      _finalPeriodHours = snapshot.value['options']['finalPeriodHours'] == null
          ? null
          : int.parse(snapshot.value['options']['finalPeriodHours'].toString());

      switch (snapshot.value['options']['status'].toString()) {
        case 'open':
          _status = AuctionStatus.open;
          break;
        case 'closed':
          _status = AuctionStatus.closed;
          break;
        default:
      }

      _winnerUserId = snapshot.value['options']['winnerUserId'] == null
          ? null
          : snapshot.value['options']['winnerUserId'].toString();

      _auctionClosesAfterLastPostInHours =
      snapshot.value['options']['auctionClosesAfterLastPostInHours'] is int
          ? int.parse(snapshot.value['options']
      ['auctionClosesAfterLastPostInHours']
          .toString())
          : null;
      _defaultAuctionItemDaysPeriod = snapshot.value['options']
      ['defaultAuctionItemDaysPeriod'] is int
          ? int.parse(snapshot.value['options']['defaultAuctionItemDaysPeriod']
          .toString())
          : null;

      _theFirstPostMustBeMoreThanPercentage = (snapshot.value['options']
      ['theFirstPostMustBeMoreThanPercentage'] is int ||
          snapshot.value['options']['theFirstPostMustBeMoreThanPercentage']
          is double)
          ? double.parse(snapshot.value['options']
      ['theFirstPostMustBeMoreThanPercentage']
          .toString())
          : null;
//todo: create User object and get it here
    }
    if (snapshot.value['biddings'] != null) {
      var biddings = snapshot.value['biddings'] as Map;
      _biddings = biddings.entries.map((biddingMap) {
        return AuctionBidding.fromMap(biddingMap.key, biddingMap.value);
      }).toList();
    }
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> optionsContent = {
      'startPrice': startPrice,
      'status': _status == AuctionStatus.open
          ? 'open'
          : (_status == AuctionStatus.closed ? 'closed' : null),
      'auctionClosesAfterLastPostInHours': auctionClosesAfterLastPostInHours,
      'defaultAuctionItemDaysPeriod': defaultAuctionItemDaysPeriod,
      'theFirstPostMustBeMoreThanPercentage':
      theFirstPostMustBeMoreThanPercentage
    };
    Map<String, dynamic> productJson = super.toJson();
    productJson['options'] = optionsContent;

    return productJson;
  }
}
