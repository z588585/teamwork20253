import 'dart:math';
import 'dart:ui';
import 'dart:async';

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

// 统一修改子页面，使其可以增加 allCount 并读取最新的值
class FirstPage extends StatefulWidget {
  final VoidCallback increaseCount;
  final int Function() getAllCount;
  final double movementProbability;
  final String movementInString;

  //FirstPage(this.increaseCount, this.getAllCount);
   FirstPage(this.increaseCount, this.getAllCount, this.movementProbability, this.movementInString);

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {



  @override
  Widget build(BuildContext context) {
    String imagePath;
    switch (widget.movementInString) {
      case 'Running':
        imagePath = 'assets/img/running.gif';
        break;
      case 'Walking':
        imagePath = 'assets/img/Walking.gif';
        break;
      case 'Stationary':
        imagePath = 'assets/img/Stationary.gif';
        break;
      default:
        imagePath = 'assets/img/other.gif';
        break;
    }
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 300,
                  height: 300,
                  child: CustomPaint(
                    painter: ArcPainter(widget.movementProbability * 100, Colors.green, Colors.grey),
                  ),
                ),
                Image.asset(
                  imagePath, // Dynamically chosen image based on movement state
                  width: 150, // Adjust width as needed
                  height: 150, // Adjust height as needed
                  fit: BoxFit.contain,
                ),
              ],
            ),
            SizedBox(
              width: 386,
              child: Text(
                '${(widget.movementProbability * 100).toStringAsFixed(1)}%',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF4F378A),
                  fontSize: 96,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w900,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 2),
                      blurRadius: 3,
                      color: Color(0xFF000000).withOpacity(0.30),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 386,
              child: Text(
                'percent chance you are',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF32A455),
                  fontSize: 30,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w900,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 2),
                      blurRadius: 3,
                      color: Color(0xFF000000).withOpacity(0.30),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 386,
              child: Text(
                widget.movementInString,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF4F378A),
                  fontSize: 64,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w900,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 2),
                      blurRadius: 3,
                      color: Color(0xFF000000).withOpacity(0.30),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondPage extends StatefulWidget {
  final Function(List<int>) changeBluetoothReadValue; 
  final String Function() changeBluetoothReadValueInSecondPage;
  SecondPage(this.changeBluetoothReadValue, this.changeBluetoothReadValueInSecondPage);

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  int count = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BluetoothHomePage(title: 'Bluetooth Devices'),
      );
  }
}

class ThirdPage extends StatefulWidget {
  final VoidCallback increaseCount;
  final int Function() getAllCount;

  ThirdPage(this.increaseCount, this.getAllCount);

  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  int count = 0;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16), // 添加内边距
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.1), // 设置背景颜色
                borderRadius: BorderRadius.circular(12), // 圆角
              ),
              child: Text(
                '🔹 Information: This is our team app',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            SizedBox(height: 20), // 间距
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '📡 Please use your Bluetooth to connect to our Arduino device. The name is **"Lee"**.\n\n'
                '🔔 Push the **"NOTIFY"** button in **f43b1...** to receive real-time data.\n\n'
                '📊 The **"Home"** page will show the probability of your movement and the type of movement.\n\n'
                '📝 team mambers "lee" "b" "han" "Tee" "huawei".\n\n'
                'have fun!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  height: 1.5, // 增加行距
                ),
              ),
            ),
          ],

        )),
    );
  }
}

class FourthPage extends StatefulWidget {
  final String movementInString;
  FourthPage(this.movementInString);

  @override
  _FourthPageState createState() => _FourthPageState();
}

class _FourthPageState extends State<FourthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child:
            Text(widget.movementInString, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ),
    );
  }
}




class BluetoothHomePage extends StatefulWidget {
  BluetoothHomePage({Key? key, required this.title}) : super(key: key);

  final String title;
  final List<BluetoothDevice> devicesList = <BluetoothDevice>[];
  final Map<Guid, List<int>> readValues = <Guid, List<int>>{};

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<BluetoothHomePage> {
  
  final _writeController = TextEditingController();
  BluetoothDevice? _connectedDevice;
  List<BluetoothService> _services = [];
  _addDeviceTolist(final BluetoothDevice device) {
    if (!widget.devicesList.contains(device)) {
      setState(() {
        widget.devicesList.add(device);
      });
    }
  }

  _initBluetooth() async { 
    var subscription = FlutterBluePlus.onScanResults.listen(
          (results) {
        if (results.isNotEmpty) {
          for (ScanResult result in results) {
            _addDeviceTolist(result.device);
          }
        }
      },
      onError: (e) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      ),
    );
    FlutterBluePlus.cancelWhenScanComplete(subscription);
    await FlutterBluePlus.adapterState.where((val) => val == BluetoothAdapterState.on).first;
    await FlutterBluePlus.startScan();
    await FlutterBluePlus.isScanning.where((val) => val == false).first;
    FlutterBluePlus.connectedDevices.map((device) {
      _addDeviceTolist(device);
    });
  }
  @override
  void initState() {
    () async {
      var status = await Permission.location.status;
      if (status.isDenied) {
        final status = await Permission.location.request();
        if (status.isGranted || status.isLimited) {
          _initBluetooth();
        }
      } else if (status.isGranted || status.isLimited) {
        _initBluetooth();
      }
      if (await Permission.location.status.isPermanentlyDenied) {
        openAppSettings();
      }
    }();
    super.initState();
  }
  ListView _buildListViewOfDevices() {
    List<Widget> containers = <Widget>[];
    for (BluetoothDevice device in widget.devicesList) {
      containers.add(
        SizedBox(
          height: 50,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(device.platformName == '' ? '(unknown device)' : device.advName),
                    Text(device.remoteId.toString()),
                  ],
                ),
              ),
              TextButton(
                child: const Text(
                  'Connect',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () async {
                  FlutterBluePlus.stopScan();
                  try {
                    await device.connect();
                  } on PlatformException catch (e) {
                    if (e.code != 'already_connected') {
                      rethrow;
                    }
                  } finally {
                    _services = await device.discoverServices();
                  }
                  setState(() {
                    _connectedDevice = device;
                  });
                },
              ),
            ],
          ),
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ...containers,
      ],
    );
  }
  List<ButtonTheme> _buildReadWriteNotifyButton(BluetoothCharacteristic characteristic) {
    List<ButtonTheme> buttons = <ButtonTheme>[];
    if (characteristic.properties.read) {
      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: TextButton(
              child: const Text('READ', style: TextStyle(color: Colors.black)),
              onPressed: () async {
                var sub = characteristic.lastValueStream.listen((value) {
                  setState(() {
                    widget.readValues[characteristic.uuid] = value;
                  });
                });
                await characteristic.read();
                sub.cancel();
              },
            ),
          ),
        ),
      );
    }
    if (characteristic.properties.write) {
      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              child: const Text('WRITE', style: TextStyle(color: Colors.black)),
              onPressed: () async {
                await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Write"),
                        content: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                controller: _writeController,
                              ),
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text("Send"),
                            onPressed: () {
                              characteristic.write(utf8.encode(_writeController.value.text));
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: const Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    });
              },
            ),
          ),
        ),
      );
    }
    if (characteristic.properties.notify) {
      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              child: const Text('NOTIFY', style: TextStyle(color: Colors.black)),
              onPressed: () async {
                characteristic.lastValueStream.listen((value) {
                  setState(() {
                    widget.readValues[characteristic.uuid] = value;
                  });
                });
                await characteristic.setNotifyValue(true);
              },
            ),
          ),
        ),
      );
    }
    return buttons;
  }
  ListView _buildConnectDeviceView() {
      List<Widget> containers = <Widget>[];
      for (BluetoothService service in _services) {
        List<Widget> characteristicsWidget = <Widget>[];
        for (BluetoothCharacteristic characteristic in service.characteristics) {
          characteristicsWidget.add(
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(characteristic.uuid.toString(), style: const TextStyle(fontWeight: 
  FontWeight.bold)),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      ..._buildReadWriteNotifyButton(characteristic),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Builder(
                          builder: (context) {
                            List<int> newValue = widget.readValues[characteristic.uuid] as List<int>? ?? [];
                            // 调用更新字符串的方法
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (mounted) {
                                SecondPage? secondPage = context.findAncestorWidgetOfExactType<SecondPage>();
                                secondPage?.changeBluetoothReadValue(newValue);
                              }
                            });
                            return Text('Value: ${widget.readValues[characteristic.uuid]}');
                          },
                        ),
                      ),
                      // Expanded(child: Text('Value: ${widget.readValues[characteristic.uuid]}')),
                    ],
                  ),
                  const Divider(),
                ],
              ),
            ),
          );
        }
        containers.add(
          ExpansionTile(title: Text(service.uuid.toString()), children: characteristicsWidget),
        );
      }
      return ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          ...containers,
        ],
      );
    }
  ListView _buildView() {
    if (_connectedDevice != null) {
      return _buildConnectDeviceView();
    }
    return _buildListViewOfDevices();
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(widget.title),
    ),
    body: _buildView(),
  );
}

class PercentageArc extends StatelessWidget {
  final double percentage;
  final double size;
  final Color color;
  final Color backgroundColor;
  final String label;

  const PercentageArc({
    Key? key,
    required this.percentage, // From 0 to 100
    this.size = 200,
    this.color = Colors.green,
    this.backgroundColor = Colors.grey,
    this.label = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: ArcPainter(percentage, color, backgroundColor),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${percentage.toInt()}%",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              if (label.isNotEmpty)
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class ArcPainter extends CustomPainter {
  final double percentage;
  final Color color;
  final Color backgroundColor;

  ArcPainter(this.percentage, this.color, this.backgroundColor);

  @override
  void paint(Canvas canvas, Size size) {

    Paint backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15;

    Paint foregroundPaint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15;

    double startAngle = -pi / 2; // Start from the top
    double sweepAngle = (percentage / 100) * 2 * pi; // Convert percentage to angle

    Rect rect = Rect.fromCircle(center: size.center(Offset.zero), radius: size.width / 2);

    // Draw background circle
    canvas.drawArc(rect, 0, 2 * pi, false, backgroundPaint);

    // Draw progress arc
    canvas.drawArc(rect, startAngle, sweepAngle, false, foregroundPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}



