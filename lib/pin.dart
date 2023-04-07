// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gpm/done.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class Pin extends StatefulWidget {
  final bool end;
  const Pin({super.key, required this.end});

  @override
  State<Pin> createState() => _PinState();
}

class _PinState extends State<Pin> {
  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    var pin = '';

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: 100, child: Image.asset('assets/vmon-logo.png')),
                Text(
                  'Enter 4 digit pin',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  'Enter your 4 digit transaction pin to continue.',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 75,
                ),
                SizedBox(
                  height: 55,
                  child: Pinput(
                    onChanged: (value) {
                      pin = value;
                    },
                    autofocus: true,
                    obscureText: true,
                    length: 4,
                    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                    showCursor: true,
                  ),
                ),
                SizedBox(
                  height: 75,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      DatabaseReference ref = FirebaseDatabase.instance
                          .ref()
                          .child(prefs.getString('phone').toString())
                          .child('pin');

                      ref.onValue.listen((event) async {
                        if (event.snapshot.value == null) {
                          ref.set(pin);
                          await prefs.setInt('counter', 3);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Home(),
                              ));
                        } else {
                          if (pin == event.snapshot.value.toString()) {
                            //DO NEXT WORK
                            await prefs.setInt('counter', 3);

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      (widget.end == false) ? Home() : Done(),
                                ));
                          } else {
                            Fluttertoast.showToast(
                                msg: 'Pin does not match! try re-entering');
                          }
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 10,
                        // backgroundColor: Color(0xff0077B6),
                        backgroundColor: Colors.lightBlue[800],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                    child: Text(
                      'CONTINUE',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
