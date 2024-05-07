import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nim/PlayerNameScreen.dart';
import 'package:nim/appcontroller.dart';

void main() {
  runApp(MyApp());
}

int num = 0;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(AppController());
    return GetMaterialApp(
      title: 'Balls Boxes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PlayerNameScreen(),
    );
  }
}
