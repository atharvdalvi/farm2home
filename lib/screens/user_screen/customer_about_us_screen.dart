import 'package:farm2home/providers/cart.dart';
import 'package:farm2home/screens/switch_screen.dart';
import 'package:farm2home/screens/user_screen/cart_screen.dart';
import 'package:farm2home/widgets/batch.dart';
import 'package:farm2home/widgets/customer_navigation_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerAboutUs extends StatelessWidget {
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Center(
                child: Text(
                  'We are pioneers in the tech-driven supply chain \n space for fresh produce',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/Truck.png',
                  fit: BoxFit.fill,
                ),
              ),
              Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Image.asset(
                          'assets/images/idea.png',
                          height: 20,
                          width: 20,
                        ),
                      ),
                      Text(
                        'The problem',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                          '• Farmers experience price risk, information asymmetry about demand, distribution inefficiency, and receive late payments.'),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                          '• Retailers face problems like higher costs, low quality and unhygienic produce, high price volatility, and the everyday hassle of going to the market. '),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                          '• The traditional Supply Chain is highly inefficient, unorganized, and has a high rate of food wastage.'),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Image.asset(
                          'assets/images/solution.png',
                          height: 20,
                          width: 20,
                        ),
                      ),
                      Text(
                        'Our Solution',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                          '• We eliminated intermediaries by taking control of the Supply Chain by using technology and analytics.'),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                          '• We built reliable, cost-effective, and high-speed logistics and infrastructure to solve for inefficiencies in the Supply Chain.'),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                          '• On one end, farmers get better prices and consistent demand, and on the other end, retailers receive fresh produce at competitive prices that are delivered to their doorstep.'),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Wrap(
                  children: [
                    Image.asset('assets/images/roadahead.png'),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'The Road Ahead',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: 500,
                          child: Text(
                            'Our vision is to build India\'s most efficient and largest Supply Chain platform and improve the lives of producers, businesses, and consumers in a meaningful manner.',
                            maxLines: 6,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: 500,
                          child: Text(
                            'We are focused on making the Farmers innovation more accessible to the most fragmented parts of society. We intend to leverage our strengths and resources to innovate for new product categories and customer segments while solving complex supply chain problems.',
                            maxLines: 6,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                color: Colors.grey.withOpacity(0.1),
                width: double.infinity,
                child: Column(
                  children: [
                    Text(
                      'Meet the team',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      'The Founders',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Wrap(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 70,
                                backgroundImage:
                                    AssetImage('assets/images/siddhesh.jpg'),
                              ),
                              Text('Siddhesh Mahadik')
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 70,
                                backgroundImage:
                                    AssetImage('assets/images/onkar.jpeg'),
                              ),
                              Text('Onkar Chaudhari')
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 70,
                                backgroundImage:
                                    AssetImage('assets/images/omkar.jpeg'),
                              ),
                              Text('Omkar Pomendkar'),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
