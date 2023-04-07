// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'balanc.dart';
import 'chat.dart';
import 'fna.dart';
import 'people.dart';
import 'profile.dart';
import 'trans.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  static var people = [
    {'name': 'Man', 'phone': '1234'}
  ];
  static var business = [
    {'name': 'Man', 'phone': '1234'}
  ];

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var isvisible = true;
  var username = '?';
  var balance = 0;
  var phone = '';

  Future<void> initiatehome() async {
    final prefs = await SharedPreferences.getInstance();
    phone = prefs.getString('phone').toString();

    DatabaseReference ref = FirebaseDatabase.instance
        .ref()
        .child(prefs.getString('phone').toString());

    DatabaseReference refpre = FirebaseDatabase.instance.ref();
    refpre.onValue.listen((event) {
      setState(() {
        if (Home.people.length == 1) {
          for (final child in event.snapshot.children) {
            if (child.child('name').value != null &&
                child.child('phone').value.toString() !=
                    prefs.getString('phone').toString()) {
              Home.people.insert(0, {
                'name': child.child('name').value.toString(),
                'phone': child.child('phone').value.toString()
              });

              if (child.child('phone').value.toString().length <= 4) {
                Home.business.insert(0, {
                  'name': child.child('name').value.toString(),
                  'phone': child.child('phone').value.toString()
                });
              }
            }
          }
        }
      });
    });

    ref.onValue.listen((event) {
      if (mounted) {
        setState(() {
          username = '${event.snapshot.child('name').value} ';
          username = username.substring(0, username.indexOf(' '));
          isvisible = false;
          balance = int.parse(event.snapshot.child('bal').value.toString());
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    initiatehome();
    // _getCameraPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            // Status bar color
            statusBarColor: Color(0xff1f1f1f),
          ),
        ),
      ),
      backgroundColor: Color(0xff1f1f1f),
      bottomSheet: Visibility(
        visible: isvisible,
        child: Container(
          width: double.infinity,
          color: Colors.redAccent,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Connecting...',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => People(),
                            ));
                      },
                      child: Card(
                        elevation: 5,
                        color: Color(0xff2d2e30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 15),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Pay friends and merchants',
                                style: TextStyle(color: Color(0xff7d7e80)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Profile(
                                name: username,
                                phone: phone,
                              ),
                            ));
                      },
                      child: CircleAvatar(
                        child: Text(
                          username[0],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: Image(image: AssetImage('assets/Untitled.png')),
              ),
              SizedBox(
                height: 38,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  mainAxisSpacing: 15,
                  children: [
                    HomeIcon1(
                      icon: Icons.qr_code_scanner,
                      label: 'Scan any\nQR code',
                    ),
                    HomeIcon1(
                      icon: Icons.dialpad,
                      label: 'Pay\ncontacts',
                    ),
                    HomeIcon1(
                      icon: Icons.send_to_mobile_outlined,
                      label: 'Pay phone\nnumber',
                    ),
                    HomeIcon1(
                      icon: Icons.account_balance_outlined,
                      label: 'Bank\ntransfer',
                    ),
                    HomeIcon1(
                      icon: Icons.arrow_outward,
                      label: 'Pay UPI ID\nor number',
                    ),
                    HomeIcon1(
                      icon: Icons.person_outline,
                      label: 'Self\ntransfer',
                    ),
                    HomeIcon1(
                      icon: Icons.receipt_long_outlined,
                      label: 'Pay\nbills',
                    ),
                    HomeIcon1(
                      icon: Icons.mobile_friendly_outlined,
                      label: 'Mobile\nrecharge',
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white70, width: 0.5),
                      borderRadius: BorderRadius.circular(50)),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'UPI(M) ID: $phone@upim',
                          style: TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Icon(
                          Icons.copy_rounded,
                          color: Colors.white70,
                          size: 18,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  children: [
                    Text(
                      'People',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: Home.people.length - 1,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) => HomePeoplePic(
                  person: Home.people[index],
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Businesses',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          )),
                      onPressed: () {
                        Fluttertoast.showToast(
                          msg: 'Not enough businesses in your area',
                          toastLength: Toast.LENGTH_LONG,
                          textColor: Colors.white,
                          backgroundColor: Colors.blue[900],
                        );
                      },
                      child: Row(
                        children: [
                          Icon(Icons.explore_outlined),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Explore')
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: Home.business.length - 1,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) => HomePeoplePic(
                  person: Home.business[index],
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bills, recharges and more',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'No bills due. Try adding these!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                children: [
                  HomeIcon2(icon: Icons.tv, label: 'DTH'),
                  HomeIcon2(
                      icon: Icons.lightbulb_outlined, label: 'Electricity'),
                  HomeIcon2(icon: Icons.car_rental_outlined, label: 'Car'),
                  HomeIcon2(
                      icon: Icons.mobile_friendly_outlined, label: 'Mobile'),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: Colors.blue.shade100,
                      width: 0.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    )),
                onPressed: () {},
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'See all',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  children: [
                    Text(
                      'Promotions',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                children: [
                  HomeIcon3(
                      img: 'assets/undraw_Happy_birthday_re_c16u.png',
                      label: 'Rewards'),
                  HomeIcon3(
                      img: 'assets/undraw_discount_d4bd.png', label: 'Offers'),
                  HomeIcon3(
                      img: 'assets/undraw_Referral_re_0aji.png',
                      label: 'Refferrals'),
                  HomeIcon3(
                      img: 'assets/undraw_Yacht_re_kkai.png', label: 'Live'),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Trans(),
                      ));
                },
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.history,
                            color: Colors.blue,
                          ),
                          SizedBox(
                            width: 25,
                          ),
                          Text(
                            'Show transation history',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 15,
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Balance(
                          balance: balance,
                        ),
                      ));
                },
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.account_balance_outlined,
                            color: Colors.blue,
                          ),
                          SizedBox(
                            width: 25,
                          ),
                          Text(
                            'Check bank balance',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 15,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Stack(
                children: [
                  Container(
                    child: Image.asset('assets/Untitled (1).png'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 45, left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Invite friends',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Invite friends to GPM and get nothing because sharing is caring :)',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'Copy your code',
                              style: TextStyle(color: Colors.white70),
                            ),
                            TextButton(
                                onPressed: () {},
                                child: Row(
                                  children: [
                                    Text(
                                      phone,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Icon(Icons.copy_rounded)
                                  ],
                                ))
                          ],
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: Colors.blue.shade100,
                                width: 0.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              )),
                          onPressed: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Invite',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Text(
                  textAlign: TextAlign.center,
                  'The money used in this app is not real and will not affect your financial estate',
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
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

class HomeIcon1 extends StatelessWidget {
  final icon, label;
  const HomeIcon1({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 12),
            )
          ],
        ),
      ),
    );
  }
}

class HomePeoplePic extends StatelessWidget {
  final Map<String, String> person;
  HomePeoplePic({super.key, required this.person});
  var c = [
    Colors.deepPurple,
    Colors.purple[900],
    Colors.blue[900],
    Colors.indigo[900],
    Colors.green[900],
    Colors.yellow[900],
    Colors.deepOrange,
    Colors.red[900],
    Colors.redAccent[700],
    Colors.greenAccent[700],
    Colors.blueAccent[700],
    Colors.orangeAccent[700],
    Colors.yellowAccent[700],
  ];

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Chat(
                person: person,
              ),
            ));
      },
      child: Container(
        child: Column(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: c[Random().nextInt(c.length)],
              child: Text(
                person['name'].toString()[0],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              maxLines: 1,
              person['name'].toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeIcon2 extends StatelessWidget {
  final icon, label;
  const HomeIcon2({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FNA(),
            ));
      },
      child: Container(
        child: Column(
          children: [
            CircleAvatar(
              radius: 28,
              child: Icon(icon),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeIcon3 extends StatelessWidget {
  final img, label;
  const HomeIcon3({super.key, required this.img, required this.label});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FNA(),
            ));
      },
      child: Container(
        child: Column(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage: AssetImage(img),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
