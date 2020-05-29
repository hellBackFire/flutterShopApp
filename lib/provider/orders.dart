import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/provider/cart.dart';
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime time;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.time});
}

class Orders with ChangeNotifier {
   final String token,userId;
  List<OrderItem> _order = [];

  Orders(this.token, this.userId);
  List<OrderItem> get orders {
    return [..._order];
  }
 

  Future<void> fetchAndSet() async {

    final url = "https://first-api-b1c56.firebaseio.com/orders/$userId.json?auth=$token";
    var response = await http.get(url);
    
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if(extractedData==null) return;
    extractedData.forEach((orderId, orderData) => {
          loadedOrders.add(OrderItem(
              id: orderId,
              amount: orderData['amount'],
              products: (orderData['products'] as List<dynamic>).map((value) =>
                  CartItem(id: value["id"], title: value["title"], price: value["price"], quantity: value["quantity"])).toList(),
              time: DateTime.parse(orderData['time'])))
        });

        _order=loadedOrders.reversed.toList();
        notifyListeners();
  }

  Future<void> addItem(List<CartItem> cartItem, double total) async {
    final url = "https://first-api-b1c56.firebaseio.com/orders/$userId.json?auth=$token";
    final date = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'time': date.toIso8601String(),
          'products': cartItem
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price
                  })
              .toList()
        }));
    _order.insert(
        0,
        OrderItem(
            id: json.decode(response.body)["name"],
            amount: total,
            products: cartItem,
            time: DateTime.now()));
    notifyListeners();
  }
}
