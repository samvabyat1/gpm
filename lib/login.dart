// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:alt_sms_autofill/alt_sms_autofill.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gpm/details.dart';
import 'package:gpm/home.dart';
import 'package:gpm/pin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController textEditingController1;
  var verificationcopy;

  String _comingSms = 'Unknown';

  Future<void> initSmsListener() async {
    String? comingSms;
    try {
      comingSms = await AltSmsAutofill().listenForSms;
    } on PlatformException {
      comingSms = 'Failed to get Sms.';
      Fluttertoast.showToast(msg: 'Failed to get Sms');
    }
    if (!mounted) return;
    setState(() {
      _comingSms = comingSms!;
      Fluttertoast.showToast(
        msg: 'Scanning OTP',
        toastLength: Toast.LENGTH_SHORT,
        textColor: Colors.white,
        backgroundColor: Colors.green[900],
      );
      textEditingController1.text = _comingSms[0] +
          _comingSms[1] +
          _comingSms[2] +
          _comingSms[3] +
          _comingSms[4] +
          _comingSms[5];

      if (textEditingController1.text.length == 6) {
        final_do();
      }
    });
  }

  Future<void> final_do() async {
    int errorflag = 0;
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationcopy,
          smsCode: textEditingController1.text);

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Incorrect otp');
      setState(() {
        errorflag = 1;
      });
    }

    if (errorflag == 0) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('counter', 1);
      await prefs.setString('phone', phcon.text);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Details(),
          ));
    } else {
      Fluttertoast.showToast(
        msg: 'Cant find your device',
        toastLength: Toast.LENGTH_LONG,
        textColor: Colors.white,
        backgroundColor: Colors.red[900],
      );
    }
  }

  TextEditingController phcon = TextEditingController();

  @override
  void initState() {
    super.initState();

    optional();

    textEditingController1 = TextEditingController();
    initSmsListener();
  }

  Future<void> optional() async {
    final prefs = await SharedPreferences.getInstance();
    var counter = prefs.getInt('counter');

    if (counter == 1) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Details(),
          ));
    }else if(counter==2){
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Pin(end: false),
          ));
    }else if(counter==3){
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Home(),
          ));
    }
  }

  @override
  void dispose() {
    textEditingController1.dispose();
    AltSmsAutofill().unregisterListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1f1f1f),
      appBar: AppBar(
        backgroundColor: Color(0xff1f1f1f),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: GestureDetector(
              onTap: () {},
              child: Icon(Icons.more_vert),
            ),
          )
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: BorderSide(
                      color: Colors.white54,
                      width: 1.5,
                    )),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: Image.asset(
                        'assets/Flag_of_India.png',
                        scale: 27,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'IN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                )),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/gpm-icon.png',
                    scale: 15,
                  ),
                  Text(
                    'GPM',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                'Welcome to GPM',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Enter your phone number',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              TextField(
                controller: phcon,
                keyboardType: TextInputType.phone,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  hintText: '+91 00000 00000',
                  hintStyle: TextStyle(
                    color: Colors.white70,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      color: Colors.white54,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      color: Colors.white54,
                      width: 1.5,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => Home(),
          //     ));

          if (phcon.text.length == 10) {
            Fluttertoast.showToast(
              msg: 'Please wait while we are verifying',
              toastLength: Toast.LENGTH_LONG,
              textColor: Colors.white,
              backgroundColor: Colors.blue[900],
            );
            await FirebaseAuth.instance.verifyPhoneNumber(
              phoneNumber: '+91${phcon.text}',
              verificationCompleted: (PhoneAuthCredential credential) {},
              verificationFailed: (FirebaseAuthException e) {
                Fluttertoast.showToast(
                  msg: '${e.message}',
                  toastLength: Toast.LENGTH_LONG,
                  textColor: Colors.white,
                  backgroundColor: Colors.red[900],
                );
              },
              codeSent: (String verificationId, int? resendToken) async {
                showModalBottomSheet(
                  isDismissible: false,
                  context: context,
                  builder: (context) => Container(
                    height: 300,
                    width: double.infinity,
                    color: Color(0xff202125),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Verifying\n${textEditingController1.text}',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                          ),
                        )
                      ],
                    ),
                  ),
                );

                verificationcopy = verificationId;
              },
              codeAutoRetrievalTimeout: (String verificationId) {},
            );
          } else {
            Fluttertoast.showToast(
              msg: 'Phone number must be of 10 digits',
              toastLength: Toast.LENGTH_LONG,
              textColor: Colors.red,
              backgroundColor: Colors.white,
            );
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
