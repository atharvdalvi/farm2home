import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm2home/providers/cart.dart';
import 'package:farm2home/screens/user_screen/cart_screen.dart';
import 'package:farm2home/screens/user_screen/product_detail_screen.dart';
import 'package:farm2home/widgets/batch.dart';
import 'package:farm2home/widgets/customer_navigation_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Productlist extends StatefulWidget {
  @override
  _ProductlistState createState() => _ProductlistState();
}

class _ProductlistState extends State<Productlist> {
  void productdetail(context, id) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => ProductDetailScreen(id)));
  }

  TextEditingController textEditingController = TextEditingController();
  String searchString;

  @override
  Widget build(BuildContext context) {
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
      backgroundColor: Colors.green[50],
      body: Column(
        children: [
          Container(
            color: Colors.green,
            height: 100,
            padding: EdgeInsets.all(20),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 35,
                  right: 35,
                ),
                child: TextField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                    hintText: 'Search for fruits,vegetables and more',
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchString = value.toLowerCase();
                    });
                  },
                ),
              ),
            ),
          ),
          StreamBuilder(
            stream: (searchString == null || searchString.trim() == ' ')
                ? FirebaseFirestore.instance.collection('products').snapshots()
                : FirebaseFirestore.instance
                    .collection('products')
                    .where('searchindex', arrayContains: searchString)
                    .snapshots(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.none) {
                return Center(
                  child: Text(
                    'No data',
                    style: TextStyle(fontSize: 20),
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      return Container(
                        child: GestureDetector(
                          onTap: () {
                            productdetail(
                                context, snapshot.data.docs[index]['id']);
                          },
                          child: Card(
                            child: Column(
                              children: [
                                Image.network(
                                  snapshot.data.docs[index]['imageUrl'],
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.fill,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  snapshot.data.docs[index]['product'],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "₹ " +
                                      snapshot.data.docs[index]['price'] +
                                      " per kg",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
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
