import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm2home/widgets/farmer_navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FarmerOrderScreen extends StatefulWidget {
  final userid;
  String status = 'status';

  FarmerOrderScreen(this.userid);

  @override
  _FarmerOrderScreenState createState() => _FarmerOrderScreenState();
}

class _FarmerOrderScreenState extends State<FarmerOrderScreen> {
  bool statusdetial = false;

  @override
  Widget build(BuildContext context) {
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
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.all(10),
                child: Card(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        color: Colors.grey[200],
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          snapshot.data.docs[index]['time'],
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
                                              child: Text(
                                                  snapshot.data.docs[index]
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
                                        snapshot.data.docs[index]['orderid']
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
                          i < snapshot.data.docs[index]['products'].length;
                          i++)
                        if (snapshot.data.docs[index]['products'][i]
                                ['sellerid'] ==
                            widget.userid)
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                  snapshot.data.docs[index]['products'][i]
                                      ['image'],
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.fitWidth,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Spacer(),
                                    Text(
                                      snapshot.data.docs[index]['products'][i]
                                          ['status'],
                                      style: TextStyle(
                                        color: snapshot.data.docs[index]
                                                    ['products'][i]['status'] ==
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
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Ordered Quantity: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text((snapshot.data.docs[index]['products']
                                            [i]['quantity'])
                                        .toString())
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Price: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text((snapshot.data.docs[index]['products']
                                            [i]['price'])
                                        .toString())
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Product Total Amount: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      (snapshot.data.docs[index]['products'][i]
                                                  ['quantity'] *
                                              snapshot.data.docs[index]
                                                  ['products'][i]['price'])
                                          .toString(),
                                    )
                                  ],
                                ),
                                Divider(),
                                Center(
                                  child: TextButton(
                                    child: Text(
                                      'Update Order Status',
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        statusdetial = !statusdetial;
                                      });
                                    },
                                  ),
                                ),
                                Divider(),
                                statusdetial
                                    ? FittedBox(
                                        child: Row(
                                          children: [
                                            RaisedButton(
                                                child: Text(
                                                  'Placed',
                                                ),
                                                onPressed: () {
                                                  var object = snapshot.data
                                                      .docs[index]['products'];

                                                  var objectToupdate =
                                                      object[i];

                                                  objectToupdate['status'] =
                                                      'Placed';

                                                  object[i] = objectToupdate;

                                                  final orderid = snapshot.data
                                                      .docs[index]['orderid'];
                                                  FirebaseFirestore.instance
                                                      .collection('orders')
                                                      .doc(orderid)
                                                      .update({
                                                    'products': object,
                                                  });
                                                }),
                                            VerticalDivider(),
                                            RaisedButton(
                                              child: Text(
                                                'Processing',
                                              ),
                                              onPressed: () {
                                                var object = snapshot.data
                                                    .docs[index]['products'];

                                                var objectToupdate = object[i];

                                                objectToupdate['status'] =
                                                    'Processing';

                                                object[i] = objectToupdate;

                                                final orderid = snapshot.data
                                                    .docs[index]['orderid'];
                                                print(object);
                                                FirebaseFirestore.instance
                                                    .collection('orders')
                                                    .doc(orderid)
                                                    .update({
                                                  'products': object,
                                                });
                                              },
                                            ),
                                            VerticalDivider(),
                                            RaisedButton(
                                              child: Text(
                                                'Shipped',
                                              ),
                                              onPressed: () {
                                                var object = snapshot.data
                                                    .docs[index]['products'];

                                                var objectToupdate = object[i];

                                                objectToupdate['status'] =
                                                    'Shipped';

                                                object[i] = objectToupdate;

                                                final orderid = snapshot.data
                                                    .docs[index]['orderid'];
                                                FirebaseFirestore.instance
                                                    .collection('orders')
                                                    .doc(orderid)
                                                    .update({
                                                  'products': object,
                                                });
                                              },
                                            ),
                                            VerticalDivider(),
                                            RaisedButton(
                                              child: Text(
                                                'Delivered',
                                              ),
                                              onPressed: () {
                                                var object = snapshot.data
                                                    .docs[index]['products'];

                                                var objectToupdate = object[i];

                                                objectToupdate['status'] =
                                                    'Delivered';

                                                object[i] = objectToupdate;

                                                final orderid = snapshot.data
                                                    .docs[index]['orderid'];
                                                FirebaseFirestore.instance
                                                    .collection('orders')
                                                    .doc(orderid)
                                                    .update({
                                                  'products': object,
                                                });
                                              },
                                            )
                                          ],
                                        ),
                                      )
                                    : SizedBox(
                                        width: 1,
                                      )
                              ],
                            ),
                          ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
