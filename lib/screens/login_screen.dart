import 'package:farm2home/screens/forgot_password_screen.dart';
import 'package:farm2home/screens/register_screen.dart';
import 'package:farm2home/screens/switch_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class Login extends StatelessWidget {
  String email, password;
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    void login() {
      if (formKey.currentState.validate()) {
        formKey.currentState.save();
        FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password)
            .then((user) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => SwitchScreen(),
            ),
          );
          print('login');
        }).catchError((error) {
          Toast.show(
            'An error occured,Please check credentials!',
            context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
          );
        });
      }
      return;
    }

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
        body: SingleChildScrollView(
            child: Center(
          child: Container(
            margin: EdgeInsets.only(right: 20, left: 20, bottom: 30, top: 60),
            child: Card(
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Login',
                      style:
                          TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter email';
                              }
                              if (!value.contains('@')) {
                                return 'Please enter vaild email';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              email = value;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Password',
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter password';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              password = value;
                            },
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: double.infinity,
                      child: RaisedButton(
                        onPressed: () {
                          login();
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    FittedBox(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ForgotPasswordScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Forgot Password ?',
                              style: TextStyle(fontSize: 15),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    FittedBox(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Don\'t have a account'),
                          FlatButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) => Register()));
                              },
                              child: Text(
                                'Create One',
                                style: TextStyle(color: Colors.green),
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )),
      ),
    );
  }
}
