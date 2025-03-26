import 'dart:math';
import 'dart:ui';
import 'dart:async';

import '123page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  final items = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
    BottomNavigationBarItem(icon: Icon(Icons.bluetooth), label: 'bluetooth'),
    BottomNavigationBarItem(icon: Icon(Icons.message), label: 'information'),
    BottomNavigationBarItem(icon: Icon(Icons.map), label: 'map'),
  ];
  
  //final bodyList = [FirstPage(), SecondPage(), ThirdPage()];

  int currentIndex = 0;
  int allCount = 0; // 记录所有页面的总数
  String myBluetoothReadValueUUID = 'characteristic.uuid ';
  double movementProbability = 0;
  String movementInString = '0';


  // 处理增加计数的方法
  void increaseCount() {
    setState(() {
      allCount++;
    });
  }

void changeBluetoothReadValue(List<int> values) {
  setState(() {
    int max_index = values[0];
    int max_value_int = values[1] + (values[2] << 8);
    double max_value = max_value_int / 1000.0;

    if (max_index == 0) {
      movementInString = 'Running';
    } else if (max_index == 1) {
      movementInString = 'Walking';
    } else if (max_index == 2) {
      movementInString = 'Stationary';
    } else {
      movementInString = 'error';
    }

    if (max_value > 0.0001 && max_value < 0.9999) {
      movementProbability = max_value;
    } else {
      movementProbability = 0.0;
    }

    myBluetoothReadValueUUID = 'Pro:$movementProbability, Move:$movementInString';

    // 重新初始化 bodyList 以更新 FirstPage
    bodyList[0] = FirstPage(increaseCount, () => allCount, movementProbability, movementInString);
    bodyList[3] = FourthPage(movementInString);
  });
}



   final List<Widget> bodyList = [];

  @override
  void initState() {
    super.initState();
    bodyList.addAll([
      FirstPage(increaseCount, () => allCount, movementProbability, movementInString),
      //SecondPage(increaseCount, () => allCount),
      SecondPage(changeBluetoothReadValue, () => myBluetoothReadValueUUID ),
      ThirdPage(increaseCount, () => allCount),
      FourthPage(movementInString),
    ]);
  }

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('team'),
        ),
        bottomNavigationBar: BottomNavigationBar(
            items: items, currentIndex: currentIndex, onTap: onTap, type: BottomNavigationBarType.fixed),
        body: Stack(
          children: [
            Offstage(
              offstage: currentIndex != 0,
              child: bodyList[0],//home
            ),
            Offstage(
              offstage: currentIndex != 1,
              child: bodyList[1],//bluetooth
            ),
            Offstage(
              offstage: currentIndex != 2,
              child: bodyList[2],//info
            ),
            Offstage(
              offstage: currentIndex != 3,
              child: bodyList[3],//map
            ),
          ],
        ));
  }
}




class FourthPage extends StatefulWidget {
  final String movementInString;

  FourthPage(this.movementInString);

  @override
  _FourthPageState createState() => _FourthPageState();
}


class ColoredTrackPoint {
  final LatLng point;
  final Color color;

  ColoredTrackPoint(this.point, this.color);
}

class _FourthPageState extends State<FourthPage> {
  List<ColoredTrackPoint> _track = [];
  double _totalDistance = 0.0;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();

    // this is the event that is fired when a location is recorded
    bg.BackgroundGeolocation.onLocation((bg.Location location) {
      LatLng newPoint = LatLng(location.coords.latitude, location.coords.longitude);
      Color currentColor = _getColorForMovement(widget.movementInString);

      if (_track.isNotEmpty) {
        final prev = _track.last.point;
        final segment = Geolocator.distanceBetween(
          prev.latitude, prev.longitude,
          newPoint.latitude, newPoint.longitude,
        );
        _totalDistance += segment;
      }

      setState(() {
        _track.add(ColoredTrackPoint(newPoint, currentColor));
      });

      // move the camera to the new point
      _mapController?.animateCamera(CameraUpdate.newLatLng(newPoint));
    });

    // configure the plugin
    bg.BackgroundGeolocation.ready(bg.Config(
      desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
      distanceFilter: 0,
      stopOnTerminate: false,
      startOnBoot: true,
      debug: true,
      logLevel: bg.Config.LOG_LEVEL_VERBOSE,
    )).then((bg.State state) {
      if (!state.enabled) {
        bg.BackgroundGeolocation.start();
      }
    });
  }

  Color _getColorForMovement(String movement) { // based on the movement type, return a color
    switch (movement) {
      case 'Running':
        return Colors.red;
      case 'Walking':
        return Colors.green;
      case 'Stationary':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  void dispose() {
    bg.BackgroundGeolocation.stop();
    super.dispose();
  }

  void _clearTrack() {
    setState(() {
      _track.clear();
      _totalDistance = 0.0;
    });
  }


 // the build method for colorful tracking
  @override
  Widget build(BuildContext context) {
    Set<Polyline> polylines = {};

    for (int i = 1; i < _track.length; i++) {
      polylines.add(Polyline(
        polylineId: PolylineId('movement_$i'),
        points: [_track[i - 1].point, _track[i].point],
        color: _track[i].color,
        width: 5,
      ));
    }

    return Scaffold( // the scaffold for colorful tracking
      appBar: AppBar(title: Text('Movement Tracking')),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _track.isNotEmpty ? _track.first.point : LatLng(0, 0),
              zoom: 16,
            ),
            polylines: polylines,
            onMapCreated: (controller) => _mapController = controller,
            myLocationEnabled: true,
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Container(
              padding: EdgeInsets.all(12),
              color: Colors.white70,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Movement: ${widget.movementInString}', style: TextStyle(fontSize: 16)),
                  Text('Total Distance: ${_totalDistance.toStringAsFixed(2)} m',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _clearTrack,
        tooltip: 'Clear',
        child: Icon(Icons.clear),
      ),
    );
  }
}
