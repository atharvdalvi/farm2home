import 'package:farm2home/providers/cart.dart';
import 'package:farm2home/screens/user_screen/cart_screen.dart';
import 'package:farm2home/widgets/batch.dart';
import 'package:farm2home/widgets/customer_navigation_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerOrderScreen extends StatelessWidget {
  final userid;

  CustomerOrderScreen(
    this.userid,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Image.asset(
          'assets/images/logo.png',
          width: 150,
        ),
        actions: [
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
              color: Colors.red,
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
              onPressed: () async {
                User user = await FirebaseAuth.instance.currentUser;
                final userid = user.uid;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CartScreen(userid),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      drawer: CustomerNavigationDrawer(),
      backgroundColor: Colors.green[50],
      body: Column(
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('orders')
                .where('userid', isEqualTo: userid)
                .orderBy('time', descending: true)
                .snapshots(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) => Container(
                      margin: EdgeInsets.all(10),
                      child: Card(
                        elevation: 10,
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              color: Colors.grey[200],
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            'Order Placed',
                                            style: TextStyle(fontSize: 11),
                                          ),
                                          Text(
                                            DateFormat.yMMMd().format(
                                              DateTime.parse(
                                                snapshot.data.docs[index]
                                                    ['time'],
                                              ),
                                            ),
                                            style: TextStyle(fontSize: 11),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            "SHIP TO",
                                            style: TextStyle(fontSize: 11),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                snapshot.data.docs[index]
                                                    ['customername'],
                                                style: TextStyle(fontSize: 11),
                                              ),
                                              PopupMenuButton(
                                                icon: Icon(Icons.expand_more),
                                                itemBuilder: (context) => [
                                                  PopupMenuItem(
                                                    child: Text(snapshot
                                                            .data.docs[index]
                                                        ['customeraddress']),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  FittedBox(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              "MODE OF PAYMENT",
                                              style: TextStyle(fontSize: 11),
                                            ),
                                            Text(
                                              snapshot.data.docs[index]
                                                  ['modeofpayment'],
                                              style: TextStyle(fontSize: 11),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "ORDER #",
                                              style: TextStyle(fontSize: 11),
                                            ),
                                            Text(
                                              snapshot
                                                  .data.docs[index]['orderid']
                                                  .toString(),
                                              style: TextStyle(fontSize: 11),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            for (int i = 0;
                                i <
                                    snapshot
                                        .data.docs[index]['products'].length;
                                i++)
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.network(
                                      snapshot.data.docs[index]['products'][i]
                                          ['image'],
                                      width: double.infinity,
                                      height: 200,
                                      fit: BoxFit.fill,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          snapshot.data.docs[index]['products']
                                              [i]['status'],
                                          style: TextStyle(
                                            color: snapshot.data.docs[index]
                                                            ['products'][i]
                                                        ['status'] ==
                                                    'Canceled'
                                                ? Colors.red
                                                : Colors.green,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      snapshot.data.docs[index]['products'][i]
                                          ['productname'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Ordered Quantity : ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          snapshot
                                              .data
                                              .docs[index]['products'][i]
                                                  ['quantity']
                                              .toString(),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Price : ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          snapshot
                                              .data
                                              .docs[index]['products'][i]
                                                  ['price']
                                              .toString(),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Product Total Amount: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          (snapshot.data.docs[index]['products']
                                                      [i]['price'] *
                                                  snapshot.data.docs[index]
                                                          ['products'][i]
                                                      ['quantity'])
                                              .toString(),
                                        )
                                      ],
                                    ),
                                    Divider(),
                                    SizedBox(
                                      width: double.infinity,
                                      child: TextButton(
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(color: Colors.red),
                                          textAlign: TextAlign.center,
                                        ),
                                        onPressed: () {
                                          var object = snapshot.data.docs[index]
                                              ['products'];

                                          var objectToupdate = object[i];

                                          objectToupdate['status'] = 'Canceled';

                                          object[i] = objectToupdate;

                                          final orderid = snapshot
                                              .data.documents[index]['orderid'];
                                          FirebaseFirestore.instance
                                              .collection('orders')
                                              .doc(orderid)
                                              .update({
                                            'products': object,
                                          });
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
