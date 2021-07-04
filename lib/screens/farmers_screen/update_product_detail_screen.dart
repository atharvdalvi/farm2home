import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm2home/screens/farmers_screen/farmer_product_listing.dart';
import 'package:farm2home/widgets/farmer_navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UpdateProductDetailScreen extends StatelessWidget {
  final productid;
  final userid;

  UpdateProductDetailScreen(this.productid, this.userid);
  final formKey = GlobalKey<FormState>();
  String price;
  String description;
  String quantity;

  @override
  Widget build(BuildContext context) {
    Future<void> updateData() {
      if (formKey.currentState.validate()) {
        formKey.currentState.save();
        return FirebaseFirestore.instance
            .collection('products')
            .doc(productid)
            .update({
          'quantity': quantity,
          'price': price,
          'description': description,
        }).then((value) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => FarmerProductListing(userid),
          ));
        }).catchError((error) => print("Failed to update user: $error"));
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
      drawer: FarmerNavigationDrawer(),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection("products")
              .doc(productid)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Container(
              width: double.infinity,
              child: Wrap(
                children: [
                  Container(
                    color: Colors.green[50],
                    child: Image.network(
                      snapshot.data['imageUrl'],
                      height: 300,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            snapshot.data['product'],
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "₹ ",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: 200,
                                child: TextFormField(
                                  initialValue: snapshot.data['price'],
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  inputFormatters: [
                                    WhitelistingTextInputFormatter.digitsOnly
                                  ],
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter valid amount';
                                    }
                                    return null;
                                  },
                                  onSaved: (newValue) {
                                    price = newValue;
                                  },
                                ),
                              ),
                              Text(
                                " per kg",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              "Quality: " + snapshot.data['quality'],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              "Seller: " + snapshot.data['name'],
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "Quantity Available: ",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: 100,
                                child: TextFormField(
                                  initialValue: snapshot.data['quantity'],
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  inputFormatters: [
                                    WhitelistingTextInputFormatter.digitsOnly
                                  ],
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter valid quantity';
                                    }
                                    return null;
                                  },
                                  onSaved: (newValue) {
                                    quantity = newValue;
                                  },
                                ),
                              ),
                              Text(
                                "Kgs",
                                style: TextStyle(fontSize: 15),
                              )
                            ],
                          ),
                          Text(
                            "Description:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextFormField(
                            initialValue: snapshot.data['description'],
                            maxLines: 3,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter valid description';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              description = newValue;
                            },
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            width: 500,
                            child: FlatButton(
                              child: Text(
                                "Upadte Details",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              color: Colors.green,
                              onPressed: () {
                                updateData();
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
