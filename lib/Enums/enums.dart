enum ProductStatus { stillNew, used }
enum AuctionStatus { open, closed }

enum FirebaseDBCollections { news, users, menuItems }

enum ItemType { sale, request, auction }

T getEnumFromString<T>(Iterable<T> values, String value) {
  return values.firstWhere((type) => type.toString().split(".").last == value,
      orElse: () => null);
}
