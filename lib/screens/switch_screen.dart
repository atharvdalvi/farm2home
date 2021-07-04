import 'package:farm2home/screens/farmers_screen/farmer_home_screen.dart';
import 'package:farm2home/screens/user_screen/customer_home_screen.dart';
import 'package:farm2home/screens/user_screen/product_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SwitchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, homeSnapshot) {
              if (homeSnapshot.data != null) {
                if (homeSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  final userid = FirebaseAuth.instance.currentUser;
                  final userId = userid.uid;

                  return FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('user')
                          .doc(userId)
                          .get(),
                      builder: (c, snapshots) {
                        if (snapshots.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          if (snapshots.data['isFarmer']) {
                            return FarmerHomeScreen();
                          } else {
                            return CustomerHomeScreen();
                          }
                        }
                      });
                }
              } else {
                return Login();
              }
            }));
  }
}
