// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Trans extends StatefulWidget {
  const Trans({super.key});

  @override
  State<Trans> createState() => _TransState();
}

class _TransState extends State<Trans> {
  var textlist = [''];
  var dtlist = [''];

  Future<void> inittrans() async {
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
            textlist.insert(0, child.value.toString());
            dtlist.insert(0, child.key.toString());
          }
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    inittrans();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1f1f1f),
      appBar: AppBar(
        backgroundColor: Color(0xff1f1f1f),
        elevation: 0,
        title: Text(
          'Transactions',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: textlist.length - 1,
        itemBuilder: (context, index) =>
            TransListItem(text: textlist[index], dt: dtlist[index]),
      ),
    );
  }
}

class TransListItem extends StatelessWidget {
  final String text, dt;
  const TransListItem({super.key, required this.text, required this.dt});

  @override
  Widget build(BuildContext context) {
    var textsplit = text.split('#');
    var dtsplit = dt.split('|');

    bool isDigit(String s) {
      try {
        int d = int.parse(s);
      } catch (e) {
        return false;
      }
      return true;
    }

    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                    radius: 23,
                    child: Icon(
                      (isDigit(textsplit[0][0]))
                          ? Icons.person
                          : Icons.card_giftcard,
                    )),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      textsplit[0],
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      '${DateFormat('MMM').format(DateTime(0, int.parse(dtsplit[1])))} ${dtsplit[2]}, ${dtsplit[0]} at ${dtsplit[3]}:${dtsplit[4]}',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    )
                  ],
                ),
              ],
            ),
            Text(
              (textsplit[1] == '+') ? '+ ' + textsplit[2] : '' + textsplit[2],
              style: TextStyle(
                color: (textsplit[1] == '+') ? Colors.green : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            )
          ],
        ),
      ),
    );
  }
}
