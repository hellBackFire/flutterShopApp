import 'package:flutter/material.dart';
import 'package:shop_app/provider/auth.dart';
import 'package:shop_app/screen/auth_screen.dart';
import 'package:shop_app/screen/edit_product_screen.dart';
import 'package:shop_app/screen/orders_screen.dart';
import './provider/orders.dart';
import './screen/product_overviewscreen.dart';
import './screen/product_detail.dart';
import './provider/products.dart';
import 'package:provider/provider.dart';
import './provider/cart.dart';
import './screen/cart_screen.dart';
import './screen/user_products_screen.dart';
import "./helpers/custom_route_transition.dart";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (_, auth, products) => Products(auth.token, auth.userId),
        ),
        ChangeNotifierProvider.value(value: Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (_, auth, products) => Orders(auth.token, auth.userId),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MyShop',
          theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
              pageTransitionsTheme: PageTransitionsTheme(builders:{
              TargetPlatform.android:CustomPageTransitionBuilder()
              })),
          home: auth.isAuth
              ? ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.autoLogin(),
                  builder: (ctx, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? Scaffold(
                              body: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : AuthScreen(),
                ),
          routes: {
            ProductDetail.routeName: (ctx) => ProductDetail(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (_) => UserProductsScreen(),
            EditProductScreen.routeName: (_) => EditProductScreen()
          },
        ),
      ),
    );
  }
}
