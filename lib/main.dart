import 'dart:async';
import 'dart:convert';

import 'package:html/parser.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<String> fetchPost() async {
  final response =
  await http.get('http://maps.ntu.edu.sg/m?q=Asian%20School%20of%20the%20Environment%20(ASE)%20Admin%20Office%20to%20Bus%20stop%20opp%20Wee%20Kim%20Wee%20School%20of%20Communications%20%26%20Information%20(S1)%20(63707)&d=w&p=0&s=3&fs=m ');

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

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<String>(
            future: fetchPost(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print(snapshot.data);
                return Text(snapshot.data);
              } else if (snapshot.hasError) {
                print("Error");
                return Text("${snapshot.error}");
              }
              // By default, show a loading spinner
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}