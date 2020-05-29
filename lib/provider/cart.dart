import 'package:flutter/widgets.dart';

class CartItem {
  final String id, title;
  final double price;
  final int quantity;

  CartItem(
      {@required this.id,
      @required this.title,
      @required this.price,
      @required this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((id, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(String id, String title, double price) {
    if (_items.containsKey(id)) {
      _items.update(
          id,
          (existingitem) => CartItem(
              id: existingitem.id,
              title: existingitem.title,
              price: existingitem.price,
              quantity: existingitem.quantity + 1));
    } else {
      _items.putIfAbsent(
          id,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              quantity: 1));
    }
    notifyListeners();
  }

  void remove(id) {
    _items.remove(id);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void removeSingleItem(id) {
    if (!_items.containsKey(id)) return;
    if (_items[id].quantity > 1)
      _items.update(
          id,
          (existing) => CartItem(
              id: existing.id,
              price: existing.price,
              quantity: existing.quantity - 1,
              title: existing.title));
    if (_items[id].quantity == 1) _items.remove(id);
    notifyListeners();
  }
}
