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


  List<DamageCostBar> get damageCostBars => _damageCostBars;


  void changeDamageCostBarsList(List<DamageCostBar> list) {
    _damageCostBars = list;
    notifyListeners();
  }
}
