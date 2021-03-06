import 'dart:async';
import 'dart:convert';

import 'package:html/parser.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

import 'googleMapHandler.dart';
import 'googleMapUI.dart';

Future<String> getFileData(String path) async {
  return await rootBundle.loadString(path);
}

Future<String> fetchPost() async{
  final response =
  await http.get('http://maps.ntu.edu.sg/m?q=Asian%20School%20of%20the%20Environment%20(ASE)%20Admin%20Office%20to%20Bus%20stop%20opp%20Wee%20Kim%20Wee%20School%20of%20Communications%20%26%20Information%20(S1)%20(63707)&d=w&p=0&s=3&fs=m ');
//
//  String data = await getFileData("assets/sportsg-sport-facilities-kml.kml");
//  print(data);
//  var sportsSG = xml.parse(data);
//  var data1 = sportsSG.findAllElements('coordinates');
//  for(xml.XmlElement e in data1){
//    print(e);
//  }

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    RegExp exp = new RegExp("walk&path", caseSensitive: false);
    debugPrint(response.body);
    print(exp.hasMatch(response.body));

    return json.decode(response.body);
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }


}

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['path'],
    );
  }
}

void main() {
  runApp(MyApp());
  fetchPost();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
        title: 'Fetch Data Example',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MainScreen()
    );
  }
}


///Start from here
class MainScreen extends StatefulWidget {
  @override
  MyTabsState createState() => new MyTabsState();
}

class MyTabsState extends State<MainScreen> with SingleTickerProviderStateMixin {

  final List<MyTabs> _tabs = [
    new MyTabs(title: "Map"),
    new MyTabs(title: "Map"),
    new MyTabs(title: "hehe")
  ];

  MyTabs handler;
  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = new TabController(vsync: this, length: 3, initialIndex: 0);
    handler = _tabs[1];
    controller.addListener(handleSelected);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void handleSelected() {
    setState(() {
      handler = _tabs[controller.index];
    });
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
        bottomNavigationBar: new Material(
            color: Colors.white,
            child: new TabBar(
                controller: controller,
                tabs: <Tab>[
                  new Tab(icon: new Icon(Icons.timer)),
                  new Tab(icon: new Icon(Icons.group)),
                  new Tab(icon: new Icon(Icons.message))
                ],
                indicatorColor: new Color(0xFFED2939),
                labelColor: new Color(0xFFED2939),
                unselectedLabelColor: Colors.grey)),
        body: new TabBarView(controller: controller, children: <Widget>[
          //new schedule.Schedule(),
          new GoogleMapUI(),
          //new chat.MessengerHome()
        ]));
  }
}

class MyTabs {
  final String title;
  MyTabs({this.title});
}
