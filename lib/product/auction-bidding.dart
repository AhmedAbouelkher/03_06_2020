
class AuctionBidding {
  String _id;
  int _biddingValue;
  String _userID;
  DateTime _createdOn;

  int get biddingValue => _biddingValue;
  String get userID => _userID;
  DateTime get createdOn => _createdOn;
  String get ID => _id;

  AuctionBidding.fromMap(dynamic key, Map mapData) {
    _id = key;
    _biddingValue = mapData['biddingValue'];
    _userID = mapData['userID'];
    _createdOn = DateTime.parse(mapData['createdOn'].toString());
  }
}
