// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gpm/pin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Payment extends StatefulWidget {
  final Map<String, String> person;
  const Payment({super.key, required this.person});

  static var man;
  static int send = 0;

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  var amt = '';
  int sb = 0;

  Future<void> getbal() async {
    final prefs = await SharedPreferences.getInstance();
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    final snapshot1 =
        await ref.child(prefs.getString('phone').toString()).child('bal').get();
    setState(() {
      sb = int.parse(snapshot1.value.toString());
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    Payment.man = widget.person;
    super.initState();
    getbal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1f1f1f),
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          // Status bar color
          statusBarColor: Color(0xff1f1f1f),
        ),
        backgroundColor: Color(0xff1f1f1f),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: GestureDetector(
              onTap: () {},
              child: Icon(Icons.info_outline),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: GestureDetector(
              onTap: () {},
              child: Icon(Icons.more_vert),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              child: Text(
                widget.person['name'].toString()[0],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'Paying ${widget.person['name']}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              '${widget.person['phone']}@upim',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            Text(
              'Banking name: ${widget.person['name']}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            IntrinsicWidth(
              child: TextField(
                onChanged: (value) {
                  amt = value;
                },
                autofocus: true,
                keyboardType: TextInputType.number,
                cursorWidth: 3,
                cursorColor: Colors.white,
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  isCollapsed: true,
                  prefixText: '₹ ',
                  prefixStyle: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  hintText: '0',
                  hintStyle: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var err = 0;
          if (amt.isEmpty) {
            Fluttertoast.showToast(msg: 'Amount should not be empty');
          } else {
            try {
              Payment.send = int.parse(amt);
            } on Exception catch (e) {
              err = 1;
              Fluttertoast.showToast(
                msg: 'Invalid number!',
                toastLength: Toast.LENGTH_LONG,
                textColor: Colors.red,
                backgroundColor: Colors.black,
              );
            }
            if (err == 0) {
              if (Payment.send > sb) {
                Fluttertoast.showToast(
                    msg: 'Seems that your balance is insufficient');
              } else {
                // Fluttertoast.showToast(
                //   msg: 'ok',
                //   toastLength: Toast.LENGTH_LONG,
                //   textColor: Colors.red,
                //   backgroundColor: Colors.white,
                // );
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Pin(end: true),
                    ));
              }
            }
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
