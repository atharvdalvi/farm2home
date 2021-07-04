import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm2home/screens/farmers_screen/add_product_screen.dart';
import 'package:farm2home/screens/farmers_screen/farmer_order_screen.dart';
import 'package:farm2home/screens/farmers_screen/farmer_product_listing.dart';
import 'package:farm2home/screens/farmers_screen/update_farmer_detail_screen.dart';
import 'package:farm2home/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FarmerNavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userid = FirebaseAuth.instance.currentUser;
    final userId = userid.uid;
    return Drawer(
      child: FutureBuilder(
        future: FirebaseFirestore.instance.collection('user').doc(userId).get(),
        builder: (c, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            children: [
              Container(
                color: Colors.green,
                padding: EdgeInsets.only(
                  top: 50,
                ),
                width: double.infinity,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/user.png',
                      height: 100,
                    ),
                    Text(
                      snapshot.data['name'],
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      snapshot.data['emailid'],
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Text(
                  'Your Account',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => UpdateFarmerDetailScreen(userId),
                  ));
                },
              ),
              ListTile(
                title: Text(
                  'Add Product',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddProductScreen(
                      userId,
                      snapshot.data['name'],
                      snapshot.data['address'],
                      snapshot.data['mobileno'],
                    ),
                  ));
                },
              ),
              ListTile(
                title: Text(
                  'Your Listings',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FarmerProductListing(userId),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text(
                  'Your Orders',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => FarmerOrderScreen(userId),
                  ));
                },
              ),
              ListTile(
                title: Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).pop(MaterialPageRoute(
                    builder: (context) => Login(),
                  ));
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
