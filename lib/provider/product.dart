import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id, title, description, imageUrl;
  final double price;
  bool isFavourite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.imageUrl,
      @required this.price,
      this.isFavourite = false});

  void toggleFavouriteStatus(String token,String userId) async {
    final oldStatus = isFavourite;

    final url = "https://first-api-b1c56.firebaseio.com/userFavourites/$userId/$id.json?auth=$token";
    isFavourite = !isFavourite;
    notifyListeners();
    var responses =
        await http.put(url, body: json.encode(isFavourite));

    if (responses.statusCode >= 400) isFavourite = oldStatus;
    notifyListeners();
  }
}
