import 'dart:async';
import 'dart:convert';
//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Post> fetchPost() async {
  //final response = await http.get('https://api.coindesk.com/v1/bpi/historical/close.json?start=2020-11-01&end='+finalDate.toString());
  final response =
      await http.get('https://api.coindesk.com/v1/bpi/historical/close.json');
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Post.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load post');
  }
}

class Post {
  final double price1;
  final double price2;
  final double price3;
  final double price4;
  final double price5;
  final double price6;
  final double price7;

//String date='2020-04-05';
  Post(
      {this.price1,
      this.price2,
      this.price3,
      this.price4,
      this.price5,
      this.price6,
      this.price7});

  factory Post.fromJson(Map<String, dynamic> json) {
    var arr = new List(7);
    //get next dateq

    for (int i = 1; i < 8; i++) {
      var now = new DateTime.now();
      final previousday =
          new DateTime(now.year, now.month, now.day - i).toString();
      var parse = DateTime.parse(previousday);
      var day = "${parse.day}";
      if (day == '1' ||
          day == '2' ||
          day == '3' ||
          day == '4' ||
          day == '5' ||
          day == '6' ||
          day == '7' ||
          day == '8' ||
          day == '9') {
        day = "0${parse.day}";
      }
      print(day);
      arr[i - 1] = "${parse.year}-${parse.month}-$day";
    }
    String date1 = arr[0];
    String date2 = arr[1];
    String date3 = arr[2];
    String date4 = arr[3];
    String date5 = arr[4];
    String date6 = arr[5];
    String date7 = arr[6];
    print("This is" + date1);
    return Post(
      price1: json['bpi'][date1],
      price2: json['bpi'][date2],
      price3: json['bpi'][date3],
      price4: json['bpi'][date4],
      price5: json['bpi'][date5],
      price6: json['bpi'][date6],
      price7: json['bpi'][date7],
    );
  }
}

void main() => runApp(TrendsScreen());

class TrendsScreen extends StatefulWidget {
  TrendsScreen({Key key}) : super(key: key);

  @override
  _TrendsScreenState createState() => _TrendsScreenState();
}

class _TrendsScreenState extends State<TrendsScreen> {
  Future<Post> futurePost;

  //get dates

  @override
  void initState() {
    super.initState();
    futurePost = fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: FutureBuilder<Post>(
            future: futurePost,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(children: <Widget>[
                  Card(
                      color: Color(0xFF8BBEB2),
                      child: Container(
                          width: 390,
                          height: 15,
                          margin: const EdgeInsets.fromLTRB(0, 20, 0, 30),
                          child: Text(
                              //get date

                              "  Yesterday         " +
                                  snapshot.data.price1.toString(),
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              )))),
                  Card(
                      color: Color(0xFFC3D5D1),
                      child: Container(
                          width: 390,
                          height: 15,
                          margin: const EdgeInsets.fromLTRB(0, 20, 0, 30),
                          child: Text(
                              //get date

                              " 2 Days ago        " +
                                  snapshot.data.price2.toString(),
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              )))),
                  Card(
                      color: Color(0xFFD1D9D7),
                      child: Container(
                          width: 390,
                          height: 15,
                          margin: const EdgeInsets.fromLTRB(0, 20, 0, 30),
                          child: Text(
                              //get date

                              " 3 Days ago           " +
                                  snapshot.data.price3.toString(),
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              )))),
                  Card(
                      color: Colors.blueGrey[100],
                      child: Container(
                          width: 390,
                          height: 15,
                          margin: const EdgeInsets.fromLTRB(0, 20, 0, 30),
                          child: Text(
                              //get date

                              " 4 Days ago       " +
                                  snapshot.data.price4.toString(),
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              )))),
                  Card(
                      color: Colors.blueGrey[100],
                      child: Container(
                          width: 390,
                          height: 15,
                          margin: const EdgeInsets.fromLTRB(0, 20, 0, 30),
                          child: Text(
                              //get date

                              "  5 Days ago       " +
                                  snapshot.data.price5.toString(),
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              )))),
                  Card(
                      color: Colors.blueGrey[100],
                      child: Container(
                          width: 390,
                          height: 15,
                          margin: const EdgeInsets.fromLTRB(0, 20, 0, 30),
                          child: Text(
                              //get date

                              " 6 Days ago       " +
                                  snapshot.data.price6.toString(),
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              )))),
                  Card(
                      color: Colors.blueGrey[100],
                      child: Container(
                          width: 390,
                          height: 15,
                          margin: const EdgeInsets.fromLTRB(0, 20, 0, 30),
                          child: Text(
                              //get date

                              " 7 Days ago      " +
                                  snapshot.data.price7.toString(),
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              )))),
                ]);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              } else
                // By default, show a loading spinner.
                return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
