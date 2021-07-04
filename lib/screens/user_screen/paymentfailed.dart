import 'package:flutter/material.dart';

class PaymentFailed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/redcross.png",
              height: 200,
              width: 200,
            ),
            Text(
              "Payment Failed!!!",
              style: TextStyle(
                color: Colors.red,
                fontSize: 20,
              ),
            )
          ],
        ),
      ),
    );
  }
}
