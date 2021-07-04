import 'package:farm2home/providers/cart.dart';
import 'package:farm2home/screens/user_screen/place_order_screen.dart';
import 'package:farm2home/widgets/customer_navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class CartScreen extends StatelessWidget {
  final userid;

  CartScreen(this.userid);

  @override
  Widget build(BuildContext context) {
    bool isCorrect = true;
    final cart = Provider.of<Cart>(context);
    for (int i = 0; i < cart.itemcart.values.toList().length; i++) {
      if (cart.itemcart.values.toList()[i].quantity >
          cart.itemcart.values.toList()[i].selectedquantity) {
        isCorrect = true;
      } else {
        isCorrect = false;
        break;
      }
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Image.asset(
          'assets/images/logo.png',
          width: 150,
        ),
      ),
      drawer: CustomerNavigationDrawer(),
      body: Container(
        child: Column(
          children: [
            Container(
              height: 80,
              padding: EdgeInsets.all(5),
              child: Card(
                elevation: 10,
                child: FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Chip(
                        label: Text(
                          "₹ " + cart.totalprice.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.green,
                      ),
                      isCorrect
                          ? cart.itemCount == 0
                              ? FlatButton(
                                  onPressed: () {
                                    Toast.show(
                                      'Add products in cart to continue',
                                      context,
                                      duration: 10,
                                    );
                                  },
                                  child: Text(
                                    'Order Now',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              : FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => PlaceOrderScreen(
                                            userid,
                                            cart.itemcart.values.toList(),
                                            cart),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Order Now',
                                    style: TextStyle(
                                      color: Colors.green,
                                    ),
                                  ),
                                )
                          : FlatButton(
                              onPressed: () {},
                              child: Text(
                                'Quantity Error',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                      FlatButton(
                        onPressed: () {
                          cart.clearall();
                        },
                        child: Text(
                          'Remove All',
                          style: TextStyle(
                            color: Theme.of(context).errorColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(10),
                child: ListView.builder(
                  itemCount: cart.itemcart.length,
                  itemBuilder: (ctx, index) {
                    return Card(
                      elevation: 10,
                      color: cart.itemcart.values.toList()[index].quantity <
                              cart.itemcart.values
                                  .toList()[index]
                                  .selectedquantity
                          ? Colors.red[100]
                          : Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              cart.itemcart.values.toList()[index].imageUrl,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.fill,
                            ),
                            Text(
                              cart.itemcart.values.toList()[index].product,
                              style: TextStyle(fontSize: 30),
                            ),
                            Text("Quality: " +
                                cart.itemcart.values.toList()[index].quality),
                            Text("Quantity Available: " +
                                cart.itemcart.values
                                    .toList()[index]
                                    .quantity
                                    .toString() +
                                " Kgs"),
                            Text(
                              "₹ " +
                                  cart.itemcart.values
                                      .toList()[index]
                                      .price
                                      .toString() +
                                  " per kg",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Cart Quantity: ' +
                                  "x " +
                                  cart.itemcart.values
                                      .toList()[index]
                                      .selectedquantity
                                      .toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              'Total: ' +
                                  "₹ " +
                                  (cart.itemcart.values.toList()[index].price *
                                          cart.itemcart.values
                                              .toList()[index]
                                              .selectedquantity)
                                      .toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Text("Seller: " +
                                cart.itemcart.values.toList()[index].name),
                            cart.itemcart.values.toList()[index].quantity <
                                    cart.itemcart.values
                                        .toList()[index]
                                        .selectedquantity
                                ? Text(
                                    'Selected quantity is more than available quantity',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).errorColor,
                                    ),
                                  )
                                : Text(
                                    "Delivery will be done as early as possible",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                            Divider(),
                            TextButton(
                              onPressed: () {
                                cart.clear(
                                    cart.itemcart.values.toList()[index].id);
                              },
                              child: Center(
                                child: Text(
                                  'Remove',
                                  style: TextStyle(
                                      color: Theme.of(context).errorColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
