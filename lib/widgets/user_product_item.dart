import "package:flutter/material.dart";
import 'package:shop_app/provider/products.dart';
import 'package:shop_app/screen/edit_product_screen.dart';
import "package:provider/provider.dart";

class UserProductItem extends StatelessWidget {
  final String title, imageUrl,id;

  const UserProductItem(this.title, this.imageUrl, this.id);
  @override
  
  Widget build(BuildContext context) {
    final scaffold=Scaffold.of(context);
    return ListTile(
        title: Text(title),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        trailing: Container(
          width: 100,
          child: Row(
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.edit),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(EditProductScreen.routeName,arguments:id );
                  }),
              IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).errorColor,
                  ),
                  onPressed: () async{try {
                  await Provider.of<Products>(context, listen: false)
                      .deleteProduct(id);
                } catch (error) {
                  scaffold.showSnackBar(
                    SnackBar(
                      content: Text('Deleting failed!', textAlign: TextAlign.center,),
                    ),
                  );
                } })
            ],
          ),
        ));
  }
}
