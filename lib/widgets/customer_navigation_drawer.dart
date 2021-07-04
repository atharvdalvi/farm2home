import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm2home/screens/login_screen.dart';
import 'package:farm2home/screens/user_screen/customer_home_screen.dart';
import 'package:farm2home/screens/user_screen/customer_orders_screen.dart';
import 'package:farm2home/screens/user_screen/product_list_screen.dart';
import 'package:farm2home/screens/user_screen/update_customer_detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomerNavigationDrawer extends StatelessWidget {
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
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => UpdateCustomerDetailScreen(userId),
                  ));
                },
              ),
              ListTile(
                title: Text(
                  'Home',
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CustomerHomeScreen(),
                  ));
                },
              ),
              ListTile(
                title: Text(
                  'Buy Products',
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Productlist(),
                  ));
                },
              ),
              ListTile(
                title: Text(
                  'Your Orders',
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CustomerOrderScreen(userId),
                  ));
                },
              ),
              ListTile(
                title: Text(
                  'Logout',
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).pop(
                    MaterialPageRoute(
                      builder: (context) => Login(),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
