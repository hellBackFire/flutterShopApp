import "package:flutter/material.dart";
import 'package:shop_app/screen/edit_product_screen.dart';
import '../widgets/app_drawer.dart';
import "../provider/products.dart";
import "package:provider/provider.dart";
import "../widgets/user_product_item.dart";

class UserProductsScreen extends StatelessWidget {
  static const routeName = "/user-products";

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Products"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              })
        ],
      ),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapsot) =>
            snapsot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Products>(
                      builder: (_, products, child) {
                        return Padding(
                          padding: EdgeInsets.all(10),
                          child: ListView.builder(
                            itemCount: products.items.length,
                            itemBuilder: (_, i) {
                              return Column(
                                children: <Widget>[
                                  UserProductItem(
                                      products.items[i].title,
                                      products.items[i].imageUrl,
                                      products.items[i].id),
                                  Divider()
                                ],
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
      ),
      drawer: AppDrawer(),
    );
  }
}
