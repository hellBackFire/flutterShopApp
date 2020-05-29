import 'dart:math';
import 'package:flutter/material.dart';
import '../provider/orders.dart' as ord;
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  const OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(' ₹${widget.order.amount.toStringAsFixed(2)}'),
              subtitle: Text(
                DateFormat('dd/MM/yyyy          hh:mm')
                    .format(widget.order.time),
              ),
              trailing: IconButton(
                  icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  }),
            ),
            AnimatedContainer(
              curve: Curves.easeOutCubic,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red, Colors.blue],
                  ),
                ),
                duration: Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                height: _expanded
                    ? min(widget.order.products.length * 30.0 + 20, 150)
                    : 0,
                child: ListView.builder(
                  itemBuilder: (ctx, index) {
                    var product = widget.order.products[index];
                    return Row(
                      children: <Widget>[
                        Text(
                          product.title,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Text(
                          '₹${product.price.toStringAsFixed(2)}X${product.quantity}',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        )
                      ],
                    );
                  },
                  itemCount: widget.order.products.length,
                ))
          ],
        ));
  }
}
