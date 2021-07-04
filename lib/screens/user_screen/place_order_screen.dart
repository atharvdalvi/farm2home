import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm2home/providers/cart.dart';
import 'package:farm2home/screens/farmers_screen/update_farmer_detail_screen.dart';
import 'package:farm2home/screens/user_screen/customer_orders_screen.dart';
import 'package:farm2home/screens/user_screen/order_placed_successfully.dart';
import 'package:farm2home/screens/user_screen/paymentfailed.dart';
import 'package:farm2home/widgets/customer_navigation_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PlaceOrderScreen extends StatefulWidget {
  final userid;
  List<CartItem> cartproducts;
  final cartt;
  PlaceOrderScreen(this.userid, this.cartproducts, this.cartt);
  @override
  _PlaceOrderScreenState createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  bool prodoverview = true;
  bool deladdress = false;
  bool ordersumm = false;
  bool payment = false;
  int totalcartprice = 0;
  String address;
  String customername;
  final razopay = Razorpay();

  @override
  void initState() {
    // TODO: implement initState
    razopay.on(Razorpay.EVENT_PAYMENT_SUCCESS, paySuccess);
    razopay.on(Razorpay.EVENT_EXTERNAL_WALLET, externalWallet);
    razopay.on(Razorpay.EVENT_PAYMENT_ERROR, payError);
    super.initState();
  }

  void orderScreen() async {
    print(
        "We are here +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    User user = await FirebaseAuth.instance.currentUser;
    final userid = user.uid;
    final firestoreid = FirebaseFirestore.instance.collection('orders').doc();
    print(firestoreid.id);
    firestoreid.set(
      {
        "amount": totalcartprice.toString(),
        "modeofpayment": "PrePaid",
        "userid": userid,
        "time": DateTime.now().toIso8601String(),
        "customeraddress": address,
        "customername": customername,
        "orderid": firestoreid.id,
        "products": widget.cartproducts
            .map(
              (cp) => {
                "price": cp.price,
                "quantity": cp.selectedquantity,
                "productname": cp.product,
                "image": cp.imageUrl,
                "productid": cp.id,
                "sellerid": cp.userid,
                "status": "Placed",
              },
            )
            .toList()
      },
    );
    for (int i = 0; i < widget.cartt.itemcart.values.toList().length; i++) {
      int updatedvalue = widget.cartt.itemcart.values.toList()[i].quantity -
          widget.cartt.itemcart.values.toList()[i].selectedquantity;

      FirebaseFirestore.instance
          .collection("products")
          .doc(widget.cartt.itemcart.values.toList()[i].id)
          .update({
        "quantity": updatedvalue.toString(),
      });
    }

    widget.cartt.clearall();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => CustomerOrderScreen(userid),
      ),
      (Route<dynamic> route) => false,
    );
  }

  void paySuccess(PaymentSuccessResponse response) async {
    orderScreen();
  }

  void payError(PaymentFailureResponse response) {
    print(response.message + response.code.toString());
    Navigator.of(context).pop(
      MaterialPageRoute(
        builder: (context) => PaymentFailed(),
      ),
    );
  }

  void externalWallet(ExternalWalletResponse response) {
    print(response.walletName);
  }

  void getPayment() {
    var option = {
      'key': 'rzp_test_9L9pcukBmi6mHh',
      'amount': double.parse(totalcartprice.toString()) * 100,
      "currency": "INR",
      "name": "Farm2Home",
    };

    try {
      razopay.open(option);
    } catch (e) {
      print('error is $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    void _addorder(List<CartItem> cartproducts) async {
      User user = await FirebaseAuth.instance.currentUser;
      final userid = user.uid;

      final map = cartproducts
          .map(
            (cp) => {
              "price": cp.price,
              "quantity": cp.selectedquantity,
              "productname": cp.product,
              "image": cp.imageUrl,
              "productid": cp.id,
              "sellerid": cp.userid,
              "status": "Placed",
            },
          )
          .toList();

      print(map);

      final firestoreid = FirebaseFirestore.instance.collection('orders').doc();
      print(firestoreid.id);
      firestoreid.set(
        {
          "amount": totalcartprice.toString(),
          "modeofpayment": "Cash/Card on Delivery",
          "userid": userid,
          "time": DateTime.now().toIso8601String(),
          "customeraddress": address,
          "customername": customername,
          "orderid": firestoreid.id,
          "products": map,
        },
      );

      for (int i = 0; i < cart.itemcart.values.toList().length; i++) {
        int updatedvalue = cart.itemcart.values.toList()[i].quantity -
            cart.itemcart.values.toList()[i].selectedquantity;

        FirebaseFirestore.instance
            .collection("products")
            .doc(cart.itemcart.values.toList()[i].id)
            .update({
          "quantity": updatedvalue.toString(),
        });
      }

      cart.clearall();

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CustomerOrderScreen(userid),
        ),
      );
    }

    for (int i = 0; i < cart.itemcart.values.toList().length; i++) {
      totalcartprice = totalcartprice +
          (cart.itemcart.values.toList()[i].price *
              cart.itemcart.values.toList()[i].selectedquantity);
      print(totalcartprice);
    }
    final userId = FirebaseAuth.instance.currentUser;
    final userid = userId.uid;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Image.asset(
          'assets/images/logo.png',
          width: 150,
        ),
      ),
      drawer: CustomerNavigationDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('user')
                  .doc(userid)
                  .get(),
              builder: (c, futuresnapshot) {
                if (futuresnapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                Map<String, dynamic> data = futuresnapshot.data.data();
                address = data['address'];
                customername = data['name'];
                print(address);
                return Column(
                  children: [
                    Text(
                      "Order Summary",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: Card(
                        elevation: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Delivery Address',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8.0,
                                top: 8.0,
                              ),
                              child: Text(
                                data['name'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                    left: 8,
                                  ),
                                  width: 200,
                                  child: Text(data['address']),
                                ),
                                FlatButton.icon(
                                  label: Text('Edit Address'),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            UpdateFarmerDetailScreen(userid),
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.green,
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text("+91-" + data['mobileno']),
                            )
                          ],
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: cart.itemcart.length,
                      itemBuilder: (ctx, index) {
                        return Card(
                          child: Row(
                            children: [
                              Image.network(
                                cart.itemcart.values.toList()[index].imageUrl,
                                height: 150,
                                width: 100,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cart.itemcart.values
                                          .toList()[index]
                                          .product,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text("₹ " +
                                        cart.itemcart.values
                                            .toList()[index]
                                            .price
                                            .toString() +
                                        " per kg"),
                                    Text("Total Price: " +
                                        "₹ " +
                                        (cart.itemcart.values
                                                    .toList()[index]
                                                    .price *
                                                cart.itemcart.values
                                                    .toList()[index]
                                                    .selectedquantity)
                                            .toString()),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  trailing: Text("x" +
                                      cart.itemcart.values
                                          .toList()[index]
                                          .selectedquantity
                                          .toString()),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                    Container(
                      child: Card(
                        elevation: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Payment Details",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                ),
                              ),
                            ),
                            ListTile(
                              leading: Text("Price " +
                                  "(" +
                                  cart.itemcart.length.toString() +
                                  " items)"),
                              trailing: Text(totalcartprice.toString()),
                            ),
                            ListTile(
                              leading: Text("Delivery Charges"),
                              trailing: Text(
                                "FREE",
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                            Divider(
                              endIndent: 20,
                              indent: 20,
                            ),
                            ListTile(
                              leading: Text(
                                "Total",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: Text(
                                totalcartprice.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SizedBox(
                                width: double.infinity,
                                child: RaisedButton(
                                  child: Text(
                                    "Pay Online",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  color: Colors.green,
                                  onPressed: () {
                                    getPayment();
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: SizedBox(
                                width: double.infinity,
                                child: RaisedButton(
                                  child: Text(
                                    "Cash/Card On Delivery",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  color: Colors.green,
                                  onPressed: () {
                                    _addorder(cart.itemcart.values.toList());
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
