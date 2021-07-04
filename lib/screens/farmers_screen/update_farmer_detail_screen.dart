import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm2home/widgets/farmer_navigation_drawer.dart';
import 'package:flutter/material.dart';

class UpdateFarmerDetailScreen extends StatefulWidget {
  final userid;

  UpdateFarmerDetailScreen(this.userid);

  @override
  _UpdateUserDetailScreenState createState() => _UpdateUserDetailScreenState();
}

class _UpdateUserDetailScreenState extends State<UpdateFarmerDetailScreen> {
  var mobileno;
  var address;
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    void _updatedetails() {
      if (formKey.currentState.validate()) {
        formKey.currentState.save();
        FirebaseFirestore.instance
            .collection('user')
            .doc(widget.userid)
            .update({
          'address': address,
          'mobileno': mobileno,
        });
      }
    }

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
            title: Image.asset(
              'assets/images/logo.png',
              width: 150,
            ),
          ),
          drawer: FarmerNavigationDrawer(),
          backgroundColor: Colors.transparent,
          body: FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('user')
                  .doc(widget.userid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Form(
                              key: formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Your Account',
                                    style: TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Name",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextFormField(
                                    initialValue: snapshot.data['name'],
                                    enabled: false,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "E-mail id",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextFormField(
                                    initialValue: snapshot.data['emailid'],
                                    enabled: false,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Contact no",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextFormField(
                                    initialValue: snapshot.data['mobileno'],
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter valid mobile no';
                                      }
                                      if (value.length < 10) {
                                        return 'Enter valid mobile no';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      setState(() {
                                        mobileno = value;
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Address",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextFormField(
                                    initialValue: snapshot.data['address'],
                                    maxLines: 3,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter valid address';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      address = value;
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width: double.infinity,
                                    child: RaisedButton(
                                      child: Text(
                                        'Update Details',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      color: Colors.green,
                                      onPressed: () {
                                        _updatedetails();
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              })),
    );
  }
}
