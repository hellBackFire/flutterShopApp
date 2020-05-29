import 'package:flutter/material.dart';
import '../provider/cart.dart' show Cart;
import 'package:provider/provider.dart';
import '../widgets/cart_item.dart';
import '../provider/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "./cart_screen";
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      "\$${cart.totalAmount.toStringAsFixed(2)}",
                      style: Theme.of(context).textTheme.title,
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart)
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
                itemBuilder: (ctx, index) {
                  var data = cart.items.values.toList()[index];
                  var keymapid = cart.items.keys.toList()[index];
                  return CartItem(
                      data.id, data.title, data.price, data.quantity, keymapid);
                },
                itemCount: cart.itemCount),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading=false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child:_isLoading?CircularProgressIndicator():
          Text("Place Order", style: TextStyle(fontSize: 17.5)),
      onPressed:widget.cart.totalAmount==0 || _isLoading==true?null: () async{
        setState(() {
          _isLoading=true;
        });
       await Provider.of<Orders>(context, listen: false).addItem(
            widget.cart.items.values.toList(), widget.cart.totalAmount);
        widget.cart.clear();
        setState(() {
          _isLoading=false;
        });
      },
      textColor: Theme.of(context).primaryColor,
    );
  }
}
