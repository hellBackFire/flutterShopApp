import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../provider/orders.dart' show Orders;
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = "./orders-screen";
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        builder: (ctx, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          else if (snapShot.error != null) {
            return Center(
              child: Text("error"),
            );
          } else {
            return (Consumer<Orders>(
              builder: (ctx, orderData, _) => ListView.builder(
                itemBuilder: (ctx, index) => OrderItem(orderData.orders[index]),
                itemCount: orderData.orders.length,
              ),
            ));
          }
        },
        future: Provider.of<Orders>(context, listen: false).fetchAndSet(),
      ),
    );
  }
}
