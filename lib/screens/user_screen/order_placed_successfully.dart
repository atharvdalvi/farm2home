import 'dart:ui';

import 'package:farm2home/screens/user_screen/customer_home_screen.dart';
import 'package:flutter/material.dart';

class OrderPlacedSuccessfully extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/greentick.gif"),
            Text(
              "Ordered Placed Successfully",
              style: TextStyle(
                fontSize: 20,
                color: Colors.green,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Go to home page",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CustomerHomeScreen(),
                      ),
                    );
                  },
                  child: Text(
                    " Click Here",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 15,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
