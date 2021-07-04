import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm2home/providers/cart.dart';
import 'package:farm2home/screens/user_screen/cart_screen.dart';
import 'package:farm2home/screens/user_screen/product_list_screen.dart';
import 'package:farm2home/widgets/batch.dart';
import 'package:farm2home/widgets/customer_navigation_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class ProductDetailScreen extends StatelessWidget {
  final String id;
  String selectedquantity;
  final formKey = GlobalKey<FormState>();
  ProductDetailScreen(this.id);
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Image.asset(
          'assets/images/logo.png',
          width: 150,
        ),
        actions: [
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
              color: Colors.red,
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
              onPressed: () async {
                User user = await FirebaseAuth.instance.currentUser;
                final userid = user.uid;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CartScreen(userid),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      drawer: CustomerNavigationDrawer(),
      body: Column(
        children: [
          FutureBuilder(
            future:
                FirebaseFirestore.instance.collection('products').doc(id).get(),
            builder: (c, futuresnapshot) {
              if (futuresnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Expanded(
                  child: Scaffold(
                    backgroundColor: Colors.green[50],
                    body: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              color: Colors.green[100],
                              child: Image.network(
                                futuresnapshot.data['imageUrl'],
                                width: double.infinity,
                                height: 300,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              futuresnapshot.data['product'],
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "₹ " + futuresnapshot.data['price'] + " per kg",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Delivery will be done as early as possible",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text("Quality:  " + futuresnapshot.data['quality']),
                            Text("Quantity Available:  " +
                                futuresnapshot.data['quantity'] +
                                " Kgs"),
                            Text("Seller:  " + futuresnapshot.data['name']),
                            Text("Product Type:  " +
                                futuresnapshot.data['producttype']),
                            Text(
                              "Description:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(futuresnapshot.data['description']),
                            FittedBox(
                              child: Row(
                                children: [
                                  Form(
                                    key: formKey,
                                    child: Container(
                                      width: 200,
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                            labelText:
                                                'Add Quantity to buy in kg'),
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          WhitelistingTextInputFormatter
                                              .digitsOnly
                                        ],
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Please Enter Quantity';
                                          }
                                          if (int.parse(value) >
                                              int.parse(futuresnapshot
                                                  .data['quantity'])) {
                                            print(int.parse(value));
                                            print(int.parse(
                                                futuresnapshot.data['price']));
                                            return 'Please enter Valid Quantity';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          selectedquantity = value;
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  FlatButton.icon(
                                    color: Colors.green,
                                    icon: Icon(Icons.shop_sharp,
                                        color: Colors.white),
                                    label: Text(
                                      'Add to Cart',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      if (formKey.currentState.validate()) {
                                        formKey.currentState.save();
                                        cart.addItem(
                                          futuresnapshot.data['id'],
                                          futuresnapshot.data['name'],
                                          int.parse(
                                              futuresnapshot.data['price']),
                                          int.parse(
                                              futuresnapshot.data['quantity']),
                                          futuresnapshot.data['product'],
                                          futuresnapshot.data['imageUrl'],
                                          futuresnapshot.data['quality'],
                                          int.parse(selectedquantity),
                                          futuresnapshot.data['userid'],
                                        );
                                        Toast.show(
                                            "Product successfully added to cart",
                                            context,
                                            duration: 8);
                                      }
                                    },
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
