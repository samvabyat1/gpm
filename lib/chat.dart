// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gpm/pay.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chat extends StatefulWidget {
  final Map<String, String> person;
  const Chat({super.key, required this.person});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  List<Map<String, String>> translist = [{}];

  Future<void> initchat() async {
    final prefs = await SharedPreferences.getInstance();
    final ref = FirebaseDatabase.instance
        .ref()
        .child(prefs.getString('phone').toString())
        .child('trans')
        .orderByKey();

    ref.onValue.listen((event) {
      if (mounted) {
        setState(() {
          for (final child in event.snapshot.children) {
            if (child.value.toString().split('#')[0] ==
                widget.person['phone']) {
              translist.insert(0, {
                'key': child.key.toString(),
                'value': child.value.toString()
              });
            }
          }
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initchat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1f1f1f),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65),
        child: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            // Status bar color
            statusBarColor: Color(0xff2d2e30),
          ),
          backgroundColor: Color(0xff2d2e30),
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
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                CircleAvatar(
                  child: Text(
                    widget.person['name'].toString()[0],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.person['name'].toString().split(' ')[0],
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '+91 ' + widget.person['phone'].toString(),
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      body: ListView.builder(
        reverse: true,
        itemCount: translist.length - 1,
        itemBuilder: (context, index) => Row(
          mainAxisAlignment:
              (translist[index]['value'].toString().split('#')[1] == '+')
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Color(0xff292929),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment to ${(translist[index]['value'].toString().split('#')[1] == '+') ? 'you' : widget.person['name'].toString().split(' ')[0]}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        '₹${translist[index]['value'].toString().split('#')[2]}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 15,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Paid • ${DateFormat('MMM').format(DateTime(0, int.parse(translist[index]['key'].toString().split('|')[1])))} ${translist[index]['key'].toString().split('|')[2]}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 85,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 15,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      // bottomSheet: Container(
      //   color: Color(0xff1f1f1f),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.end,
      //     children: [
      //       Padding(
      //         padding: const EdgeInsets.only(right: 30, bottom: 20),
      //         child: ElevatedButton(
      //           style: ElevatedButton.styleFrom(
      //               backgroundColor: Color(0xffa8c8fb),
      //               shape: RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.circular(50))),
      //           onPressed: () {},
      //           child: Padding(
      //             padding:
      //                 const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      //             child: Text(
      //               'Pay',
      //               style: TextStyle(
      //                 fontSize: 17,
      //                 color: Color(0xff0f3572),
      //                 fontWeight: FontWeight.bold,
      //               ),
      //             ),
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 15, right: 20),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xffa8c8fb),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50))),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Payment(
                  person: widget.person,
                ),
              )),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Text(
              'Pay',
              style: TextStyle(
                fontSize: 17,
                color: Color(0xff0f3572),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
