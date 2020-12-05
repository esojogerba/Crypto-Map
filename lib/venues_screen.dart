import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Venues> fetchVenues() async {
  final response = await http.get('https://coinmap.org/api/v1/venues/');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Venues.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Venues {
  List<Venue> venues;

  Venues({this.venues});

  Venues.fromJson(Map<String, dynamic> json) {
    if (json['venues'] != null) {
      venues = new List<Venue>();
      json['venues'].forEach((v) {
        venues.add(new Venue.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.venues != null) {
      data['venues'] = this.venues.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Venue {
  int id;
  double lat;
  double lon;
  String category;
  String name;
  int createdOn;

  Venue(
      {this.id, this.lat, this.lon, this.category, this.name, this.createdOn});

  Venue.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lat = json['lat'];
    lon = json['lon'];
    category = json['category'];
    name = json['name'];
    createdOn = json['created_on'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['category'] = this.category;
    data['name'] = this.name;
    data['created_on'] = this.createdOn;
    return data;
  }
}

void main() => runApp(VScreen());

class VScreen extends StatefulWidget {
  VScreen({Key key}) : super(key: key);

  @override
  _VScreenState createState() => _VScreenState();
}

class _VScreenState extends State<VScreen> {
  Future<Venues> futureVenues;

  @override
  void initState() {
    super.initState();
    futureVenues = fetchVenues();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'These Places Accept Bitcoin',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 100.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 90.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 20.0, fontFamily: 'Monda'),
        ),
      ),
      home: Scaffold(
        body: Center(
          child: FutureBuilder<Venues>(
            future: futureVenues,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.separated(
                  itemBuilder: (_, index) {
                    return Text(snapshot.data.venues[index].name);
                  },
                  separatorBuilder: (_, __) => Divider(),
                  itemCount: snapshot.data.venues.length,
                  addAutomaticKeepAlives: false,
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
