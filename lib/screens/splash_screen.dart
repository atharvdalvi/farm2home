import 'dart:async';

import 'package:farm2home/screens/switch_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 5), openLogin);
    super.initState();
  }

  void openLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SwitchScreen(),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Container(
          width: 300,
          child: Image.asset('assets/images/logo.png'),
        ),
      ),
    );
  }
}
