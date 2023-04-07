// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gpm/pay.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Done extends StatefulWidget {
  const Done({super.key});

  @override
  State<Done> createState() => _DoneState();
}

class _DoneState extends State<Done> {
  TextEditingController sendcon = TextEditingController();

  var visible = true;

  var tag = Container(
    child: Icon(
      Icons.access_time_filled,
      color: Colors.white,
    ),
  );

  var tagtext = Container();

  var bottom = Container(
    color: Color(0xff2d2e30),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 25),
          child: Text(
            'Processing payment  ',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
        ),
        // SizedBox(
        //   height: 50,
        //   child: LoadingIndicator(
        //     indicatorType: Indicator.ballPulse,
        //     colors: const [Colors.white],
        //     strokeWidth: 2,
        //     backgroundColor: Color(0xff2d2e30),
        //   ),
        // )
      ],
    ),
  );

  Future<void> initiatethis() async {
    final prefs = await SharedPreferences.getInstance();
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    final DateFormat f = DateFormat('yyyy|MM|dd|HH|mm|ss');
    final String s = f.format(DateTime.now());

    //SENDER SIDE

    var err = 0;

    try {
      final snapshot1 = await ref
          .child(prefs.getString('phone').toString())
          .child('bal')
          .get();
      int sb = int.parse(snapshot1.value.toString());

      ref
          .child(prefs.getString('phone').toString())
          .child('bal')
          .set(sb - Payment.send);

      ref
          .child(prefs.getString('phone').toString())
          .child('trans')
          .child('$s')
          .set('${Payment.man['phone']}#-#${Payment.send}');

      //50% CASHBACK

      if (Payment.send % 2 == 0 && Payment.send >= 50) {
        ref
            .child(prefs.getString('phone').toString())
            .child('bal')
            .set(sb + (Payment.send) ~/ 2);

        ref
            .child(prefs.getString('phone').toString())
            .child('trans')
            .child('$s' + '0')
            .set('Cashback 50%#+#${(Payment.send) ~/ 2}');

        final snapshots = await ref
            .child(prefs.getString('phone').toString())
            .child('ncount')
            .get();
        int sc = int.parse(snapshots.value.toString());

        ref
            .child(prefs.getString('phone').toString())
            .child('ncount')
            .set(sc + 1);
      }

      //RECIEVER SIDE

      final snapshot = await ref.child(Payment.man['phone']).child('bal').get();
      int rb = int.parse(snapshot.value.toString());

      ref.child(Payment.man['phone']).child('bal').set(rb + Payment.send);

      ref
          .child(Payment.man['phone'])
          .child('trans')
          .child('$s')
          .set('${prefs.getString('phone')}#+#${Payment.send}');

      final snapshotn =
          await ref.child(Payment.man['phone']).child('ncount').get();
      int nc = int.parse(snapshotn.value.toString());

      ref.child(Payment.man['phone']).child('ncount').set(nc + 1);

      //complete
    } on Exception catch (e) {
      err = 1;
    }

    if (err == 0) {
      success();
    } else {
      failure();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sendcon.text = Payment.send.toString();
    initiatethis();
  }

  void success() {
    final player = AudioCache();
    player.play('Payment Sound - Google pay.mp3');
    if (mounted) {
      setState(() {
        bottom = Container(
          color: Color(0xff1f1f1f),
          child: Center(
            child: Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
              size: 150,
            ),
          ),
        );
      });
    }
    Timer(Duration(milliseconds: 3000), () {
      if (mounted) {
        setState(() {
          visible = false;
          tag = Container(
            child: Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
            ),
          );
          tagtext = Container(
            child: Text(
              'Success',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        });
      }
    });
  }

  void failure() {
    if (mounted) {
      setState(() {
        bottom = Container(
          color: Color(0xff1f1f1f),
          child: Center(
            child: Icon(
              Icons.cancel_rounded,
              color: Colors.white,
              size: 150,
            ),
          ),
        );
      });
    }
    Timer(Duration(milliseconds: 3000), () {
      if (mounted) {
        setState(() {
          visible = false;
          tag = Container(
            child: Icon(
              Icons.info,
              color: Colors.red,
            ),
          );
          tagtext = Container(
            child: Text(
              'Failed',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        });
      }
    });
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
            Stack(
              children: [
                CircleAvatar(
                  radius: 30,
                  child: Text(
                    Payment.man['name'].toString()[0],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
                tag,
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'Payment to ${Payment.man['name']}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              '${Payment.man['phone']}@upim',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            Text(
              'Banking name: ${Payment.man['name']}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            IntrinsicWidth(
              child: TextField(
                readOnly: true,
                controller: sendcon,
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
            ),
            tagtext,
          ],
        ),
      ),
      bottomSheet: Visibility(
        visible: visible,
        child: bottom,
      ),
    );
  }
}
