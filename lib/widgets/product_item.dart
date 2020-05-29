import 'package:flutter/material.dart';
import 'package:shop_app/provider/auth.dart';
import '../provider/cart.dart';
import '../screen/product_detail.dart';
import 'package:provider/provider.dart';
import '../provider/product.dart';

class ProductItem extends StatelessWidget {
  final String title, id, imageUrl;

  const ProductItem(this.title, this.id, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(ProductDetail.routeName, arguments: id);
            },
            child: Hero(
              tag: product.id,
              child: FadeInImage(
                placeholder:
                    AssetImage('assets/images/placeHolder.png'),
                image: NetworkImage(
                  imageUrl,
                ),
                fit: BoxFit.cover,
              ),
            )),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
          leading: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
                icon: Icon(product.isFavourite
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () {
                  product.toggleFavouriteStatus(
                      authData.token, authData.userId);
                },
                color: Theme.of(context).accentColor),
          ),
          trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                cart.addItem(product.id, product.title, product.price);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("Item added succesfully"),
                  action: SnackBarAction(
                      label: "Undo",
                      onPressed: () => {cart.removeSingleItem(product.id)}),
                  duration: Duration(seconds: 2),
                ));
              },
              color: Theme.of(context).accentColor),
        ),
      ),
    );
  }
}
