import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math';

import '../entities/DamageCostBar.dart';

class SampleProvider with ChangeNotifier {
  List<DamageCostBar> _damageCostBars = [
    DamageCostBar("Agaton", 1652374),
    DamageCostBar("Yolandie", 2398746),
    DamageCostBar("Fufu", 5872635),
    DamageCostBar("Zebra", 10000000),
    DamageCostBar("Zebra", 10000000),
    DamageCostBar("Zebra", 10000000)
  ];

  //todo TEST ONLY
  Timer? timer;
  List<DamageCostBar> _testList = [];

  List<DamageCostBar> get damageCostBars => _damageCostBars;

  //todo TEST ONLY
  List<DamageCostBar> get testList => _testList;

  //todo TEST ONLY
  void appendBar() {
    // Future.delayed(Duration(seconds: 1), (() {
      
    // }));
    _testList.add(DamageCostBar("Haiyan", Random().nextInt(9000000)));
    notifyListeners();
  }

  //todo TEST ONLY
  //param: int dmgcost
  void startTimer(){
    Timer.periodic(Duration(seconds: 1), (timer) {
      appendBar();
     });
  }

  void changeDamageCostBarsList(List<DamageCostBar> list) {
    _damageCostBars = list;
    notifyListeners();
  }

  // void initializeBarChart(){
  //   final list = [DamageCostBar("Agaton", 1652374),
  //   DamageCostBar("Yolandie", 2398746),
  //   DamageCostBar("Fufu", 5872635)];
  //   _damageCostBars = list;
  //   notifyListeners();
  // }
}
