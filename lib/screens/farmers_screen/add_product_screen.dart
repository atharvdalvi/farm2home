import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:farm2home/screens/farmers_screen/farmer_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;

class AddProductScreen extends StatefulWidget {
  final userid;
  final name;
  final address;
  final contactno;

  AddProductScreen(
    this.userid,
    this.name,
    this.address,
    this.contactno,
  );
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  String name;

  String mobileno;

  String address;
  String product;
  String producttype;
  String quantity;
  String quality;
  String price;
  String description;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController descriptioncontroller = TextEditingController();
  TextEditingController pricecontroller = TextEditingController();
  TextEditingController quantitycontroller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String imagefilename;
  bool isuploading = false;

  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        imagefilename = path.basename(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void addproduct(context) async {
    try {
      if (_image != null) {
        if (producttype != null) {
          if (product != null) {
            if (quality != null) {
              if (formKey.currentState.validate()) {
                formKey.currentState.save();

                setState(() {
                  isuploading = true;
                });

                List<String> indexList = [];
                String ch = '';
                String productsmallcase = product.toLowerCase();

                for (int i = 0; i < product.length; i++) {
                  ch = ch + productsmallcase[i];
                  indexList.add(ch);
                }

                final ref = FirebaseStorage.instance
                    .ref()
                    .child('productimages')
                    .child(imagefilename);

                await ref.putFile(_image);
                final url = await ref.getDownloadURL();

                final firestoreid =
                    FirebaseFirestore.instance.collection('products').doc();

                firestoreid.set(
                  {
                    'name': name,
                    'price': price,
                    'address': address,
                    'mobileno': mobileno,
                    'producttype': producttype,
                    'product': product,
                    'quality': quality,
                    'quantity': quantity,
                    'description': description,
                    'userid': widget.userid,
                    'imageUrl': url.toString(),
                    'id': firestoreid.id,
                    'searchindex': indexList,
                  },
                );
                final snackbar = SnackBar(
                  content: Text('Product Added Sucessfully'),
                  backgroundColor: Colors.green,
                );
                scaffoldKey.currentState.showSnackBar(snackbar);

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => FarmerHomeScreen(),
                  ),
                );
              }
            } else {
              final snackbar = SnackBar(
                content: Text('Please select quality'),
                backgroundColor: Theme.of(context).errorColor,
              );
              scaffoldKey.currentState.showSnackBar(snackbar);
            }
          } else {
            final snackbar = SnackBar(
              content: Text('Please select Product '),
              backgroundColor: Theme.of(context).errorColor,
            );
            scaffoldKey.currentState.showSnackBar(snackbar);
          }
        } else {
          final snackbar = SnackBar(
            content: Text('Please select Product Type'),
            backgroundColor: Theme.of(context).errorColor,
          );
          scaffoldKey.currentState.showSnackBar(snackbar);
        }
      } else {
        final snackbar = SnackBar(
          content: Text('Please add Image'),
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
        key: scaffoldKey,
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              margin: EdgeInsets.all(20),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add Product',
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      FittedBox(
                        child: Row(
                          children: [
                            Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 2,
                                  color: Colors.grey,
                                ),
                              ),
                              child: _image == null
                                  ? Center(
                                      child: Text(
                                        'Please Select Image',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  : Image.file(_image),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: FlatButton.icon(
                                onPressed: getImage,
                                icon: Icon(Icons.camera),
                                label: _image == null
                                    ? Text('Add Image')
                                    : Text('Add Different Image'),
                              ),
                            )
                          ],
                        ),
                      ),
                      Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Name',
                              ),
                              enabled: false,
                              initialValue: widget.name,
                              onSaved: (value) {
                                name = value;
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Address',
                              ),
                              enabled: false,
                              initialValue: widget.address,
                              maxLines: 3,
                              onSaved: (value) {
                                address = value;
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Contact no',
                              ),
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                              enabled: false,
                              initialValue: widget.contactno,
                              onSaved: (value) {
                                mobileno = value;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Product Type',
                            ),
                            Container(
                              width: double.infinity,
                              child: DropdownButton(
                                isExpanded: true,
                                value: producttype,
                                hint: Text(
                                  'Select Product Type',
                                ),
                                items: [
                                  DropdownMenuItem(
                                    child: Text('Dals'),
                                    value: 'Dals',
                                  ),
                                  DropdownMenuItem(
                                    child: Text('Grains'),
                                    value: 'Grains',
                                  ),
                                  DropdownMenuItem(
                                    child: Text('Vegetables'),
                                    value: 'Vegetables',
                                  ),
                                  DropdownMenuItem(
                                    child: Text('Fruits'),
                                    value: 'Fruits',
                                  ),
                                  DropdownMenuItem(
                                    child: Text('Sprouts'),
                                    value: 'Sprouts',
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    producttype = value;
                                  });
                                },
                              ),
                            ),
                            producttype != null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Product',
                                      ),
                                      if (producttype == 'Grains')
                                        Container(
                                          width: double.infinity,
                                          child: DropdownButton(
                                            isExpanded: true,
                                            value: product,
                                            hint: Text(
                                              'Select Product',
                                            ),
                                            items: [
                                              DropdownMenuItem(
                                                child: Text('Wheat'),
                                                value: 'Wheat',
                                              ),
                                              DropdownMenuItem(
                                                child: Text('Maize'),
                                                value: 'Maize',
                                              ),
                                              DropdownMenuItem(
                                                child: Text('Rice'),
                                                value: 'Rice',
                                              ),
                                              DropdownMenuItem(
                                                child: Text('Basmati Rice'),
                                                value: 'Basmati Rice',
                                              ),
                                              DropdownMenuItem(
                                                child: Text('Barley'),
                                                value: 'Barley',
                                              ),
                                              DropdownMenuItem(
                                                child: Text('Oats'),
                                                value: 'Oats',
                                              ),
                                              DropdownMenuItem(
                                                child: Text('Rye'),
                                                value: 'Rye',
                                              ),
                                              DropdownMenuItem(
                                                child: Text('Sorghum'),
                                                value: 'Sorghum',
                                              ),
                                            ],
                                            onChanged: (value) {
                                              setState(() {
                                                product = value;
                                              });
                                            },
                                          ),
                                        ),
                                      if (producttype == 'Vegetables')
                                        Container(
                                          width: double.infinity,
                                          child: DropdownButton(
                                            isExpanded: true,
                                            value: product,
                                            hint: Text(
                                              'Select Product',
                                            ),
                                            items: [
                                              DropdownMenuItem(
                                                child: Text('Onion'),
                                                value: 'Onion',
                                              ),
                                              DropdownMenuItem(
                                                child: Text('Potato '),
                                                value: 'Potato ',
                                              ),
                                              DropdownMenuItem(
                                                child: Text('Tomato'),
                                                value: 'Tomato',
                                              ),
                                              DropdownMenuItem(
                                                child: Text('Mushrooms'),
                                                value: 'Mushrooms',
                                              ),
                                              DropdownMenuItem(
                                                child: Text('Capsicum'),
                                                value: 'Capsicum',
                                              ),
                                              DropdownMenuItem(
                                                child: Text('Ladies Finger '),
                                                value: 'Ladies Finger ',
                                              ),
                                              DropdownMenuItem(
                                                child: Text('Cucumber'),
                                                value: 'Cucumber',
                                              ),
                                              DropdownMenuItem(
                                                child: Text('Cabbage'),
                                                value: 'Cabbage',
                                              ),
                                              DropdownMenuItem(
                                                child: Text('Bitter Gourd'),
                                                value: 'Bitter Gourd',
                                              ),
                                              DropdownMenuItem(
                                                child: Text('Beetroot'),
                                                value: 'Beetroot',
                                              ),
                                              DropdownMenuItem(
                                                child: Text('Lettuce'),
                                                value: 'Lettuce',
                                              ),
                                              DropdownMenuItem(
                                                child: Text('Drum Stick'),
                                                value: 'Drum Stick',
                                              ),
                                              DropdownMenuItem(
                                                child: Text('Ridge Gourd'),
                                                value: 'Ridge Gourd',
                                              ),
                                              DropdownMenuItem(
                                                child: Text('Brinjal'),
                                                value: 'Brinjal',
                                              ),
                                              DropdownMenuItem(
                                                child: Text('Palak'),
                                                value: 'Palak',
                                              ),
                                              DropdownMenuItem(
                                                child: Text('Methi'),
                                                value: 'Methi',
                                              ),
                                              DropdownMenuItem(
                                                child: Text('Garlic'),
                                                value: 'Garlic',
                                              ),
                                            ],
                                            onChanged: (value) {
                                              setState(() {
                                                product = value;
                                              });
                                            },
                                          ),
                                        ),
                                      if (producttype == 'Dals')
                                        Container(
                                          width: double.infinity,
                                          child: DropdownButton(
                                            isExpanded: true,
                                            value: product,
                                            hint: Text(
                                              'Select Product',
                                            ),
                                            items: [
                                              DropdownMenuItem(
                                                child: Text('Toor Dal'),
                                                value: 'Toor Dal',
                                              ),
                                              DropdownMenuItem(
                                                child: Text('Chana Dal'),
                                                value: 'Chana Dal',
                                              ),
                                              DropdownMenuItem(
                                                child: Text('Moong Dal'),
                                                value: 'Moong Dal',
                                              ),
                                              DropdownMenuItem(
                                                child: Text('Masoor Dal'),
                                                value: 'Masoor Dal',
                                              ),
                                              DropdownMenuItem(
                                                child: Text('Urad Dal'),
                                                value: 'Urad Dal',
                                              ),
                                            ],
                                            onChanged: (value) {
                                              setState(() {
                                                product = value;
                                              });
                                            },
                                          ),
                                        ),
                                      if (producttype == 'Fruits')
                                        Container(
                                          width: double.infinity,
                                          child: DropdownButton(
                                            isExpanded: true,
                                            value: product,
                                            hint: Text(
                                              'Select Product',
                                            ),
                                            items: [
                                              DropdownMenuItem(
                                                child: Text('Apple'),
                                                value: 'Apple',
                                              ),
                                              DropdownMenuItem(
                                                child: Text('Pear'),
                                                value: 'Pear',
                                              ),
                                              DropdownMenuItem(
                                                child: Text('Watermelon'),
                                                value: 'Watermelon',
                                              ),
                                              DropdownMenuItem(
                                                child: Text('Pomegranate'),
                                                value: 'Pomegranate',
                                              ),
                                              DropdownMenuItem(
                                                child: Text('Banana'),
                                                value: 'Banana',
                                              ),
                                              DropdownMenuItem(
                                                child: Text('Orange'),
                                                value: 'Orange',
                                              ),
                                              DropdownMenuItem(
                                                child: Text('Tender Coconut'),
                                                value: 'Tender Coconut',
                                              ),
                                              DropdownMenuItem(
                                                child: Text('Kiwi'),
                                                value: 'Kiwi',
                                              ),
                                              DropdownMenuItem(
                                                child: Text('Grapes'),
                                                value: 'Grapes',
                                              ),
                                              DropdownMenuItem(
                                                child: Text('Chikku'),
                                                value: 'Chikku',
                                              ),
                                              DropdownMenuItem(
                                                child: Text('Peach'),
                                                value: 'Peach',
                                              ),
                                            ],
                                            onChanged: (value) {
                                              setState(() {
                                                product = value;
                                              });
                                            },
                                          ),
                                        ),
                                      if (producttype == 'Sprouts')
                                        Container(
                                          width: double.infinity,
                                          child: DropdownButton(
                                            isExpanded: true,
                                            value: product,
                                            hint: Text(
                                              'Select Product',
                                            ),
                                            items: [
                                              DropdownMenuItem(
                                                child: Text('Moong'),
                                                value: 'Moong ',
                                              ),
                                              DropdownMenuItem(
                                                child: Text('Channa'),
                                                value: 'Channa',
                                              ),
                                              DropdownMenuItem(
                                                child: Text('Matki'),
                                                value: 'Matki',
                                              ),
                                              DropdownMenuItem(
                                                child: Text('Rajma'),
                                                value: 'Rajma',
                                              ),
                                              DropdownMenuItem(
                                                child: Text('Vaal'),
                                                value: 'Vaal',
                                              ),
                                              DropdownMenuItem(
                                                child: Text('Chawli'),
                                                value: 'Chawli',
                                              ),
                                            ],
                                            onChanged: (value) {
                                              setState(() {
                                                product = value;
                                              });
                                            },
                                          ),
                                        ),
                                    ],
                                  )
                                : SizedBox(
                                    height: 1,
                                  ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Quality',
                              textAlign: TextAlign.start,
                            ),
                            Container(
                              width: double.infinity,
                              child: DropdownButton(
                                hint: Text('Select Quality'),
                                isExpanded: true,
                                value: quality,
                                items: [
                                  DropdownMenuItem(
                                    child: Text('A1'),
                                    value: 'A1',
                                  ),
                                  DropdownMenuItem(
                                    child: Text('A2'),
                                    value: 'A2',
                                  ),
                                  DropdownMenuItem(
                                    child: Text('A3'),
                                    value: 'A3',
                                  ),
                                  DropdownMenuItem(
                                    child: Text('B1'),
                                    value: 'B1',
                                  ),
                                  DropdownMenuItem(
                                    child: Text('B2'),
                                    value: 'B2',
                                  )
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    quality = value;
                                  });
                                },
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      labelText: 'Quantity (in Kgs)',
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      WhitelistingTextInputFormatter.digitsOnly
                                    ],
                                    controller: quantitycontroller,
                                    onSaved: (value) {
                                      quantity = value;
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter quantity';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Text(
                                  'Kgs',
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text('Price per Kg'),
                            Row(
                              children: [
                                Text('₹'),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      hintText: 'Price per kg',
                                    ),
                                    keyboardType: TextInputType.number,
                                    controller: pricecontroller,
                                    inputFormatters: [
                                      WhitelistingTextInputFormatter.digitsOnly
                                    ],
                                    onSaved: (value) {
                                      price = value;
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter price';
                                      }
                                      return null;
                                    },
                                  ),
                                )
                              ],
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Description',
                              ),
                              maxLines: 3,
                              controller: descriptioncontroller,
                              onSaved: (value) {
                                description = value;
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please Enter Description';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double.infinity,
                        child: isuploading
                            ? Center(
                                child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.green),
                                ),
                              )
                            : RaisedButton(
                                onPressed: () {
                                  addproduct(context);
                                },
                                child: Text(
                                  'Add Product',
                                  style: TextStyle(color: Colors.white),
                                ),
                                color: Colors.green,
                              ),
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
