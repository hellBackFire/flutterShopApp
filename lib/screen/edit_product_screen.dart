import "package:flutter/material.dart";
import "package:provider/provider.dart";
import 'package:shop_app/provider/products.dart';
import "../provider/product.dart";

class EditProductScreen extends StatefulWidget {
  static const routeName = "/editProductScreen";
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _isLoading = false;
  var _isInit = true;
  Map<String, String> _initValues = {
    'title': '',
    'description': '',
    'price': '',
  };
  var _editedProduct =
      Product(id: null, title: "", description: "", imageUrl: "", price: 0);
  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _isInit = false;
      final productId = ModalRoute.of(context).settings.arguments;
      if (productId == null) return null;
      final product = Provider.of<Products>(context).getProduct(productId);
      _editedProduct = product;
      _initValues = {
        'title': _editedProduct.title,
        'description': _editedProduct.description,
        'price': _editedProduct.price.toString(),
      };
      _imageUrlController.text = _editedProduct.imageUrl;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlController.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();

    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (_imageUrlController.text.isEmpty) setState(() {});
      var imageUrl = r'(http(s?):)([/|.|\w|\s|-])*\.(?:jpg|gif|png)';
      var result = RegExp(imageUrl).stringMatch(_imageUrlController.text);
      if (result.toString() == "null") return null;

      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      _form.currentState.save();
      if (_editedProduct.id != null)
       await Provider.of<Products>(context, listen: false)
            .updateProduct(_editedProduct, _editedProduct.id);
      else {
        try {
          await Provider.of<Products>(context, listen: false)
              .addProduct(_editedProduct);
        } catch (error) {
          await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text("An Error Ocurred"),
              content: Text("error"),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text("Okay"))
              ],
            ),
          );
        }
      }
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Item"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.save),
              onPressed: _saveForm,
            )
          ],
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _form,
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        initialValue: _initValues["title"],
                        decoration: InputDecoration(labelText: "title"),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) return "Field Neccessary";
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: value,
                              description: _editedProduct.description,
                              imageUrl: _editedProduct.imageUrl,
                              price: _editedProduct.price,
                              isFavourite: _editedProduct.isFavourite);
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues["price"],
                        decoration: InputDecoration(labelText: "Price"),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) return "Field Neccessary";
                          if (double.tryParse(value) == null)
                            return "Enter A Valid Number";
                          if (double.parse(value) <= 0)
                            return "Enter Price Greater Than 0";
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              imageUrl: _editedProduct.imageUrl,
                              price: double.parse(value),
                              isFavourite: _editedProduct.isFavourite);
                               print(_editedProduct.price);
                        }
                       
                      ),
                      TextFormField(
                        initialValue: _initValues["description"],
                        decoration: InputDecoration(labelText: "Description"),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        validator: (value) {
                          if (value.isEmpty) return "Field Neccessary";
                          if (value.length < 10)
                            return "Description should be greater than 10 words";
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: value,
                              imageUrl: _editedProduct.imageUrl,
                              price: _editedProduct.price,
                              isFavourite: _editedProduct.isFavourite);
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(right: 10, top: 10),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? Text("Enter a Url")
                                : FittedBox(
                                    child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.contain,
                                  )),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: "Image Url"),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _imageUrlFocusNode,
                              onFieldSubmitted: (_) => _saveForm(),
                              validator: (value) {
                                if (value.isEmpty) return "Field Neccessary";
                                var imageUrl =
                                    r'(http(s?):)([/|.|\w|\s|-])*\.(?:jpg|gif|png)';
                                var result =
                                    RegExp(imageUrl).stringMatch(value);
                                if (result.toString() == "null")
                                  return "Wrong Url";

                                return null;
                              },
                              onSaved: (value) {
                                _editedProduct = Product(
                                    id: _editedProduct.id,
                                    title: _editedProduct.title,
                                    description: _editedProduct.description,
                                    imageUrl: value,
                                    price: _editedProduct.price,
                                    isFavourite: _editedProduct.isFavourite);
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ));
  }
}
