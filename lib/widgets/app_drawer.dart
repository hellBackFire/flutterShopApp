import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/auth.dart';
import 'package:shop_app/screen/orders_screen.dart';
import 'package:shop_app/screen/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text("Have A Good Day"),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
            title: Text("Shop"),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
            title: Text("Orders"),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
            title: Text("Manage Products"),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            onTap: () {
              Provider.of<Auth>(context,listen: false).logout();
            },
            title: Text("Logout "),
          )
        ],
      ),
    );
  }
}
