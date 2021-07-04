import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String name;
  final int price;
  final int quantity;
  final String product;
  final String imageUrl;
  final String quality;
  final int selectedquantity;
  final String userid;

  CartItem({
    @required this.id,
    @required this.name,
    @required this.price,
    @required this.quantity,
    @required this.product,
    @required this.imageUrl,
    @required this.quality,
    @required this.selectedquantity,
    @required this.userid,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _itemcart = {};

  Map<String, CartItem> get itemcart {
    return {..._itemcart};
  }

  double get totalprice {
    double total = 0.0;
    _itemcart.forEach((key, cartitem) {
      return total = total + (cartitem.price * cartitem.selectedquantity);
    });

    return total;
  }

  int get itemCount {
    return _itemcart == null ? 0 : _itemcart.length;
  }

  void clear(String id) {
    _itemcart.remove(id);
    notifyListeners();
  }

  void clearall() {
    _itemcart = {};
    notifyListeners();
  }

  void addItem(String id, String name, int price, int quantity, String product,
      String imageUrl, String quality, int selectedquantity, String userid) {
    if (_itemcart.containsKey(id)) {
      _itemcart.update(
        id,
        (existingcartitem) => CartItem(
          id: id,
          imageUrl: imageUrl,
          name: name,
          price: price,
          product: product,
          quantity: quantity,
          quality: quality,
          userid: userid,
          selectedquantity:
              existingcartitem.selectedquantity + selectedquantity,
        ),
      );
    } else {
      _itemcart.putIfAbsent(
        id,
        () => CartItem(
          id: id,
          imageUrl: imageUrl,
          name: name,
          price: price,
          product: product,
          quantity: quantity,
          quality: quality,
          userid: userid,
          selectedquantity: selectedquantity,
        ),
      );
    }
    notifyListeners();
  }
}
