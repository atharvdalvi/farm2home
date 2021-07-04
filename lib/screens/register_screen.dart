import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm2home/screens/switch_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toast/toast.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  var _selection = ['Select One', 'Yes', 'No'];

  var currentselectedItem = 'Select One';
  var formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  String name;
  String email;
  String address;
  String password;
  String mobileno;
  TextEditingController passwordcontroller = TextEditingController();

  void register(ctx) async {
    try {
      if (currentselectedItem != 'Select One') {
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          print('farmers');

          var authResult = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
            email: email,
            password: password,
          )
              .catchError((error) {
            var errorMessage = 'Authentication failed';
            if (error.toString().contains('EMAIL_EXISTS')) {
              errorMessage = 'This email address is already in use.';
            } else if (error.toString().contains('INVALID_EMAIL')) {
              errorMessage = 'This is not a valid email address';
            } else if (error.toString().contains('WEAK_PASSWORD')) {
              errorMessage = 'This password is too weak.';
            } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
              errorMessage = 'Could not find a user with that email.';
            } else if (error.toString().contains('INVALID_PASSWORD')) {
              errorMessage = 'Invalid password.';
            }

            Toast.show(
              errorMessage,
              context,
              duration: Toast.LENGTH_LONG,
              gravity: Toast.BOTTOM,
            );
          });

          FirebaseFirestore.instance
              .collection('user')
              .doc(authResult.user.uid)
              .set({
            'name': name,
            'emailid': email,
            'address': address,
            'isFarmer': currentselectedItem == 'Yes',
            'mobileno': mobileno,
          });

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => SwitchScreen(),
            ),
          );
        }
        return;
      } else {
        print('no farmer');
        final snackbar = SnackBar(
          content: Text('Please select is yo are farmer or not'),
          backgroundColor: Theme.of(context).errorColor,
        );
        scaffoldKey.currentState.showSnackBar(snackbar);
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg.jpg'),
          fit: BoxFit.cover,
        ),
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
        key: scaffoldKey,
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(
                    right: 20,
                    left: 20,
                    bottom: 30,
                    top: 60,
                  ),
                  child: Card(
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Register',
                            style: TextStyle(
                                fontSize: 50, fontWeight: FontWeight.bold),
                          ),
                          Form(
                            key: formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Name',
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter name';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    name = value;
                                  },
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter email';
                                    }
                                    if (!value.contains('@')) {
                                      return 'Please enter proper email';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    email = value;
                                  },
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'MobileNo',
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return ' Please enter mobile no';
                                    }

                                    return null;
                                  },
                                  onSaved: (value) {
                                    mobileno = value;
                                  },
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Address',
                                  ),
                                  maxLines: 4,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return ' Please enter address';
                                    }

                                    return null;
                                  },
                                  onSaved: (value) {
                                    address = value;
                                  },
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                  ),
                                  obscureText: true,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return ' Please enter password';
                                    }
                                    if (value.length < 8) {
                                      return 'Please enter password with bigger length';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    password = value;
                                  },
                                  controller: passwordcontroller,
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Confirm Password',
                                  ),
                                  obscureText: true,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter Password';
                                    }
                                    if (value != passwordcontroller.text) {
                                      return 'Password doesn\'t  match';
                                    }
                                    return null;
                                  },
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: FittedBox(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          'Are You A Farmer ?',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        DropdownButton(
                                            value: currentselectedItem,
                                            items: _selection.map(
                                                (String dropDownSelectedItem) {
                                              return DropdownMenuItem<String>(
                                                value: dropDownSelectedItem,
                                                child:
                                                    Text(dropDownSelectedItem),
                                              );
                                            }).toList(),
                                            onChanged: (String newSelected) {
                                              setState(() {
                                                currentselectedItem =
                                                    newSelected;
                                              });
                                            }),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: double.infinity,
                            child: RaisedButton(
                              onPressed: () {
                                register(context);
                              },
                              child: Text(
                                'Register',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
