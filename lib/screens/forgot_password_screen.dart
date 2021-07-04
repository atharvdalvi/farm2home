import 'package:farm2home/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  String email;
  final formkey = GlobalKey<FormState>();
  bool showprogressbar = true;

  @override
  Widget build(BuildContext context) {
    void _forgotpassword() {
      if (formkey.currentState.validate()) {
        formkey.currentState.save();
        showprogressbar = false;
        FirebaseAuth.instance
            .sendPasswordResetEmail(email: email)
            .then((value) {
          Toast.show(
            "Reset link successfully sent to registered email-id",
            context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
          );
          Navigator.of(context).pop(
            MaterialPageRoute(
              builder: (context) => Login(),
            ),
          );
        }).catchError((error) {
          setState(() {
            showprogressbar = true;
          });

          Toast.show(
            'An error occured,Please check credentials!',
            context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
          );
        });
      }
    }

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/bg.jpg'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          automaticallyImplyLeading: false,
          title: Center(
            child: Image.asset(
              'assets/images/logo.png',
              width: 150,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              right: 20,
              left: 20,
              bottom: 30,
              top: 60,
            ),
            child: Center(
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 20,
                    left: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Password assistance',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                          'Enter the email address associated with your Farm2Home account.'),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Emailid',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Form(
                          key: formkey,
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter Email';
                              }
                              if (!value.contains('@')) {
                                return 'Please enter valid Email';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              setState(() {
                                email = value;
                              });
                            },
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: showprogressbar
                            ? RaisedButton(
                                color: Colors.green,
                                child: Text(
                                  'Get password reset link',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  _forgotpassword();
                                },
                              )
                            : Center(
                                child: CircularProgressIndicator(),
                              ),
                      ),
                      SizedBox(
                        height: 50,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
