// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'chat.dart';
import 'home.dart';

class People extends StatefulWidget {
  const People({super.key});

  @override
  State<People> createState() => _PeopleState();
}

class _PeopleState extends State<People> {
  List<Map<String, String>> found = [{}];

  @override
  void initState() {
    found = Home.people;
    super.initState();
  }

  void runfilter(String kw) {
    List<Map<String, String>> results = [{}];
    if (kw.isEmpty) {
      results = Home.people;
    } else {
      results = Home.people
          .where((element) =>
              element['name']!.toLowerCase().contains(kw.toLowerCase()) ||
              element['phone']!.contains(kw))
          .toList();
    }

    setState(() {
      found = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1f1f1f),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff1f1f1f),
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          // Status bar color
          statusBarColor: Color(0xff1f1f1f),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: GestureDetector(
              onTap: () {},
              child: Icon(Icons.more_vert),
            ),
          )
        ],
        title: SizedBox(
          height: 45,
          child: TextField(
            onChanged: (value) => runfilter(value),
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(13),
              hintText: 'Search',
              hintStyle: TextStyle(color: Colors.white54),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide(
                  color: Colors.white60,
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide(
                  color: Colors.white60,
                  width: 1,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: found.length,
                itemBuilder: (context, index) =>
                    SearchPeoplePic(person: found[index]),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                SizedBox(
                  width: 25,
                ),
                Text(
                  'All people',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: found.length,
              itemBuilder: (context, index) => SearchListItem(
                person: found[index],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SearchPeoplePic extends StatelessWidget {
  final Map<String, String> person;
  SearchPeoplePic({super.key, required this.person});
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
              builder: (context) => Chat(person: person),
            ));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            children: [
              CircleAvatar(
                radius: 30,
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
      ),
    );
  }
}

class SearchListItem extends StatelessWidget {
  final person;
  const SearchListItem({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Chat(person: person),
            ));
      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
          child: Row(
            children: [
              CircleAvatar(
                radius: 23,
                child: Text(
                  'R',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    person['name'],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    person['phone'],
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
