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




class _FourthPageState extends State<FourthPage> {
  List<bg.Location> _locations = [];
  double _totalDistance = 0.0;

  @override
  void initState() {
    super.initState();

    // 监听位置信息
    bg.BackgroundGeolocation.onLocation((bg.Location location) {
      setState(() {
        if (_locations.isNotEmpty) {
          _totalDistance += _calculateDistance(
            _locations.last.coords.latitude,
            _locations.last.coords.longitude,
            location.coords.latitude,
            location.coords.longitude,
          );
        }
        _locations.add(location);
      });
    });

    // 插件初始化
    bg.BackgroundGeolocation.ready(bg.Config(
      desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
      distanceFilter: 0,//10
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

  /// Haversine公式计算两点之间距离（米）
  double _calculateDistance(lat1, lon1, lat2, lon2) {
    const earthRadius = 6371000; // 米
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg2rad(lat1)) * cos(_deg2rad(lat2)) *
            sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _deg2rad(deg) => deg * (pi / 180);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Trajectory')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _locations.length,
              itemBuilder: (_, i) => ListTile(
                title: Text(
                    'Lat: ${_locations[i].coords.latitude}, Lng: ${_locations[i].coords.longitude}'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Total Distance: ${_totalDistance.toStringAsFixed(2)} meters',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}
