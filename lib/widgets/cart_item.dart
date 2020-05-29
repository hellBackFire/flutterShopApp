import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import '../provider/cart.dart';

class CartItem extends StatelessWidget {
  final String id, title, productId;
  final double price;
  final int quantity;

  const CartItem(
      this.id, this.title, this.price, this.quantity, this.productId);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
          padding: EdgeInsets.only(right: 20),
          color: Colors.red,
          alignment: Alignment.centerRight,
          child: Icon(Icons.delete, color: Colors.white, size: 35)),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Are you Sure?"),
            content: Text("Do you really want to delete item"),
            elevation: 5,
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: Text("Yes")),
              FlatButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: Text("No"))
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).remove(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
              leading: CircleAvatar(
                child: Padding(
                    padding: EdgeInsets.all(5),
                    child: AutoSizeText(
                      "₹$price",
                      maxFontSize: 25,
                      minFontSize: 3,
                      softWrap: true,
                    )),
                radius: 30,
              ),
              title: Text(title),
              subtitle: Text("$quantity X ₹$price = ₹${quantity * price}"),
              trailing: Text(
                "$quantity X",
                style: TextStyle(fontSize: 20),
              )),
        ),
      ),
    );
  }
}
