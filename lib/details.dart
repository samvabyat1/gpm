// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gpm/pin.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Details extends StatefulWidget {
  const Details({super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  var namecon = TextEditingController();
  var name = '';
  var phone = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initdetail();
  }

  Future<void> initdetail() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      phone = prefs.getString('phone').toString();
    });

    DatabaseReference ref = FirebaseDatabase.instance
        .ref()
        .child(prefs.getString('phone').toString());
    ref.onValue.listen((event) {
      setState(() {
        namecon.text = event.snapshot.child('name').value.toString();
        name = namecon.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1f1f1f),
      appBar: AppBar(
        backgroundColor: Color(0xff1f1f1f),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Your details',
          style: TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              CircleAvatar(
                radius: 45,
                child: Text(
                  (name == '') ? '!' : name[0],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 45,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                    controller: namecon,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70)),
                        hintText: 'Username',
                        hintStyle: TextStyle(
                          color: Colors.white60,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70)),
                        hintText: '+91 $phone',
                        hintStyle: TextStyle(
                          color: Colors.white60,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();

          DatabaseReference ref = FirebaseDatabase.instance
              .ref()
              .child(prefs.getString('phone').toString());

          if (name == null || name == '') {
            Fluttertoast.showToast(msg: 'Please enter your name');
          } else {
            ref.child('name').set(name.trim());
            ref.child('phone').set(prefs.getString('phone').toString());
            ref.onValue.listen((event) {
              if (event.snapshot.child('bal').value == null) {
                //FIRST TIME ACC OPEN
                // WELCOME REWARD ₹100

                final DateFormat f = DateFormat('yyyy|MM|dd|HH|mm|ss');
                final String s = f.format(DateTime.now());

                ref.child('trans').child('$s').set('Welcome Reward#+#100');

                ref.child('bal').set(100);

                ref.child('ncount').set(1);
              }
            });

            await prefs.setString('name', name);
            await prefs.setInt('counter', 2);

            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Pin(end: false),
                ));
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(Icons.arrow_forward),
      ),
    );
  }
}
