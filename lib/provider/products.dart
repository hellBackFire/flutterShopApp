import 'package:flutter/material.dart';
import 'package:shop_app/models/http_exception.dart';
import './product.dart';
import "dart:convert";
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  final String token;
  final String userId;

  List<Product> _items = [];

  Products(this.token, this.userId);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favouriteItems {
    return _items.where((item) {
      return item.isFavourite == true;
    }).toList();
  }
  // void showfavourite() {
  //   _showFavourite = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavourite = false;
  //   notifyListeners();
  // }

  Product getProduct(id) {
    return _items.firstWhere((item) => item.id == id);
  }

  Future<void> addProduct(Product product) async {
    final url =
        "https://first-api-b1c56.firebaseio.com/products.json?auth=$token";
    try {
      final response = await http.post(url,
          body: json.encode({
            "title": product.title,
            "description": product.description,
            "imageUrl": product.imageUrl,
            "price": product.price,
            "creatorId":userId
          }));
      final newProduct = Product(
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
          id: json.decode(response.body)["name"]);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(Product product, String id) async {
    final index = _items.indexWhere((prod) => prod.id == id);
    final url =
        "https://first-api-b1c56.firebaseio.com/products/$id.json?auth=$token";
    await http.patch(url,
        body: json.encode({
          "title": product.title,
          "price": product.price,
          "description": product.description,
          "imageUrl": product.imageUrl
        }));
    _items[index] = product;
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final url =
        "https://first-api-b1c56.firebaseio.com/products/$id.json?auth=$token";

    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false] ) async {
  final filterString=filterByUser?'orderBy="creatorId"&equalTo="$userId"':"";
    final url =
        "https://first-api-b1c56.firebaseio.com/products.json?auth=$token&$filterString";
    try {
     
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
     
      if (extractedData == null) return;
      final favouriteResponse = await http.get(
          "https://first-api-b1c56.firebaseio.com/userFavourites/$userId.json?auth=$token");
      final List<Product> loadedProducts = [];
      final favouriteData = json.decode(favouriteResponse.body);
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
            title: prodData["title"],
            description: prodData["description"],
            id: prodId,
            imageUrl: prodData["imageUrl"],
            price: prodData["price"],
            isFavourite: favouriteData == null
                ? false
                : favouriteData[prodId] ?? false));
      });

      _items = loadedProducts;
   
      notifyListeners();
    } catch (error) {}
  }
}
