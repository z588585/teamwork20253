import 'dart:math';
import 'dart:ui';


import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';



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
  double calories = 0.0;

  @override
  void didUpdateWidget(covariant FirstPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.movementInString != oldWidget.movementInString ||
        widget.movementProbability != oldWidget.movementProbability) {
      if (widget.movementInString == 'Walking') {
        calories += 0.1;
      } else if (widget.movementInString == 'Running') {
        calories += 0.2;
      }
    }
  }

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
                    painter: ArcPainter(
                        widget.movementProbability * 100, Colors.green, Colors.grey),
                  ),
                ),
                Image.asset(
                  imagePath,
                  width: 150,
                  height: 150,
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
                  fontSize: 80,
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
                'percent chance you',
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
            SizedBox(height: 20),
            Text(
              'Calories Burned: ${calories.toStringAsFixed(1)} kcal',
              style: TextStyle(
                fontSize: 24,
                color: const Color(0xFF32A455),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  calories = 0.0;
                });
              },
              child: Text('Reset Calories'),
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
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.1), 
                borderRadius: BorderRadius.circular(12), 
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
            SizedBox(height: 20), 
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
                  fontSize: 9,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  height: 1.5, 
                ),
              ),
            ),
          ],

        )),
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



