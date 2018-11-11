import 'dart:async';

import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import 'package:map_view/polyline.dart';
import 'package:html/parser.dart';

import 'googleMapHandler.dart';

///This API Key will be used for both the interactive maps as well as the static maps.
///Make sure that you have enabled the following APIs in the Google API Console (https://console.developers.google.com/apis)
/// - Static Maps API
/// - Android Maps API
/// - iOS Maps API
const API_KEY = "AIzaSyBY5kUISXaSV_lkdA50ipdP1ndP_-jOgpY";

class GoogleMapUI extends StatefulWidget {
  @override
  _GoogleMapUIState createState() => new _GoogleMapUIState();
}

class _GoogleMapUIState extends State<GoogleMapUI> {
  MapView mapView = new MapView();
  CameraPosition cameraPosition;
  var compositeSubscription = new CompositeSubscription();
  var staticMapProvider = new StaticMapProvider(API_KEY);
  final locationToController = TextEditingController();
  final locationFromController = TextEditingController();
  Uri staticMapUri;
  String locationFrom;
  String locationTo;


  //Marker bubble
  List<Marker> _markers = <Marker>[
    new Marker(
      "1",
      "Something fragile!",
      45.52480841512737,
      -122.66201455146073,
      color: Colors.blue,
      draggable: true, //Allows the user to move the marker.
      markerIcon: new MarkerIcon(
        "images/flower_vase.png",
        width: 112.0,
        height: 75.0,
      ),
    ),
  ];

  //Testing Line
  List<double> latitude = [1.344058,1.343971,1.343829,1.343709,1.343415];
  List<double> longitude = [103.680673,103.680767,103.680917,103.681055,103.680808];
  /*1.344058,103.680673|1.343971,103.680767|1.343829,103.680917|1.343709,103.681055|1.343415,103.680808|
  1.343132,103.680557|1.342791,103.680231|1.342389,103.679863|1.342338,103.679924|1.342074,103.679653|
  1.342027,103.679555|1.342026,103.679450|1.341911,103.679438|1.341911,103.679354
  */
  @override
  initState() {
    super.initState();
    cameraPosition = new CameraPosition(Location(1.310270,103.820959), 11.0);
    staticMapUri = staticMapProvider.getStaticUri(Location(1.310270,103.820959), 11,
        width: 900, height: 600, mapType: StaticMapViewType.roadmap);
  }

  @override
  Widget build(BuildContext context) {
    MapView.setApiKey(API_KEY);
    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(
            title: new Text('Map View Example'),
          ),
          body: new ListView(
            children: <Widget>[
              new Container(
                padding: new EdgeInsets.only(top: 5.0),
                child: new TextField(
                  controller: locationFromController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: ' From'
                  ),
                ),
              ),
              new Container(
                padding: new EdgeInsets.only(top: 5.0),
                child: new TextField(
                  controller: locationToController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: ' To'
                  ),
                ),
              ),
              new Container(
                padding: new EdgeInsets.only(top:5.0),
                child: new RaisedButton(
                  onPressed:() {
                    locationFrom = locationFromController.text;
                    locationTo = locationToController.text;
                    fetchPost();
                  },
                  textColor: Colors.white,
                  color: Colors.red,
                  padding: const EdgeInsets.all(8.0),
                  child: new Text(
                    "Find Path!",
                  ),
                ),
              ),
              new Container(
                height: 360.0,
                child: new Stack(
                  children: <Widget>[
                    new Center(
                        child: new Container(
                          child: new Text(
                            "You are supposed to see a map here.\n\nAPI Key is not valid.\n\n"
                                "To view maps in the example application set the "
                                "API_KEY variable in example/lib/main.dart. "
                                "\n\nIf you have set an API Key but you still see this text "
                                "make sure you have enabled all of the correct APIs "
                                "in the Google API Console. See README for more detail.",
                            textAlign: TextAlign.center,
                          ),
                          padding: const EdgeInsets.all(10.0),
                        )),
                    new InkWell(
                      child: new Center(
                        child: new Image.network(staticMapUri.toString()),
                      ),
                      onTap: showMap,
                    )
                  ],
                ),
              ),
            ],
          )
      ),
    );
  }

  showMap() {
    GoogleMapHandler gmh = new GoogleMapHandler();
    var _lines = gmh.createPolyline(latitude, longitude);
    mapView.show(
        new MapOptions(
            mapViewType: MapViewType.normal,
            showUserLocation: true,
            showMyLocationButton: true,
            showCompassButton: true,
            initialCameraPosition: new CameraPosition(
                new Location(1.310270,103.820959), 10.5),
            hideToolbar: false,
            title: "Recently Visited"),
        toolbarActions: [new ToolbarAction("Close", 1)]);
    StreamSubscription sub = mapView.onMapReady.listen((_) {
      mapView.setMarkers(_markers);
      mapView.setPolylines(_lines);

    });
    compositeSubscription.add(sub);
    sub = mapView.onLocationUpdated.listen((location) {
      print("Location updated $location");
    });
    compositeSubscription.add(sub);
    sub = mapView.onTouchAnnotation
        .listen((annotation) => print("annotation ${annotation.id} tapped"));
    compositeSubscription.add(sub);
    sub = mapView.onTouchPolyline
        .listen((polyline) => print("polyline ${polyline.id} tapped"));
    compositeSubscription.add(sub);
    sub = mapView.onMapTapped
        .listen((location) => print("Touched location $location"));
    compositeSubscription.add(sub);
    sub = mapView.onMapLongTapped
        .listen((location) => print("Long tapped location $location"));
    compositeSubscription.add(sub);
    sub = mapView.onCameraChanged.listen((cameraPosition) =>
        this.setState(() => this.cameraPosition = cameraPosition));
    compositeSubscription.add(sub);
    sub = mapView.onAnnotationDragStart.listen((markerMap) {
      var marker = markerMap.keys.first;
      print("Annotation ${marker.id} dragging started");
    });
    sub = mapView.onAnnotationDragEnd.listen((markerMap) {
      var marker = markerMap.keys.first;
      print("Annotation ${marker.id} dragging ended");
    });
    sub = mapView.onAnnotationDrag.listen((markerMap) {
      var marker = markerMap.keys.first;
      var location = markerMap[marker];
      print("Annotation ${marker.id} moved to ${location.latitude} , ${location
          .longitude}");
    });
    compositeSubscription.add(sub);
    sub = mapView.onToolbarAction.listen((id) {
      print("Toolbar button id = $id");
      if (id == 1) {
        _handleDismiss();
      }
    });
    compositeSubscription.add(sub);
    sub = mapView.onInfoWindowTapped.listen((marker) {
      print("Info Window Tapped for ${marker.title}");
    });
    compositeSubscription.add(sub);
    sub = mapView.onIndoorBuildingActivated.listen(
            (indoorBuilding) => print("Activated indoor building $indoorBuilding"));
    compositeSubscription.add(sub);
    sub = mapView.onIndoorLevelActivated.listen(
            (indoorLevel) => print("Activated indoor level $indoorLevel"));
    compositeSubscription.add(sub);
  }

  _handleDismiss() async {
    double zoomLevel = await mapView.zoomLevel;
    Location centerLocation = await mapView.centerLocation;
    List<Marker> visibleAnnotations = await mapView.visibleAnnotations;
    List<Polyline> visibleLines = await mapView.visiblePolyLines;
    print("Zoom Level: $zoomLevel");
    print("Center: $centerLocation");
    print("Visible Annotation Count: ${visibleAnnotations.length}");
    print("Visible Polylines Count: ${visibleLines.length}");
    var uri = await staticMapProvider.getImageUriFromMap(mapView,
        width: 900, height: 400);
    setState(() => staticMapUri = uri);
    mapView.dismiss();
    compositeSubscription.cancel();
  }
}

class CompositeSubscription {
  Set<StreamSubscription> _subscriptions = new Set();

  void cancel() {
    for (var n in this._subscriptions) {
      n.cancel();
    }
    this._subscriptions = new Set();
  }

  void add(StreamSubscription subscription) {
    this._subscriptions.add(subscription);
  }

  void addAll(Iterable<StreamSubscription> subs) {
    _subscriptions.addAll(subs);
  }

  bool remove(StreamSubscription subscription) {
    return this._subscriptions.remove(subscription);
  }

  bool contains(StreamSubscription subscription) {
    return this._subscriptions.contains(subscription);
  }

  List<StreamSubscription> toList() {
    return this._subscriptions.toList();
  }
}