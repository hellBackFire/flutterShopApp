import 'package:flutter/material.dart';
import '../widgets/product_item.dart';
import '../provider/products.dart';
import 'package:provider/provider.dart';

class ProductGrid extends StatelessWidget {
  final showFavs;

  const ProductGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
     
    final productsData = Provider.of<Products>(context);
    final loadedProducts =
        showFavs ? productsData.favouriteItems : productsData.items;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 20),
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: loadedProducts[index],
        child: ProductItem(loadedProducts[index].title,
            loadedProducts[index].id, loadedProducts[index].imageUrl),
      ),
      itemCount: loadedProducts.length,
    );
  }
}
