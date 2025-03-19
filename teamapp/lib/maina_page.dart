import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';




void main() {runApp(const FigmaToCodeApp());}

class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: Scaffold(
        body: ListView(children: [
          home_main_page(),
        ]),
      ),
    );
  }
}

class home_main_page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 440,
          height: 956,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 6,
                strokeAlign: BorderSide.strokeAlignOutside,
                color: const Color(0xFF757575) /* Icon-Default-Secondary */,
              ),
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          child: Stack(
            children: [
              Positioned(//底部栏
                left: 0,
                top: 863,
                child: Container(
                  width: 440,
                  height: 93,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECE6F0) /* Schemes-Surface-Container-High */,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      Expanded(//home
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 4,
                            children: [
                              Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: ShapeDecoration(
                                  color: const Color(0xFF65558F) /* Schemes-Primary */,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 64,
                                      height: 32,
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(width: 24, height: 24, child: Stack()),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 136,
                                child: Text(
                                  'home',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(0xFF1D1B20) /* Schemes-On-Surface */,
                                    fontSize: 14,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w500,
                                    height: 1.43,
                                    letterSpacing: 0.10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(//arduino
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => arduino_page()),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 64,
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 64,
                                          height: 32,
                                          padding: const EdgeInsets.all(20),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(width: 24, height: 24, child: Stack()),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 136,
                                    child: Text(
                                      'arduino',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: const Color(0xFF49454F) /* Schemes-On-Surface-Variant */,
                                        fontSize: 14,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w500,
                                        height: 1.43,
                                        letterSpacing: 0.10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      Expanded(//setting
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 4,
                            children: [
                              Container(
                                width: 64,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 64,
                                      height: 32,
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        spacing: 10,
                                        children: [
                                          Container(width: 24, height: 24, child: Stack()),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 136,
                                child: Text(
                                  'setting',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(0xFF49454F) /* Schemes-On-Surface-Variant */,
                                    fontSize: 14,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w500,
                                    height: 1.43,
                                    letterSpacing: 0.10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(//中间内容
                left: 0,
                top: 94,
                child: Container(
                  width: 440,
                  height: 769,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF7FF) /* Schemes-Surface */,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          width: 416,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFECE6F0) /* Schemes-Surface-Container-High */,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            shadows: [
                              BoxShadow(
                                color: Color(0x4C000000),
                                blurRadius: 3,
                                offset: Offset(0, 1),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                          child: Stack(
                            children: [
                              Positioned(//概率
                                left: 63,
                                top: 460,
                                child: SizedBox(
                                  width: 292,
                                  height: 110,
                                  child: Text(
                                    '63%',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: const Color(0xFF4F378A) /* Schemes-On-Primary-Container */,
                                      fontSize: 96,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w900,
                                      shadows: [Shadow(offset: Offset(0, 2), blurRadius: 3, color: Color(0xFF000000).withOpacity(0.30))],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(//你正在干xxx的几率
                                left: 65,
                                top: 583,
                                child: SizedBox(
                                  width: 288,
                                  height: 34,
                                  child: Text(
                                    'percent chance you are',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: const Color(0xFF32A455),
                                      fontSize: 24,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w900,
                                      shadows: [Shadow(offset: Offset(0, 2), blurRadius: 3, color: Color(0xFF000000).withOpacity(0.30))],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(//干的事情
                                left: 15,
                                top: 624,
                                child: SizedBox(
                                  width: 385,
                                  height: 82,
                                  child: Text(
                                    'running',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: const Color(0xFF4F378A) /* Schemes-On-Primary-Container */,
                                      fontSize: 64,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w900,
                                      shadows: [Shadow(offset: Offset(0, 2), blurRadius: 3, color: Color(0xFF000000).withOpacity(0.30))],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(//图片
                                left: 1,
                                top: 0,
                                child: Container(
                                  width: 415,
                                  height: 436,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(//顶部栏
                left: 0,
                top: 52,
                child: Container(
                  width: 440,
                  height: 42,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 440,
                          height: 42,
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECE6F0) /* Schemes-Surface-Container-High */,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x26000000),
                                blurRadius: 6,
                                offset: Offset(0, 2),
                                spreadRadius: 2,
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned( //左 包括home
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 440,
                          height: 42,
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECE6F0) /* Schemes-Surface-Container-High */,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x26000000),
                                blurRadius: 6,
                                offset: Offset(0, 2),
                                spreadRadius: 2,
                              )
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 4,
                            children: [
                              Container(
                                width: 48,
                                height: 30,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  spacing: 10,
                                  children: [
                                  
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 328,
                                child: Text(
                                  'home',
                                  style: TextStyle(
                                    color: const Color(0xFF1D1B20) /* Schemes-On-Surface */,
                                    fontSize: 22,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                    height: 1.27,
                                  ),
                                ),
                              ),
                              Container(
                                width: 48,
                                height: 48,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 0,
                                      top: 0,
                                      child: Container(
                                        width: 48,
                                        height: 48,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          spacing: 10,
                                          children: [
                                            Container(
                                              clipBehavior: Clip.antiAlias,
                                              decoration: ShapeDecoration(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(100),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                spacing: 10,
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.all(8),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      spacing: 10,
                                                      children: [
                                                        Container(width: 24, height: 24, child: Stack()),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(//最顶部栏
                left: 0,
                top: 0,
                child: Container(
                  width: 440,
                  height: 52,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: const Color(0xFFECE6F0) /* Schemes-Surface-Container-High */,
                  ),
                ),
              ), 
            ],
          ),
        ),
      ],
    );
  }
}

class arduino_page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 440,
          height: 956,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 6,
                strokeAlign: BorderSide.strokeAlignOutside,
                color: const Color(0xFF757575) /* Icon-Default-Secondary */,
              ),
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          child: Stack(
            children: [
              Positioned(//底部栏
                left: 0,
                top: 863,
                child: Container(
                  width: 440,
                  height: 93,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECE6F0) /* Schemes-Surface-Container-High */,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      Expanded(//home
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 4,
                            children: [
                              Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: ShapeDecoration(
                                  color: const Color(0xFF65558F) /* Schemes-Primary */,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 64,
                                      height: 32,
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(width: 24, height: 24, child: Stack()),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 136,
                                child: Text(
                                  'home',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(0xFF1D1B20) /* Schemes-On-Surface */,
                                    fontSize: 14,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w500,
                                    height: 1.43,
                                    letterSpacing: 0.10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(//arduino
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 4,
                            children: [
                              Container(
                                width: 64,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 64,
                                      height: 32,
                                      padding: const EdgeInsets.all(20),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        spacing: 10,
                                        children: [
                                          Container(width: 24, height: 24, child: Stack()),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 136,
                                child: Text(
                                  'arduino',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(0xFF49454F) /* Schemes-On-Surface-Variant */,
                                    fontSize: 14,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w500,
                                    height: 1.43,
                                    letterSpacing: 0.10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(//setting
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 4,
                            children: [
                              Container(
                                width: 64,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 64,
                                      height: 32,
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        spacing: 10,
                                        children: [
                                          Container(width: 24, height: 24, child: Stack()),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 136,
                                child: Text(
                                  'setting',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(0xFF49454F) /* Schemes-On-Surface-Variant */,
                                    fontSize: 14,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w500,
                                    height: 1.43,
                                    letterSpacing: 0.10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(//中间内容
                left: 0,
                top: 94,
                child: Container(
                  width: 440,
                  height: 769,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF7FF) /* Schemes-Surface */,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                    ],
                  ),
                ),
              ),
              Positioned(//顶部栏
                left: 0,
                top: 52,
                child: Container(
                  width: 440,
                  height: 42,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 440,
                          height: 42,
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECE6F0) /* Schemes-Surface-Container-High */,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x26000000),
                                blurRadius: 6,
                                offset: Offset(0, 2),
                                spreadRadius: 2,
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned( //左 包括home
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 440,
                          height: 42,
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECE6F0) /* Schemes-Surface-Container-High */,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x26000000),
                                blurRadius: 6,
                                offset: Offset(0, 2),
                                spreadRadius: 2,
                              )
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 4,
                            children: [
                              Container(
                                width: 48,
                                height: 30,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  spacing: 10,
                                  children: [
                                  
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 328,
                                child: Text(
                                  'home',
                                  style: TextStyle(
                                    color: const Color(0xFF1D1B20) /* Schemes-On-Surface */,
                                    fontSize: 22,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                    height: 1.27,
                                  ),
                                ),
                              ),
                              Container(
                                width: 48,
                                height: 48,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 0,
                                      top: 0,
                                      child: Container(
                                        width: 48,
                                        height: 48,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          spacing: 10,
                                          children: [
                                            Container(
                                              clipBehavior: Clip.antiAlias,
                                              decoration: ShapeDecoration(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(100),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                spacing: 10,
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.all(8),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      spacing: 10,
                                                      children: [
                                                        Container(width: 24, height: 24, child: Stack()),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(//最顶部栏
                left: 0,
                top: 0,
                child: Container(
                  width: 440,
                  height: 52,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: const Color(0xFFECE6F0) /* Schemes-Surface-Container-High */,
                  ),
                ),
              ), 
            ],
          ),
        ),
      ],
    );
  }
}