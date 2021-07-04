import 'package:carousel_pro/carousel_pro.dart';
import 'package:farm2home/screens/farmers_screen/farmer_about_us_screen.dart';
import 'package:farm2home/widgets/farmer_navigation_drawer.dart';
import 'package:flutter/material.dart';

class FarmerHomeScreen extends StatelessWidget {
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 250,
                    child: Carousel(
                      boxFit: BoxFit.fill,
                      images: [
                        AssetImage('assets/images/home_farmer.jpg'),
                        AssetImage('assets/images/home_farmer1.jpg'),
                        AssetImage('assets/images/home_farmer2.jpg'),
                      ],
                    ),
                  ),
                  Wrap(
                    children: [
                      Container(
                        width: 400,
                        margin: EdgeInsets.all(50),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'About Us',
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Text(
                              'Farm2Home is India\'s largest Fresh Produce Supply Chain Company. We are pioneers in solving one of the toughest supply chain problems of the world by leveraging innovative technology. We source fresh produce from farmers and deliver them to businesses within 12 hours.',
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            RaisedButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) => FarmerAboutUs()));
                              },
                              child: Text(
                                'Know more',
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Colors.green,
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(50.0),
                        child: Image.asset('assets/images/abtus.png'),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Creating opportunities for everyone',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'We are the first platform enabling increased benefits for farmers and consumers.',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Wrap(
                    children: [
                      Container(
                        width: 350,
                        padding: EdgeInsets.all(30),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/images/farmer.png',
                                  height: 50,
                                  width: 50,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  'Benifits for farmers',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text('• 20% more revenue'),
                                Text('• One-stop-sale'),
                                Text('• Payment in 24 hours'),
                                Text('• Transpert weighing'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 350,
                        padding: EdgeInsets.all(30),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/images/cart.png',
                                  height: 50,
                                  width: 50,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  'Saving for Consumers',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text('• Hygienically handled produce'),
                                Text(
                                    '• 100% traceable to farm - Improves food safety'),
                                Text('• Better Quality'),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
