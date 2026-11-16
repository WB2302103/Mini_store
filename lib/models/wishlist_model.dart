import 'package:flutter/foundation.dart';
import 'product.dart';

class WishlistModel extends ChangeNotifier {
  final Map<int, Product> _items = {};

  List<Product> get items => _items.values.toList();

  bool isInWishlist(int productId) => _items.containsKey(productId);

  void toggle(Product product) {
    if (_items.containsKey(product.id)) {
      _items.remove(product.id);
    } else {
      _items[product.id] = product;
    }
    notifyListeners();
  }

  void remove(int productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

final WishlistModel wishlist = WishlistModel();
