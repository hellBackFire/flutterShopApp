import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/products.dart';

class ProductDetail extends StatelessWidget {
  static const routeName = './product_detail';

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments as String;
    final item = Provider.of<Products>(context, listen: false).getProduct(id);
    return SafeArea(
      child: Scaffold(
          // appBar: AppBar(
          //   title: Text(item.title),
          // ),
          body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(item.title,style: TextStyle(backgroundColor: Colors.black45),),
              centerTitle: true,
              background: Hero(
                tag: item.id,
                child: Image.network(
                  item.imageUrl,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(
                  height: 10,
                ),
                Text(
                  "₹${item.price}",
                  style: TextStyle(color: Colors.grey, fontSize: 35),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  item.description,
                  style: TextStyle(color: Colors.black87, fontSize: 35),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
                SizedBox(
                  height: 500,
                )
              ],
            ),
          )
        ],
      )),
    );
  }
}
