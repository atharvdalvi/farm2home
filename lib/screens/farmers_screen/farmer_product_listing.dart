import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm2home/screens/farmers_screen/update_product_detail_screen.dart';
import 'package:farm2home/widgets/farmer_navigation_drawer.dart';
import 'package:flutter/material.dart';

class FarmerProductListing extends StatelessWidget {
  final userid;

  FarmerProductListing(this.userid);

  @override
  Widget build(BuildContext context) {
    void _updatedetials(final productid, final userid) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => UpdateProductDetailScreen(
            productid,
            userid,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Image.asset(
          'assets/images/logo.png',
          width: 150,
        ),
      ),
      drawer: FarmerNavigationDrawer(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('products')
            .where('userid', isEqualTo: userid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          return Padding(
            padding: const EdgeInsets.only(top: 20.0, right: 10, left: 10),
            child: ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          snapshot.data.docs[index]['imageUrl'],
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.fill,
                        ),
                        Text(
                          snapshot.data.docs[index]['product'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                        Text(
                          "Quality: " + snapshot.data.docs[index]['quality'],
                        ),
                        Text(
                          "Quantity available: " +
                              snapshot.data.docs[index]['quantity'],
                        ),
                        Text(
                          "₹ " + snapshot.data.docs[index]['price'] + " per kg",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          "Description: " +
                              snapshot.data.docs[index]['description'],
                        ),
                        Divider(),
                        Container(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                child: Text(
                                  "Update Details",
                                  style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  _updatedetials(
                                      snapshot.data.docs[index]['id'],
                                      snapshot.data.docs[index]['userid']);
                                },
                              ),
                              VerticalDivider(),
                              TextButton(
                                child: Text(
                                  "Delete Product",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  AlertDialog alert = AlertDialog(
                                    title: Text('Alert'),
                                    content: Text(
                                        'Are sure you want to delete product?'),
                                    actions: [
                                      FlatButton(
                                        child: Text(
                                          "Delete",
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                        onPressed: () {
                                          FirebaseFirestore.instance
                                              .collection('products')
                                              .doc(snapshot.data.docs[index]
                                                  ['id'])
                                              .delete();

                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  FarmerProductListing(userid),
                                            ),
                                          );
                                        },
                                      ),
                                      FlatButton(
                                        child: Text("Cancel"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return alert;
                                    },
                                  );
                                },
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
