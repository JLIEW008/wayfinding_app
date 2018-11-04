import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:map_view/location.dart';
import 'package:map_view/polyline.dart';


//Flutter channel to native android code

class GoogleMapHandler{
  static const platform = const MethodChannel('googleMapChannel');

  //Testing flutter channel
  Future<String> testChannel() async{
    try{
      final String result = await platform.invokeMethod('test');
      return result;
    } on PlatformException catch (e){
      print(e);
    }
  }

  //Methods to manipulate data
  List<Polyline> createPolyline(List<double> latitude, List<double> longitude){
    if(longitude.length != latitude.length){
      print("Longitude list length != Latitude list length");
    }

    List<Location> location= [];
    for(var i = 0; i < latitude.length; i++){
      location.add(new Location(latitude[i], longitude[i]));
    }

    List<Polyline> polyline = <Polyline>
    [new Polyline(
      "",
      location,
      width: 15.0,
      color: Colors.blue
    )];
    return polyline;

  }
  List<Polyline> _lines = <Polyline>[
    new Polyline(
        "11",
        <Location>[
          new Location(45.52309483308097, -122.67339684069155),
          new Location(45.52298442915803, -122.66339991241693),
        ],
        width: 15.0,
        color: Colors.blue),
  ];

}




//new Location(45.5231233, -122.6733130),
//new Location(45.5231195, -122.6706147),
//new Location(45.5231120, -122.6677823),
//new Location(45.5230894, -122.6670957),
//new Location(45.5230518, -122.6660979),
//new Location(45.5230518, -122.6655185),
//new Location(45.5232849, -122.6652074),
//new Location(45.5230443, -122.6649070),
//new Location(45.5230443, -122.6644135),
//new Location(45.5230518, -122.6639414),
//new Location(45.5231195, -122.6638663),
//new Location(45.5231947, -122.6638770),
//new Location(45.5233074, -122.6639950),
//new Location(45.5232698, -122.6643813),
//new Location(45.5235480, -122.6644349),
//new Location(45.5244349, -122.6645529),
//new Location(45.5245928, -122.6639628),
//new Location(45.5248108, -122.6632762),
//new Location(45.5249385, -122.6626861),
//new Location(45.5249310, -122.6622677),
//new Location(45.5250212, -122.6621926),
//new Location(45.5251490, -122.6621711),
//new Location(45.5251791, -122.6623106),
//new Location(45.5252242, -122.6625681),
//new Location(45.5251791, -122.6632118),
//new Location(45.5249010, -122.6640165),
//new Location(45.5247431, -122.6646388),
//new Location(45.5249611, -122.6646602),
//new Location(45.5253820, -122.6642525),
//new Location(45.5260811, -122.6642525),
//new Location(45.5260435, -122.6637161),
//new Location(45.5261713, -122.6635551),
//new Location(45.5263066, -122.6634800),
//new Location(45.5265471, -122.6635873),
//new Location(45.5269003, -122.6639628),
//new Location(45.5270356, -122.6642632),
//new Location(45.5271484, -122.6646602),
//new Location(45.5274866, -122.6649177),
//new Location(45.5271258, -122.6651645),
//new Location(45.5269605, -122.6653790),
//new Location(45.5267049, -122.6654434),
//new Location(45.5262990, -122.6657224),
//new Location(45.5261337, -122.6666021),
//new Location(45.5256677, -122.6678467),
//new Location(45.5245777, -122.6687801),
//new Location(45.5236908, -122.6690161),
//new Location(45.5233751, -122.6692307),
//new Location(45.5233826, -122.6714945),
//new Location(45.5233337, -122.6729804),
//new Location(45.5233225, -122.6732969),
//new Location(45.5232398, -122.6733506),
//new Location(45.5231233, -122.6733130),